-- Horizon governance tags

CREATE TAG IF NOT EXISTS sensitivity_level;
CREATE TAG IF NOT EXISTS data_domain;

ALTER TABLE BANK_DB.RAW_DATA.bank_risk_summary
MODIFY COLUMN default_rate
SET TAG sensitivity_level = 'financial_risk';

ALTER TABLE BANK_DB.RAW_DATA.bank_risk_summary
MODIFY COLUMN txn_count
SET TAG data_domain = 'population_aggregate';

ALTER TABLE INSURANCE_DB.RAW_DATA.insurance_claim_summary
MODIFY COLUMN claim_rate
SET TAG sensitivity_level = 'insurance_risk';

ALTER TABLE INSURANCE_DB.RAW_DATA.insurance_claim_summary
MODIFY COLUMN claim_count
SET TAG data_domain = 'population_aggregate';
