# Figure S4: retained setting of 400 trees and mtry = 3
# Set the working directory to the package folder containing code/, data/, and results/.

# ~~~1 Read the data-----------------
df_all = read.csv("data/Figure_S4_source_data.csv")

# ~~~2 Sample-based CV-----------------
df_test = df_all
stopifnot(nrow(df_test) == 3680)

obs = df_test$obs
pre = df_test$pred
stopifnot(all(is.finite(obs)), all(is.finite(pre)))
error = pre - obs

r = cor(obs, pre)
r2 = r^2
R2_lm = summary(lm(obs ~ pre))$r.squared
R2_corrected = 1 - sum((obs - pre)^2) / sum((obs - mean(obs))^2)
R2_previous = r2

RMSE = sqrt(mean((obs - pre)^2))
NRMSE = RMSE / (max(obs) - min(obs)) * 100
MAE = mean(abs(obs - pre))
Bias = mean(pre - obs)

# Both versions use the same observations and predictions.
# Only the R2 definition changes; the other metrics are unchanged.
out = data.frame(
  Validation = "Sample-based CV", Figure = "Figure S4", N = length(obs),
  R2_previous = R2_previous, R2_corrected = R2_corrected,
  r = r, r2 = r2, R2_lm = R2_lm,
  RMSE_previous = RMSE, RMSE_corrected = RMSE,
  NRMSE_previous = NRMSE, NRMSE_corrected = NRMSE,
  MAE_previous = MAE, MAE_corrected = MAE,
  Bias_previous = Bias, Bias_corrected = Bias
)
print(out, digits = 12, row.names = FALSE)

write.csv(out, "results/Figure_S4_metrics.csv", row.names = FALSE)
