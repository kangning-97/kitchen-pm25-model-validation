  # Kitchen PM2.5 model validation

Each R script directly reads its own CSV, calculates the metrics, prints the results, and writes a result CSV. Only base R is required. 

## Run the code

Extract the whole package. Set the R/RStudio working directory to this package folder, which contains `code/`, `data/`, and `results/`. Run the relevant script. For example, run `source("code/Figure_S4_corrected.R")` in R, or run `Rscript code/Figure_S4_corrected.R` from this folder.

| Validation            | Figure      | R script                      | Paired data                       |
| --------------------- | ----------- | ----------------------------- | --------------------------------- |
| Sample-based CV       | S4          | `code/Figure_S4_corrected.R`  | `data/Figure_S4_source_data.csv`  |
| Household-based CV    | S5          | `code/Figure_S5_corrected.R`  | `data/Figure_S5_source_data.csv`  |
| Date-based CV         | S6          | `code/Figure_S6_corrected.R`  | `data/Figure_S6_source_data.csv`  |
| Out-of-bag validation | 1A          | `code/Figure_1_corrected.R`   | `data/Figure_1_source_data.csv`   |
| Random holdout test   | 1B          | `code/Figure_1_corrected.R`   | `data/Figure_1_source_data.csv`   |
| Earlier test period   | S12, left   | `code/Figure_S12_corrected.R` | `data/Figure_S12_source_data.csv` |
| Later test period     | S12, middle | `code/Figure_S12_corrected.R` | `data/Figure_S12_source_data.csv` |
| Pooled test periods   | S12, right  | `code/Figure_S12_corrected.R` | `data/Figure_S12_source_data.csv` |

## Data and analysis scope

`obs` is the observed kitchen PM2.5 concentration and `pred` is the original model prediction, both in micrograms per cubic meter. The Figure 1 data additionally identify OOB versus random-test predictions. The Figure S12 data identify earlier versus later periods; the pooled result uses all rows. S4-S6 report pooled out-of-fold metrics for the retained 400-tree, mtry = 3 setting. Each CV file contains 3,680 pairs. Figure 1 contains 3,680 OOB pairs and 921 random-test pairs. S12 contains 1,912 earlier and 254 later pairs.

There are no household identifiers, fuel or ventilation variables, other household characteristics, fold identifiers, exact dates, or geographic coordinates. Household-based CV is retained as one of the requested validation schemes; household-characteristic subgroup analyses are excluded. The same observation can appear in different validation files with a different model prediction.

The scripts recalculate the eight reported statistics from fixed observed-predicted pairs. They do not refit the models, reconstruct the fold assignments, or regenerate figures. S12 uses its original separately tuned temporal-validation model, rather than refitting the main model here.

## Metric definitions

- `R2_corrected = 1 - sum((obs - pred)^2) / sum((obs - mean(obs))^2)` is prediction R-squared.
- `r = cor(obs, pred)` is Pearson correlation; `r2 = r^2` is its square.
- `R2_lm = summary(lm(obs ~ pred))$r.squared` is the R-squared from a simple OLS regression with an intercept. It equals Pearson r-squared for these pairs.
- Previous labels used Pearson r-squared, except the pooled S12 label, which already used prediction R-squared. The code explicitly preserves that exception.
- `RMSE = sqrt(mean((obs - pred)^2))`.
- `NRMSE = RMSE / (max(obs) - min(obs)) * 100`, using the observed range of each evaluation group.
- `MAE = mean(abs(obs - pred))`.
- `Bias = mean(pred - obs)`; positive values indicate overprediction.
- Figure 1 also reports the paired t-test P values shown in the figure.
