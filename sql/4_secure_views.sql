-- Phase 5: Secure views (Clean Room boundary)

USE DATABASE BANK_DB;
USE SCHEMA RAW_DATA;

CREATE OR REPLACE SECURE VIEW bank_safe_view AS
SELECT age_group, region, default_rate, txn_count
FROM bank_risk_summary;

USE DATABASE INSURANCE_DB;
USE SCHEMA RAW_DATA;

CREATE OR REPLACE SECURE VIEW insurance_safe_view AS
SELECT age_group, region, claim_rate, claim_count
FROM insurance_claim_summary;
