# Privacy-Safe Cross-Organization Risk & RCA

**AI for Good | Snowflake Hackathon**

## Overview

Organizations such as banks and insurers often need to collaborate to understand **population-level risk patterns** (e.g., financial stress, claim burden, underserved segments). However, **privacy regulations, trust boundaries, and governance constraints** prevent them from sharing raw customer data.

This project demonstrates a **Snowflake-native, privacy-safe data application** that enables **cross-organization risk analysis and root cause analysis (RCA)** using **only aggregated, de-identified data**.
All analytics and reasoning are enforced **inside Snowflake using governed SQL**, while the user interface simply renders approved outputs.

---

## Problem Statement

* Multiple organizations hold **complementary risk signals** (e.g., banking defaults and insurance claims).
* Sharing raw or individual-level data is **not allowed** due to privacy and compliance constraints.
* Decision-makers still need **joint insights**, explanations, and confidence to act.

### Key Questions Answered

* Which population cohorts show the highest combined risk?
* What is the **dominant contributing factor** (banking vs insurance)?
* How confident are these insights?
* What interventions are recommended?
* Why can these insights be trusted from a privacy perspective?

---

## Solution Summary

We design a **shared analysis zone** inside Snowflake where:

* Each organization keeps its data in **separate databases**
* Only **secure, aggregated views** are exposed
* Cross-organization insights are computed via **governed SQL**
* A **population-level RCA layer** explains *why* risk is high
* Privacy guarantees are explicit and auditable
* A **Snowflake Streamlit app** enables interactive exploration

No raw records.
No PII.
No external processing.

---

## Architecture (High Level)

```
[ Bank DB ]            [ Insurance DB ]
   |                        |
   | Secure Views           | Secure Views
   |                        |
   +---------- JOIN / AGGREGATION ----------+
                 |
        Population Risk & RCA View
                 |
        (Combined Risk, Root Cause,
         Confidence, Action, Privacy)
                 |
        Snowflake Streamlit App
         (Read-only, interactive UI)
```

---

## Core Features

### 1. Privacy by Design

* Only **population-level aggregates** are used
* Minimum cohort thresholds enforced
* No individual-level joins or identifiers

### 2. Cross-Organization Risk Computation

* Combines banking default rates and insurance claim rates
* Computes a unified **combined risk score**

### 3. Population-Level Root Cause Analysis (RCA)

* Categorizes risk as:

  * Financial stress driven
  * Non-financial stress driven
  * Systemic / mixed stress
  * Low or emerging risk
* Fully explainable and deterministic

### 4. Confidence Scoring

* Confidence derived from **cohort size**
* Makes uncertainty explicit for decision-makers

### 5. Actionable Insights

* Suggested interventions vary by:

  * Risk severity
  * Dominant contributing factor
* Enables policy and program planning

### 6. Explicit Privacy Guarantees

* Privacy guarantees are **computed**, not assumed
* Based on aggregation strength and cohort size

---

## Snowflake Capabilities Used

* **Secure Views** – Clean Room–style isolation
* **Snowflake Horizon (Tags)** – Governance and metadata
* **SQL / Snowsight** – Core analytics and reasoning
* **Streamlit in Snowflake** – Native data application UI
* **Streams & Tasks** – Optional automation (future-ready)

> All intelligence lives in SQL.
> Streamlit is a pure rendering layer.

---

## Data Model (Simplified)

### Bank (Aggregated)

* `age_group`
* `region`
* `default_rate`
* `txn_count`

### Insurance (Aggregated)

* `age_group`
* `region`
* `claim_rate`
* `claim_count`

### Final Output View

* `combined_risk`
* `cohort_size`
* `root_cause`
* `rca_confidence`
* `suggested_intervention`
* `privacy_guarantee`

---

## Streamlit Application

The Streamlit app runs **entirely inside Snowflake** and allows users to:

* Select population cohorts via dropdowns
* View combined risk, RCA, confidence, actions, and privacy guarantees
* Explore all cohorts in a governed, read-only table
* Identify the highest-risk cohort instantly

No external credentials or infrastructure required.

---

## How to Run

### 1. SQL Setup (Snowflake)

Run the SQL files in order:

1. Create databases and schemas
2. Load aggregated bank and insurance data
3. Create secure views
4. Create the final `population_risk_rca_view`

### 2. Streamlit App

* Create a new **Streamlit app inside Snowflake**
* Paste `streamlit/app.py`
* Run using a small warehouse

---

## Why This Is AI for Good

* Enables **better protection and inclusion** without compromising privacy
* Supports **fairer, data-driven decisions** across organizations
* Reduces reliance on opaque models by using **explainable, governed logic**
* Demonstrates how AI-adjacent reasoning can be applied responsibly

---

## Key Design Principle

> **Trust comes from governance, not just intelligence.**

This project prioritizes:

* Explainability over black-box predictions
* Privacy over raw data access
* Architecture over ad-hoc dashboards

---

## Future Extensions

* Snowflake Native App packaging for reuse
* Cortex AI–based natural-language explanations (optional)
* Dynamic Tables for automatic refresh
* Additional organizations (e.g., public agencies, NGOs)

---

## Final Note

This is not a demo dashboard.
It is a **privacy-safe, cross-organization decision support system**, built the way real enterprises build data products — **inside Snowflake**.



