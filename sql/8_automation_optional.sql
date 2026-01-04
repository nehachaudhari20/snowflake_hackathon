-- Streams & Tasks (optional, keep task suspended)

CREATE OR REPLACE VIEW combined_risk_view AS
SELECT
    b.age_group,
    b.region,
    ROUND(AVG(b.default_rate) + AVG(i.claim_rate), 3) AS combined_risk,
    SUM(b.txn_count + i.claim_count) AS cohort_size
FROM BANK_DB.RAW_DATA.bank_safe_view b
JOIN INSURANCE_DB.RAW_DATA.insurance_safe_view i
    ON b.age_group = i.age_group
   AND b.region = i.region
GROUP BY b.age_group, b.region
HAVING cohort_size >= 200;

CREATE OR REPLACE TASK recompute_combined_risk
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC'
AS
SELECT * FROM combined_risk_view;
