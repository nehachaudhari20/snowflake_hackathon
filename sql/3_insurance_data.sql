-- Phase 4: Insurance de-identified population data

USE DATABASE INSURANCE_DB;
USE SCHEMA RAW_DATA;

CREATE OR REPLACE TABLE insurance_claim_summary (
    age_group STRING,
    region STRING,
    claim_rate FLOAT,
    claim_count INT
);

INSERT INTO insurance_claim_summary VALUES
('18-25', 'Urban', 0.05, 150),
('26-35', 'Urban', 0.08, 400),
('36-45', 'Urban', 0.06, 350),
('26-35', 'Rural', 0.09, 180),
('36-45', 'Rural', 0.07, 200);
