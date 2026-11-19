# Figure 1: out-of-bag validation and random holdout test
# Set the working directory to the package folder containing code/, data/, and results/.

# ~~~1 Read the data-----------------
df_all = read.csv("data/Figure_1_source_data.csv")

# ~~~2 Out-of-bag validation-----------------
df_test = subset(df_all, validation == "OOB")
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
  Validation = "Out-of-bag validation", Figure = "Figure 1A", N = length(obs),
  R2_previous = R2_previous, R2_corrected = R2_corrected,
  r = r, r2 = r2, R2_lm = R2_lm,
  RMSE_previous = RMSE, RMSE_corrected = RMSE,
  NRMSE_previous = NRMSE, NRMSE_corrected = NRMSE,
  MAE_previous = MAE, MAE_corrected = MAE,
  Bias_previous = Bias, Bias_corrected = Bias
)
out$paired_t_test_p = t.test(obs, pre, paired = TRUE)$p.value
print(out, digits = 12, row.names = FALSE)
out_oob = out

# ~~~3 Random holdout test-----------------
df_test = subset(df_all, validation == "random_test")
stopifnot(nrow(df_test) == 921)

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
  Validation = "Random holdout test", Figure = "Figure 1B", N = length(obs),
  R2_previous = R2_previous, R2_corrected = R2_corrected,
  r = r, r2 = r2, R2_lm = R2_lm,
  RMSE_previous = RMSE, RMSE_corrected = RMSE,
  NRMSE_previous = NRMSE, NRMSE_corrected = NRMSE,
  MAE_previous = MAE, MAE_corrected = MAE,
  Bias_previous = Bias, Bias_corrected = Bias
)
out$paired_t_test_p = t.test(obs, pre, paired = TRUE)$p.value
print(out, digits = 12, row.names = FALSE)
out_test = out

# ~~~4 Save both panels-----------------
out = rbind(out_oob, out_test)
write.csv(out, "results/Figure_1_metrics.csv", row.names = FALSE)
