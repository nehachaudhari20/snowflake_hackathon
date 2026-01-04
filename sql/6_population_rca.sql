-- Phase 6: Population-level Root Cause Analysis (RCA)

SELECT
    b.age_group,
    b.region,
    ROUND(AVG(b.default_rate) + AVG(i.claim_rate), 3) AS combined_risk,
    SUM(b.txn_count + i.claim_count) AS cohort_size,

    CASE
        WHEN AVG(b.default_rate) > 0.2 AND AVG(i.claim_rate) < 0.1
        THEN 'Financial stress driven (bank defaults dominate)'

        WHEN AVG(i.claim_rate) > 0.1 AND AVG(b.default_rate) < 0.15
        THEN 'Non-financial stress driven (insurance claims dominate)'

        WHEN AVG(b.default_rate) > 0.15 AND AVG(i.claim_rate) > 0.1
        THEN 'Systemic stress (multiple contributing factors)'

        ELSE 'Low or emerging risk (monitor)'
    END AS root_cause,

    CASE
        WHEN SUM(b.txn_count + i.claim_count) >= 1000 THEN 'High confidence'
        WHEN SUM(b.txn_count + i.claim_count) >= 400 THEN 'Medium confidence'
        ELSE 'Low confidence'
    END AS rca_confidence,

    CASE
        WHEN AVG(b.default_rate) > AVG(i.claim_rate)
        THEN 'Targeted financial relief or credit restructuring'
        ELSE 'Policy review or preventive insurance coverage'
    END AS suggested_intervention,

    'RCA performed on aggregated, de-identified population data only.' AS privacy_guarantee

FROM BANK_DB.RAW_DATA.bank_safe_view b
JOIN INSURANCE_DB.RAW_DATA.insurance_safe_view i
    ON b.age_group = i.age_group
   AND b.region = i.region
GROUP BY b.age_group, b.region
HAVING cohort_size >= 200;
