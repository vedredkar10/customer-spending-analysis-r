# customer-spending-analysis-r
R project analyzing wholesale customer spending patterns using descriptive stats, probability distributions, and logistic regression for targeted marketing insights.
## Project Overview
This project analyzes customer spending behavior in the wholesale dataset using **R**.  
The goal was to identify high-value customer segments, regional differences, and product-category insights that can support **targeted marketing strategies and better resource allocation**.  

## Tools & Libraries
- R (dplyr, ggplot2, stats, caret)
- Statistical methods: Descriptive analysis, Probability distributions (Gamma), Logistic Regression, ANOVA
- Visualization: Histograms, Correlation Matrix, Boxplots

## Key Steps
1. **Data Preprocessing** – cleaned data, checked structure, handled missing values  
2. **Exploratory Data Analysis (EDA)** – descriptive stats, regional spending patterns, customer segmentation  
3. **Data Visualization** – histograms, correlation heatmaps, boxplots  
4. **Probability Distribution Fitting** – modeled `Fresh` spending with Gamma distribution to predict high-spending customers  
5. **Logistic Regression** – identified `Detergent` spending as the strongest predictor of customer channel with **~90% accuracy**  
6. **Regional Analysis** – ANOVA and t-tests to compare spending across Lisbon, Porto, and rest of Portugal  

## Key Insights
- **High variability** in fresh and grocery spending → opportunity for targeted promotions  
- **Detergent spend** is the best predictor of customer type (Hotel/Restaurant/Café vs Retail)  
- **Rest of Portugal** customers spend the most on fresh and delicatessen → ideal region for growth campaigns  
- **Probability forecasts** show ~45% chance of customers spending > €10,000 annually on fresh products  

## Repository Structure
customer-spending-analysis-r/
│── data/                
│── scripts/           
│    ├── data_cleaning.R
│    ├── eda_visualizations.R
│    ├── probability_model.R
│    ├── logistic_regression.R
│── outputs/
│    ├── figures/       
│    ├── reports/        
│── README.md  
