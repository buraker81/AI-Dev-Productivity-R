# AI‑Developer‑Productivity

This repository analyses the **ai\_dev\_productivity.csv** dataset, which simulates day‑to‑day behaviour and performance metrics of an AI software developer over **500 days**.

> **Course Context**\
> Part II of the term project for *CMPE 343 – Business Intelligence & Applied Analytics* (elective).

## Overview

The project demonstrates a full analytics workflow in **R**:

1. **Exploratory Data Analysis (EDA)** – structure, summary statistics, histograms and correlation heat‑map.
2. **Clustering** – K‑means (k = 3) on standardised behavioural metrics with PCA visualisation to reveal developer work patterns.
3. **Outlier Detection** – IQR method plus boxplots for every numeric variable.
4. **Predictive Modelling** – Logistic regression models the probability of `task_success` from coffee intake and coding hours; ROC–AUC and confusion matrix evaluate performance.

All steps are scripted in `Analysis.R`, while the companion slide‑deck **AI‑dev‑productivity.pdf** summarises visuals and conclusions.

---

## Dataset

| Field              | Description                       | Example Range |
| ------------------ | --------------------------------- | ------------- |
| `hours_coding`     | Daily hours spent coding          | 0 – 12 h      |
| `coffee_intake_mg` | Caffeine consumed (mg)            | 0 – 800 mg    |
| `distractions`     | Interruptions encountered (count) | 0 – 15        |
| `sleep_hours`      | Hours of sleep last night         | 2 – 10 h      |
| `commits`          | Git commits made                  | 0 – 14        |
| `bugs_reported`    | Bugs logged for the code that day | 0 – 9         |
| `ai_usage_hours`   | Time spent using AI tools         | 0 – 6 h       |
| `cognitive_load`   | Self‑rated (1 = low, 10 = high)   | 1 – 10        |
| `task_success`     | Binary label (1 = successful day) | 0 / 1         |

Total **500 rows × 9 variables**.

---

## Project Structure

```text
.
├── Data/
│   └── ai_dev_productivity.csv       # Raw dataset (500 × 9)
│
├── Project/
│   ├── Project2.Rproj                # RStudio project file
│   └── Analysis.R                    # All R code (EDA, clustering, modelling)
│
├── Visualization/                    # Auto‑generated figures (PNG)
│
├── AI-dev-productivity.pdf           # Presentation of the whole project(Recommended)
├── README.md                         # ← you are here
└── req.txt                           # Assignment description
```

---

## Requirements

- **R** ≥ 4.1 (tested on 4.3)

- **Packages**

  ```r
  install.packages(c(
    "tidyverse",      # data wrangling & ggplot2
    "corrplot",       # correlation heat‑maps
    "factoextra",     # fviz_nbclust, fviz_cluster
    "ggplot2",        # visualisations
    "pROC"            # ROC–AUC curves
  ))
  ```

- Recommended: `renv` or `Project2.Rproj` for environment isolation.

---

## Usage

```r
# From an R session or RStudio project root
source("ai_dev_productivity_analysis.R")
```

The script will:

1. Load **ai\_dev\_productivity.csv**.
2. Reproduce all figures and save them to a new `Visualization/` folder.
3. Print clustering summaries, outlier counts, logistic regression tables and model metrics.

---

## Key Results & Findings

| Topic               | Insight                                                                                                                                                                                                      |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Coffee ↔ Coding** | Strong positive correlation (ρ ≈ 0.89) between `coffee_intake_mg` and `hours_coding`.                                                                                                                        |
| **Clusters (k=3)**  | • **Balanced Days** – 6 h coding, 8 h sleep, low cognitive load.• **Low‑Energy Days** – 3 h coding, minimal caffeine, fewer commits.• **Overloaded Days** – 6 h coding, highest cognitive load, least sleep. |
| **Outliers**        | Extreme caffeine spikes (> 800 mg) and coding marathons (> 12 h) flagged; no outliers in `bugs_reported`.                                                                                                    |
| **Logistic Model**  | Coffee intake alone yields **AUC = 0.89** and **accuracy ≈ 85%** for predicting `task_success`. Odds ratio = 1.0167 per mg.                                                                                  |

---

> **Companion slide‑deck *****AI‑dev‑productivity.pdf***** summarises visuals and conclusions.**
