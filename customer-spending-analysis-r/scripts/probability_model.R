# probability_model.R
# Purpose: Analyze the spending behavior of "Fresh" products and fit a Gamma distribution 
# to model variability and predict probabilities for high-spending customers.

# ---- Load Required Libraries ----
library(ggplot2)
library(grid)
library(gridExtra)
library(MASS)          # For fitting Gamma distribution
library(fitdistrplus)  # For distribution diagnostics

# ---- Average Spending by Channel ----
# Calculate average spending by channel for all categories
channel_means <- aggregate(
  cbind(Fresh, Milk, Grocery, Frozen, Detergent, Delicatessen) ~ Channel,
  data = wholesale,
  FUN = mean
)

# Round values to 2 decimal places
channel_means[, 2:7] <- round(channel_means[, 2:7], 2)

# Convert Channel column to meaningful labels
wholesale$Channel <- factor(
  wholesale$Channel,
  levels = c(1, 2),
  labels = c("HoReCa", "Retail")
)

# Boxplot for Fresh spending by channel
boxplot_fresh <- ggplot(wholesale, aes(x = Channel, y = Fresh, fill = Channel)) +
  geom_boxplot(color = "black", alpha = 0.7) +
  scale_fill_manual(values = c("HoReCa" = "#D9D9D9", "Retail" = "#B0B0B0")) +
  theme_minimal() +
  labs(
    title = "Fresh Product Spending by Channel",
    y = "Annual Spending (1000s euros)",
    x = "Channel"
  )

# Caption
caption <- textGrob("Figure 3 - Box Plot for Fresh Spending by Channel",
                    gp = gpar(fontsize = 8, fontface = "italic"),
                    just = "center")

# Display layout
grid.arrange(boxplot_fresh, caption, ncol = 1, heights = c(5, 1))

# ---- Gamma Distribution Analysis ----
# Function to fit a Gamma distribution to Fresh spending data
analyze_fresh_gamma <- function(data) {
  # Scale Fresh values to thousands of euros for readability
  fresh_scaled <- data$Fresh / 1000
  
  cat("Summary of Fresh values (in thousands of euros):\n")
  print(summary(fresh_scaled))
  
  # Fit Gamma distribution
  gamma_fit_fresh <- fitdistr(fresh_scaled, "gamma")
  
  # Print parameters
  cat("\nGamma Distribution Parameters:\n")
  print(gamma_fit_fresh$estimate)
  cat("\nStandard Errors:\n")
  print(gamma_fit_fresh$sd)
  
  # Extract shape and rate
  shape_fresh <- gamma_fit_fresh$estimate['shape']
  rate_fresh <- gamma_fit_fresh$estimate['rate']
  
  # ---- Visualization ----
  p <- ggplot(data.frame(Fresh = fresh_scaled), aes(x = Fresh)) +
    geom_histogram(aes(y = ..density..),
                   bins = 30,
                   fill = "skyblue",
                   color = "black",
                   alpha = 0.7) +
    stat_function(fun = dgamma,
                  args = list(shape = shape_fresh, rate = rate_fresh),
                  color = "red", size = 1) +
    labs(
      title = "Fresh Spending with Fitted Gamma Distribution",
      subtitle = sprintf("Shape = %.2f, Rate = %.2f", shape_fresh, rate_fresh),
      x = "Fresh Spending (thousands of euros)",
      y = "Density"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold"),
      plot.subtitle = element_text(size = 12)
    )
  
  print(p)
  
  # ---- Quantile Comparison ----
  probs <- c(0.25, 0.5, 0.75, 0.9, 0.95)
  theoretical_quantiles <- qgamma(probs, shape = shape_fresh, rate = rate_fresh)
  actual_quantiles <- quantile(fresh_scaled, probs)
  
  cat("\nComparison of Actual vs Theoretical Quantiles (in thousands of euros):\n")
  comparison <- data.frame(
    Probability = probs,
    Actual = actual_quantiles,
    Theoretical = theoretical_quantiles,
    Difference = actual_quantiles - theoretical_quantiles
  )
  print(comparison)
  
  # ---- Probability Calculations ----
  example_values <- c(10, 20, 30) # example thresholds in thousands
  cat("\nExample probability calculations:\n")
  for (val in example_values) {
    prob <- 1 - pgamma(val, shape = shape_fresh, rate = rate_fresh)
    cat(sprintf("Probability of spending more than %d thousand euros: %.3f\n", val, prob))
  }
  
  return(gamma_fit_fresh)
}

# ---- Run the Analysis ----
fit_results <- analyze_fresh_gamma(my.wholesale)

# ---- Observations ----
# - Channel 1 (HoReCa) shows higher variability and median Fresh spending.
# - Gamma distribution is appropriate due to the right-skewed nature of the data.
# - This model can help predict the probability of very high Fresh spending for better inventory
#   and marketing decisions.
