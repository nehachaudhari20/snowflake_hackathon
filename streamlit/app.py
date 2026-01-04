import streamlit as st

try:
    from snowflake.snowpark.context import get_active_session
except ImportError:
    get_active_session = None

st.set_page_config(
    page_title="Privacy-Safe Cross-Organization RCA",
    layout="wide"
)

st.title("Privacy-Safe Cross-Organization Risk & RCA")

st.markdown("""
This application displays **precomputed, governed population-level insights**
stored directly in Snowflake.  
All analytics, RCA, and privacy logic are enforced in SQL.
""")

# Guard for local execution
if get_active_session is None:
    st.warning("This app is designed to run inside Snowflake.")
    st.stop()

session = get_active_session()

session = get_active_session()

df = session.sql("""
    SELECT *
    FROM INSURANCE_DB.RAW_DATA.population_risk_rca_view
    ORDER BY combined_risk DESC
""").to_pandas()

df.columns = [c.lower() for c in df.columns]


# ---------------------------------------------------------
# SECTION 1 — Cohort Selection (Dropdowns)
# ---------------------------------------------------------
st.subheader("🔍 Select Population Cohort")

age_options = sorted(df["age_group"].unique())
region_options = sorted(df["region"].unique())

selected_age = st.selectbox("Age Group", age_options)
selected_region = st.selectbox("Region", region_options)

selected_df = df[
    (df["age_group"] == selected_age) &
    (df["region"] == selected_region)
]

# ---------------------------------------------------------
# SECTION 2 — Selected Cohort Insights
# ---------------------------------------------------------
if not selected_df.empty:
    row = selected_df.iloc[0]

    st.subheader("🧠 Cohort Risk & RCA Summary")

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric("Combined Risk", row["combined_risk"])

    with col2:
        st.metric("Cohort Size", row["cohort_size"])

    with col3:
        st.metric("Confidence", row["rca_confidence"])

    st.markdown(f"**Root Cause:** {row['root_cause']}")
    st.markdown(f"**Suggested Intervention:** {row['suggested_intervention']}")
    st.markdown(f"**Privacy Guarantee:** {row['privacy_guarantee']}")

else:
    st.warning("No data available for the selected cohort.")

# ---------------------------------------------------------
# SECTION 3 — Full Population Overview (Optional)
# ---------------------------------------------------------
with st.expander("📊 View All Population Risk Data"):
    st.dataframe(df, use_container_width=True)

# ---------------------------------------------------------
# SECTION 4 — Executive Highlight
# ---------------------------------------------------------
top = df.iloc[0]
st.info(
    f"📌 Highest overall risk observed in **{top['age_group']} ({top['region']})** "
    f"with combined risk **{top['combined_risk']}**, "
    f"driven by **{top['root_cause']}** "
    f"({top['rca_confidence']})."
)
