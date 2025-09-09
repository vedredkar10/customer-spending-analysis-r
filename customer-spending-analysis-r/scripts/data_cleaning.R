# data_cleaning.R
# Purpose: Load and preprocess wholesale dataset, generate basic descriptive statistics,
# and analyze regional spending and channel distribution.

# ---- Load Required Libraries ----
library(tclust)
library(knitr)

# ---- Load Dataset ----
data(wholesale)
n <- 200
my.student.number <- 240623850 # Replace this with your student number
set.seed(my.student.number)
my.wholesale <- wholesale[sample(nrow(wholesale), n), ]

# ---- Data Preprocessing ----

# Check structure of the dataset
str(my.wholesale)

# Check for missing values
missing_values <- sum(is.na(my.wholesale))
cat("Number of missing values:", missing_values, "\n")

# ---- Descriptive Statistics ----

# Summary statistics for numerical variables
summary_stats <- summary(my.wholesale[, c("Fresh", "Milk", "Grocery", 
                                          "Frozen", "Detergent", "Delicatessen")])
print(summary_stats)

# Create custom summary table
custom_summary <- data.frame(
  Statistic = c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max."),
  Fresh = c(23, 3408, 9392, 12739, 16782, 112151),
  Milk = c(201, 1608, 3479, 5230, 6641, 73498),
  Grocery = c(3, 2062, 3822, 7169, 8928, 67298),
  Frozen = c(36, 647, 1409, 2767, 3045, 35009),
  Detergent = c(3.0, 231.8, 634.5, 2594.1, 3613.2, 38102.0),
  Delicatessen = c(3.0, 343.5, 883.0, 1207.5, 1576.0, 8550.0)
)

kable(custom_summary, digits = 1, caption = "Summary Statistics of Spending Categories")

# ---- Regional Analysis ----

# Regional-wise average customer spending
regional_comparison <- aggregate(
  cbind(Fresh, Milk, Grocery, Frozen, Detergent, Delicatessen) ~ Region, 
  data = wholesale, 
  FUN = mean
)

# Assign region labels
regional_comparison$Region <- factor(regional_comparison$Region, 
                                     labels = c("Lisbon", "Porto", "Rest Of Portugal"))

# Round values
regional_comparison[, 2:7] <- round(regional_comparison[, 2:7])

# Display table
kable(
  regional_comparison, 
  format = "markdown", 
  col.names = c("Region", "Fresh", "Milk", "Grocery", "Frozen", "Detergent", "Delicatessen"),
  caption = "Region-wise Customer Spending Comparison"
)

# ---- Regional Distribution of Customers by Channel ----

# Assign factor labels for Region and Channel
my.wholesale$Region <- factor(my.wholesale$Region, 
                              levels = c(1, 2, 3), 
                              labels = c("Lisbon", "Porto", "Rest of Portugal"))

my.wholesale$Channel <- factor(my.wholesale$Channel, 
                               levels = c(1, 2), 
                               labels = c("Hotel/Restaurant/Cafe", "Retail"))

# Create a contingency table
table_region_channel <- table(my.wholesale$Region, my.wholesale$Channel)

# Display table
kable(table_region_channel, 
      format = "markdown", 
      col.names = c("Hotel/Restaurant/Cafe", "Retail"), 
      caption = "Regional Distribution of Customers by Channel")

# ---- Notes ----
# - "Rest of Portugal" has the largest share of customers.
# - Lisbon follows, and Porto has the smallest number of customers.
