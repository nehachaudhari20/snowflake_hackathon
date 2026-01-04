import streamlit as st
from snowflake.snowpark.context import get_active_session

st.set_page_config(page_title="Privacy-Safe Cross-Org RCA", layout="wide")

st.title("Privacy-Safe Cross-Organization Risk RCA")

st.markdown("""
This application shows **population-level risk insights and root cause analysis**
across organizations, using **privacy-safe aggregated data only**.
""")

session = get_active_session()

query = """
SELECT
    b.age_group,
    b.region,
    ROUND(AVG(b.default_rate) + AVG(i.claim_rate), 3) AS combined_risk,
    SUM(b.txn_count + i.claim_count) AS cohort_size,

    CASE
        WHEN AVG(b.default_rate) > 0.2 AND AVG(i.claim_rate) < 0.1
        THEN 'Financial stress driven'
        WHEN AVG(i.claim_rate) > 0.1 AND AVG(b.default_rate) < 0.15
        THEN 'Non-financial stress driven'
        WHEN AVG(b.default_rate) > 0.15 AND AVG(i.claim_rate) > 0.1
        THEN 'Systemic stress'
        ELSE 'Monitor'
    END AS root_cause,

    CASE
        WHEN SUM(b.txn_count + i.claim_count) >= 1000 THEN 'High'
        WHEN SUM(b.txn_count + i.claim_count) >= 400 THEN 'Medium'
        ELSE 'Low'
    END AS confidence

FROM BANK_DB.RAW_DATA.bank_safe_view b
JOIN INSURANCE_DB.RAW_DATA.insurance_safe_view i
    ON b.age_group = i.age_group
   AND b.region = i.region
GROUP BY b.age_group, b.region
HAVING cohort_size >= 200;
"""

df = session.sql(query).to_pandas()
st.dataframe(df, use_container_width=True)
