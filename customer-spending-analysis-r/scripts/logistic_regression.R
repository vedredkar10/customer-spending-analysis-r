# logistic_regression.R
# Purpose: Predict customer channel using logistic regression and analyze regional spending patterns.

# ---- Load Required Libraries ----
library(dplyr)
library(ggplot2)
library(caret)
library(grid)
library(gridExtra)

# ---- Load and Prepare Data ----
data(wholesale)
n <- 200
my.student.number <- 000000000 # Replace with your student number
set.seed(my.student.number)
my.wholesale <- wholesale[sample(nrow(wholesale), n), ]

# Convert Channel to factor
my.wholesale$Channel <- as.factor(my.wholesale$Channel)

# ---- Train/Test Split ----
set.seed(123)
training_index <- createDataPartition(my.wholesale$Channel, p = 0.8, list = FALSE)
train_data <- my.wholesale[training_index, ]
test_data <- my.wholesale[-training_index, ]

# ---- Logistic Regression with All Variables ----
logistic_model <- glm(Channel ~ Fresh + Milk + Grocery + Frozen + Detergent + Delicatessen,
                      data = train_data,
                      family = "binomial")

# Model summary
summary(logistic_model)

# Variable importance using absolute z-values
variable_importance <- abs(summary(logistic_model)$coefficients[, "z value"])[-1]
variable_importance <- sort(variable_importance, decreasing = TRUE)

# ---- Model Evaluation ----
# Predictions on test data
test_predictions_prob <- predict(logistic_model, newdata = test_data, type = "response")
test_predictions <- ifelse(test_predictions_prob > 0.5, 2, 1)

# Confusion matrix
test_conf_matrix <- table(Predicted = test_predictions, Actual = test_data$Channel)
print("Test Data Confusion Matrix:")
print(test_conf_matrix)

# Accuracy
test_accuracy <- sum(diag(test_conf_matrix)) / sum(test_conf_matrix)
print(paste("Test Data Accuracy:", round(test_accuracy * 100, 2), "%"))

# ---- Variable Importance Plot ----
importance_df <- data.frame(
  Variable = names(variable_importance),
  Importance = variable_importance
)

ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "dodgerblue4", width = 0.6) +
  geom_text(aes(label = round(Importance, 2)), hjust = -0.2) +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Importance of Variables in Predicting Customer Type",
    subtitle = "Based on Absolute Z-values from Logistic Regression",
    x = "Variables",
    y = "Variable Importance (|Z-value|)",
    caption = "Figure 4 - Variable Importance Plot"
  )

# ---- Logistic Regression with Most Significant Variable (Detergent Only) ----
logistic_model_single <- glm(Channel ~ Detergent,
                             data = train_data,
                             family = "binomial")

# Summary of single-variable model
summary(logistic_model_single)

# Predictions and evaluation
test_predictions_prob_single <- predict(logistic_model_single, newdata = test_data, type = "response")
test_predictions_single <- ifelse(test_predictions_prob_single > 0.5, 2, 1)

# Confusion matrix
test_conf_matrix_single <- table(Predicted = test_predictions_single, Actual = test_data$Channel)
print("Test Data Confusion Matrix (Single Variable Model):")
print(test_conf_matrix_single)

# Accuracy
test_accuracy_single <- sum(diag(test_conf_matrix_single)) / sum(test_conf_matrix_single)
print(paste("Test Data Accuracy (Single Variable Model):", round(test_accuracy_single * 100, 2), "%"))

# ---- Regional Spending Analysis ----
# Summary of Fresh Spending by Region
Fresh_summary <- my.wholesale %>%
  group_by(Region) %>%
  summarise(
    Mean = mean(Fresh),
    SD = sd(Fresh),
    Count = n()
  )
print(Fresh_summary)

# ---- ANOVA ----
fresh_anova <- aov(Fresh ~ Region, data = my.wholesale)
print(summary(fresh_anova))

# ---- Bartlett's Test for Homogeneity of Variance ----
bartlett_result <- bartlett.test(Grocery ~ Region, data = my.wholesale)
print("Bartlett Test Results:")
print(bartlett_result)

# ---- Total Detergent Spending by Channel and Region ----
channel_spending <- wholesale %>%
  group_by(Channel) %>%
  summarise(Total_Detergent_Spending = sum(Detergent, na.rm = TRUE))

regional_spending <- wholesale %>%
  group_by(Region) %>%
  summarise(Total_Detergent_Spending = sum(Detergent, na.rm = TRUE))

# Plots
channel_plot <- ggplot(channel_spending, aes(x = reorder(Channel, Total_Detergent_Spending),
                                             y = Total_Detergent_Spending,
                                             fill = Channel)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  coord_flip() +
  labs(
    title = "Channel-Wise Spending for Detergents",
    x = "Channel",
    y = "Total Detergent Spending (in 1000s euros)"
  ) +
  theme(legend.position = "none")

regional_plot <- ggplot(regional_spending, aes(x = reorder(Region, Total_Detergent_Spending),
                                               y = Total_Detergent_Spending,
                                               fill = Region)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  coord_flip() +
  labs(
    title = "Regional Spending for Detergents",
    x = "Region",
    y = "Total Detergent Spending (in 1000s euros)"
  ) +
  theme(legend.position = "none")

caption <- textGrob("Figure 5 - Distribution of Detergent Spending by Channel and Region",
                    gp = gpar(fontsize = 10, fontface = "italic"))

grid.arrange(channel_plot, regional_plot, ncol = 2, bottom = caption)

# ---- Pairwise T-Tests ----
pairwise_results <- pairwise.t.test(
  my.wholesale$Fresh,
  my.wholesale$Region,
  p.adjust.method = "bonferroni"
)
print("Pairwise T-test Results:")
print(pairwise_results)

# ---- Notes ----
# - Detergent spending is the most significant predictor of channel classification.
# - Single-variable logistic regression achieved higher accuracy than the full model.
# - Regional analysis indicates different spending behaviors across regions.
# - ANOVA assumptions were not fully met, so pairwise t-tests are also used.