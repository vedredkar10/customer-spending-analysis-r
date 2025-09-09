# eda_visualizations.R
# Purpose: Visualize wholesale customer data using univariate and bivariate analysis.

# ---- Load Required Libraries ----
library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid)
library(corrplot)

# ---- Assumes my.wholesale is already loaded ----
# Check the structure of the dataset
str(my.wholesale)

# ---- Univariate Analysis: Histograms ----
# Function to plot histograms for each spending category
plot_spending_histogram <- function(spending_category) {
  fill_color <- ifelse(spending_category == "Fresh", "red", "skyblue")
  
  ggplot(my.wholesale, aes_string(x = spending_category)) +
    geom_histogram(fill = fill_color, color = "black", bins = 30) +
    theme_minimal() +
    labs(
      title = paste("Distribution of", spending_category, "Spending"),
      x = paste(spending_category, "(thousands of euros)"),
      y = "Frequency"
    )
}

# List of numerical variables
numerical_vars <- c("Fresh", "Milk", "Grocery", "Frozen", "Detergent", "Delicatessen")

# Generate histograms for each category
spending_histograms <- lapply(numerical_vars, plot_spending_histogram)

# Add caption to the histograms
caption <- textGrob("Figure 1 - Distribution of Spending Categories", 
                    gp = gpar(fontsize = 10, fontface = "italic"))

# Display histograms in a grid layout
grid.arrange(grobs = spending_histograms, ncol = 2, bottom = caption)

# ---- Bivariate Analysis: Correlation Matrix ----

# Calculate correlation matrix for numerical variables
correlation_matrix <- cor(my.wholesale[, numerical_vars], use = "complete.obs")

# Plot correlation matrix
corrplot(correlation_matrix, 
         method = "circle", 
         type = "upper", 
         tl.col = "black", 
         tl.srt = 45, 
         main = "")

# Add caption for the correlation plot
grid.text("Figure 2 - Correlation Matrix of Spending Categories", 
          x = 0.5, y = unit(0.01, "npc"), 
          gp = gpar(fontsize = 8, fontface = "italic"), just = "center")

# ---- Observations ----
# 1. Spending is highly right-skewed across all categories.
# 2. Strong positive correlation between Grocery and Detergent spending.
# 3. Fresh and Grocery categories show high variability, indicating diverse customer behavior.
# 4. Future models must account for multicollinearity among predictors.
