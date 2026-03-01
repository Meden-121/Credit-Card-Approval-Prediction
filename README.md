🏦 Credit Risk Prediction – Default Detection System
📌**1. Project Overview**
- This project is designed to assess the likelihood of customer default when applying for a credit card. By combining historical data analysis and machine learning algorithms, the system helps banks automate the approval process, minimize financial risk, and optimize operational resources.
- The final deployed model is CatBoost (Tuned + Optimized Threshold), selected based on ROC-AUC, PR-AUC, and F1 performance under severe class imbalance (default rate = 1.69%)

**2. Project Pipeline**
**2.1. Data Preprocessing with SQL** (02_credit_risk_data_preprocessing.sql.sql)
- Calculate Risk Score: Convert monthly payment status (C, X, 0-5) to a numerical scale to quantify the level of risk.

- Feature Engineering: Calculate years employed (EMPLOYED_YRS), age (AGE), and months since account opening (MONTHS_SINCE_OPEN).

- Data Standardization: Clean categorical variables (Education, Marital Status, Housing Type) to ensure consistency for the model.

**2.2. Exploratory Data Analysis (EDA) via Power BI** (04_credit_risk_dashboard.pbix)

- Objective: Perform EDA before building a model to gain a deeper understanding of the customer profile.

- Content: The dashboard visualizes the correlations between income, job type, age, and the bad debt ratio. It helps to identify data trends and potential features for the model.

**2.3. Machine Learning Model Building** (05_credit_risk_modeling.ipynb)

- Handling Imbalanced Data: Due to the typically small proportion of bad debt records (Target = 1), the project employs the SMOTE (Synthetic Minority Over-sampling Technique) technique to generate additional artificial data for the minority class. This helps prevent model bias and improves the identification of bad debt.

- Algorithm: Uses CatBoost Classifier, a powerful Gradient Boosting algorithm capable of effectively handling categorical variables without requiring extensive manual encoding steps.

**3. CatBoost Performance Results:**

The CatBoost model demonstrates superiority through specific technical indicators:

- Generalization ability: Achieves a ROC-AUC of 0.7532, significantly higher than Random Forest (0.6918) and XGBoost (0.7366).

- Handling imbalanced data: Achieves a PR-AUC of 0.1592 (highest among the models), indicating a very effective ability to identify bad debt groups (minority).
 
- Threshold optimization (Threshold = 0.62): Achieves an ideal balance point with Precision 26%, Recall 25%, and F1-score 0.256.

**4. Practical Application Value:**
The CatBoost model serves as the technological "core" for systems like:

- Credit Scoring: Automatically classifies customers into risk segments: Low - Medium - High.

- Pre-screening: Immediately eliminates high-risk applications, optimizing resources for the appraisal department.

- Risk-based Pricing: Sets loan interest rates commensurate with the risk level of each individual.

**5. Tech Stack**
Database:	SQL Server (T-SQL)
EDA & Visualization:	Power BI
Programming Language:	Python 
Data Processing:	Pandas, NumPy, Scikit-learn
Imbalance Handling:	Imbalanced-learn (SMOTE)
Machine Learning:	CatBoost Classifier
Environment:	Jupyter Notebook

🔎**6. Key Insights & Business Value**

Through Exploratory Data Analysis (EDA) on Power BI and CatBoost model evaluation, the project has drawn the following strategic insights:

**6.1. Risk Profile of Risky Customers**

- Extremely low bad debt ratio: Data shows that the actual default rate is only 1.69%. This indicates a serious imbalance in the dataset, posing a significant challenge for identifying bad customers without techniques like SMOTE.

- Occupation & Income Factors: Customer groups with low average income and unstable jobs tend to have higher risk scores (MAX_RISK_SCORE). Analysis on Power BI helps identify "red zones" in customer segments before feeding them into the model.

**6.2. Why choose CatBoost as the deployment model?**

- After comparison with Random Forest and XGBoost, CatBoost was chosen as the "heart" of the system because:

- Superior classification ability: With a ROC-AUC of 0.7532, CatBoost has a strong ability to separate "Good" and "Bad" customer groups.

- Effective with skewed data: The PR-AUC score reached 0.1592 (highest among the models), proving that CatBoost is extremely sensitive in detecting bad debt groups, even though they only account for a very small proportion.

**6.3. Operational value after optimization (Threshold = 0.62)**
By adjusting the decision threshold to 0.62 to achieve the optimal F1-score, the model provides a practical balance for the bank:

- Precision (26%): Ensures that among customers flagged as risky by the model, the accuracy rate is high enough to avoid wasting assessment resources.

- Recall (25%): Helps the bank proactively "block" about 1/4 of potential bad debt cases right from the automatic filtering stage.

- Stability: CatBoost handles categorical data more naturally and smoothly, limiting overfitting compared to other algorithms.

**6.4. Business Impact**
Automated Scorecard system: Shifts from subjective assessment to data-driven scoring.

- Pre-screening filter: Saves 20-30% of time for the appraisal department by automatically eliminating files with a high probability of bad debt exceeding the threshold.

- Interest rate strategy: Provides a database for applying Risk-based Pricing (low-risk individuals enjoy preferential interest rates, high-risk individuals must bear a larger risk insurance fee).












