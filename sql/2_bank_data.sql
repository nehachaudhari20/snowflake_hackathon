-- Phase 3: Bank de-identified population data

USE DATABASE BANK_DB;
USE SCHEMA RAW_DATA;

CREATE OR REPLACE TABLE bank_risk_summary (
    age_group STRING,
    region STRING,
    default_rate FLOAT,
    txn_count INT
);

INSERT INTO bank_risk_summary VALUES
('18-25', 'Urban', 0.12, 300),
('26-35', 'Urban', 0.18, 600),
('36-45', 'Urban', 0.09, 500),
('26-35', 'Rural', 0.21, 200),
('36-45', 'Rural', 0.11, 250);
