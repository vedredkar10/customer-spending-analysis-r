# Customer Spending Analysis in R

A comprehensive data analysis project using R to explore wholesale customer spending patterns. The project combines **descriptive statistics**, **probability modeling**, **logistic regression**, and **statistical testing** to uncover actionable business insights that can support **targeted marketing**, **inventory optimization**, and **regional growth strategies**.

---

## Project Overview
This project analyzes wholesale customer data to:
- Identify **high-value customer segments**.
- Understand **regional differences** in spending behavior.
- Determine **key product drivers** influencing customer type (Hotel/Restaurant/Café vs. Retail).
- Forecast customer spending using **probability distributions**.

The analysis leverages advanced statistical techniques and visualizations to help wholesalers make **data-driven decisions** on marketing campaigns, product allocation, and regional strategies.

---

## Key Insights
- **High variability in Fresh and Grocery spending**  
  → Indicates diverse purchasing patterns and opportunities for targeted promotions.

- **Detergent spending as the strongest predictor of customer channel**  
  → Logistic regression achieved up to **89.7% accuracy** in predicting whether a customer belongs to the HoReCa or Retail channel.

- **Regional growth opportunities**  
  → *Rest of Portugal* customers have the highest spending on Fresh and Delicatessen categories, making them ideal for growth campaigns.

- **Spending probability forecasting**  
  → **45.5% probability** that customers spend over **€10,000 annually** on Fresh products, providing key insights for inventory planning and promotions.

---

## Methodology
The project was structured into the following key steps:

1. **Data Preprocessing**
   - Checked data structure and handled missing values.
   - Sampled data for efficient analysis.

2. **Exploratory Data Analysis (EDA)**
   - Summary statistics and regional spending comparisons.
   - Segmentation by customer type and region.

3. **Data Visualization**
   - Histograms for univariate analysis.
   - Correlation matrix to identify relationships between spending categories.
   - Boxplots for regional and channel-based analysis.

4. **Probability Distribution Modeling**
   - Modeled Fresh spending using **Gamma distribution** to forecast high-spending customers.

5. **Logistic Regression**
   - Identified **Detergent** as the most significant variable for predicting customer type.
   - Improved model accuracy by focusing on key predictors.

6. **Regional Analysis**
   - Conducted **ANOVA** and **pairwise t-tests** to evaluate differences in regional spending patterns.

---

## Tools & Technologies
- **Programming Language:** R  
- **Libraries Used:**  
  `dplyr`, `ggplot2`, `caret`, `tclust`, `fitdistrplus`, `corrplot`
- **Statistical Methods:**
  - Descriptive Statistics
  - Probability Distributions (Gamma, Log-normal)
  - Logistic Regression
  - ANOVA and Pairwise T-tests

---

## Results
| Analysis Area            | Key Outcome |
|--------------------------|-------------|
| Logistic Regression      | Detergent spending predicts channel type with **89.7% accuracy** |
| Probability Forecasting  | **45.5% chance** of customers spending > €10,000 annually on Fresh products |
| Regional Analysis        | Rest of Portugal is the highest spending region for Fresh products |
| EDA Findings             | Strong positive correlation between Grocery and Detergent spending |
<img width="635" height="251" alt="Image5_CSA" src="https://github.com/user-attachments/assets/facb049c-6db3-4701-b3a8-ac9786e0bacb" />
<img width="816" height="173" alt="Image6_CSA" src="https://github.com/user-attachments/assets/12289b8b-c3f9-42af-975d-1d0cc76f64c9" />

---

## Repository Structure
```
customer-spending-analysis-r/
│
├── data/                  # Raw and processed datasets
│
├── scripts/               # R scripts for each analysis stage
│   ├── data_cleaning.R
│   ├── eda_visualizations.R
│   ├── probability_model.R
│   └── logistic_regression.R
│
├── outputs/               # Reports and visualizations
│   ├── figures/           # Saved plots
│   └── reports/           # Final reports or documents
│
└── README.md              # Project documentation
```
