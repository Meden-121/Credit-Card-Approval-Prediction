# 🏦 Credit Risk Prediction — Automated Default Detection System

## 1. Overview

This project builds an end-to-end credit card default prediction system that combines SQL-based data engineering, Power BI exploratory analysis, and machine learning to help banks automate applicant screening, reduce financial risk, and allocate underwriting resources more efficiently.

The production model is **CatBoost (Tuned, Threshold = 0.62)**, selected after benchmarking against Random Forest and XGBoost on ROC-AUC, PR-AUC, and F1-score under severe class imbalance (default rate = **1.69%**).

---

## 2. Key Highlights

- **ROC-AUC of 0.7532** — CatBoost outperforms Random Forest (0.6918) and XGBoost (0.7366), demonstrating the strongest ability to separate good and bad credit applicants.
- **PR-AUC of 0.1592** — The highest among all tested models, meaning CatBoost is the most effective at detecting rare default cases even when they represent only 1.69% of the dataset.
- **Threshold optimization at 0.62** — Yields Precision 26%, Recall 25%, and F1-score 0.256, striking a practical balance between false alarms and missed defaults for operational use.
- **Estimated 20–30% reduction in manual review time** — By automatically filtering high-risk applications before they reach the underwriting team, the model frees up assessment capacity and enables risk-based pricing strategies.

---

## 3. Project Pipeline

### 3.1 Data Preprocessing — SQL Server (`02_credit_risk_data_preprocessing.sql`)

Raw credit bureau and application data are transformed into a modelling-ready dataset via a multi-step T-SQL pipeline:

- **Risk Score Mapping:** Monthly repayment statuses (`C`, `X`, `0`–`5`) are converted to a numerical risk scale (0–6), where 0 = fully paid and 6 = written off (>150 days overdue).
- **Target Variable Construction:** `TARGET = 1` if a customer's peak risk score ever reached ≥ 3 (60+ days overdue); otherwise 0.
- **Feature Engineering:** Derived features include `AGE` (from `DAYS_BIRTH`), `EMPLOYED_YRS` (from `DAYS_EMPLOYED`, with outlier handling), `MONTHS_SINCE_OPEN` (credit history length), and `COUNT_MAJOR_DEFAULT` (frequency of serious delinquency).
- **Data Standardisation:** Categorical fields (education type, marital status, housing type) are normalised for consistency. Missing occupation values are imputed as `'Unknown'`. Duplicate `ID` records are deduplicated using `ROW_NUMBER()`.

### 3.2 Exploratory Data Analysis — Power BI (`04_credit_risk_dashboard.pbix`)

An interactive dashboard is built prior to modelling to surface patterns in the data:

- Visualises default rate distributions across income brackets, occupation types, age groups, and housing categories.
- Highlights "risk zones" — customer segments with disproportionately high `MAX_RISK_SCORE` — that inform feature selection.
- Serves as a communication layer between the data pipeline and modelling decisions.

### 3.3 Machine Learning — Python / Jupyter (`05_credit_risk_modeling.ipynb`)

- **Imbalance Handling:** SMOTE (Synthetic Minority Over-sampling Technique) is applied to the minority class (`TARGET = 1`) to prevent model bias toward predicting non-default.
- **Algorithm:** CatBoost Classifier, chosen for its native handling of categorical variables and robustness to overfitting relative to standard GBM implementations.
- **Benchmarking:** Models compared on ROC-AUC, PR-AUC, Precision, Recall, and F1-score. CatBoost is selected for deployment.
- **Threshold Tuning:** Decision threshold adjusted from the default 0.5 to 0.62 to maximise F1-score given the class imbalance.

---

## 4. Model Performance Summary

| Model | ROC-AUC | PR-AUC |
|---|---|---|
| Random Forest | 0.6918 | — |
| XGBoost | 0.7366 | — |
| **CatBoost (selected)** | **0.7532** | **0.1592** |

**CatBoost at Threshold = 0.62:**

| Metric | Value |
|---|---|
| Precision | 26% |
| Recall | 25% |
| F1-Score | 0.256 |

---

## 5. Business Applications

The model serves as the core engine for three operational use cases:

- **Automated Pre-screening:** Flags high-risk applications before manual review, reducing workload for the underwriting team by an estimated 20–30%.
- **Credit Scoring:** Segments applicants into Low / Medium / High risk tiers for tiered decision workflows.
- **Risk-based Pricing:** Provides a data-driven basis for setting interest rates proportional to individual default probability.

---

## 6. Tech Stack

| Layer | Tools |
|---|---|
| Database & Preprocessing | SQL Server (T-SQL) |
| EDA & Visualisation | Power BI |
| Language | Python 3 |
| Data Processing | Pandas, NumPy, Scikit-learn |
| Imbalance Handling | Imbalanced-learn (SMOTE) |
| Machine Learning | CatBoost Classifier |
| Environment | Jupyter Notebook |

---

## 7. Project Structure

```
├── 02_credit_risk_data_preprocessing.sql   # SQL pipeline: scoring, feature eng, cleaning
├── 03_credit_risk_dataset_processed.csv    # Final modelling-ready dataset
├── 04_credit_risk_dashboard.pbix           # Power BI EDA dashboard
├── 05_credit_risk_modeling.ipynb           # ML training, evaluation, threshold tuning
└── README.md
```
**8. Dataset:**

Link: https://drive.google.com/drive/folders/1bvFByJnCoA3n4XEJnEZWg8NJnvhUZMVY?usp=sharing











