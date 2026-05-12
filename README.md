# ML-Powered Warehouse Operations Decision System

An end-to-end warehouse analytics and decision-support system built using real supply chain data to improve staffing, disruption response, and throughput planning.

[![Live App](https://img.shields.io/badge/Live%20App-Streamlit-FF4B4B?logo=streamlit&logoColor=white)](https://warehouse-garvit.streamlit.app)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://python.org)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-RandomForest-F7931E?logo=scikit-learn&logoColor=white)](https://scikit-learn.org)

---

## 🚀 Live Project Summary

- Built an end-to-end ML-powered warehouse decision system (v2.0)
- Achieved **R² = 0.934** for throughput prediction (Random Forest, 150 trees)
- Achieved **91.7% accuracy** for operational risk classification
- Trained on **1,200 rows** of realistic warehouse operational data
- Quantified disruption cost impact at **$2,286/hour**
- Delivers **P10/P90 confidence intervals** on every throughput prediction
- Full 5-tab interactive app: Overview, A/B Comparison, Optimizer, Model Intelligence, Export

**[→ Open the live Streamlit app](https://warehouse-garvit.streamlit.app)**
<img width="1502" height="813" alt="Screenshot 2026-05-12 at 11 53 21 AM" src="https://github.com/user-attachments/assets/cff4ae15-fec6-4986-8f3e-68cac83742a9" />

---

## Overview

Most warehouse operations still rely heavily on intuition for critical decisions such as staffing, disruption handling, and shift planning. This project was built to test what happens when those decisions are supported by a full analytics and machine learning pipeline instead.

The result is a complete warehouse decision system that combines:

- a 1,200-row realistic operational dataset with Morning, Afternoon, and Night shifts
- Random Forest models for throughput prediction and risk classification
- confidence interval estimation via individual tree predictions (P10/P90)
- interactive scenario testing and A/B comparison
- an automated What-If Optimizer that finds the minimum staff hours to hit a throughput target
- professional Excel dashboard export and one-page PDF executive summary

Rather than stopping at model building, this project focuses on translating model outputs into actions that managers can actually use.

---

## Business Problem

Warehouses often face three recurring challenges:

- staffing decisions made without forward-looking demand signals
- disruptions handled reactively after costs have already escalated
- throughput variation across shifts without clear data-driven intervention

This project addresses those problems by designing a system that helps answer:

- How much throughput can a shift realistically deliver?
- Which operational configurations carry high risk, and by how much?
- What is the minimum staffing needed to hit a target throughput within budget?
- How do two scenarios compare side-by-side in cost, risk, and output?

---

## Key Results

| Metric | Value |
|---|---|
| Throughput model R² | **0.934** |
| Throughput MAE | **±192 units** |
| Risk classifier accuracy | **91.7%** |
| Training dataset size | **1,200 rows** |
| Disruption cost per hour | **$2,286** |
| Confidence interval method | **P10/P90 across 150 trees** |

---

## App Features (v2.0)

### Tab 1 — Overview
Real-time KPI metrics (throughput, risk, disruption cost, labour cost, total cost) updated instantly as you adjust sidebar inputs. Includes historical throughput by shift, risk distribution pie chart, and a prediction histogram with 90% CI band overlaid on historical data.

### Tab 2 — A/B Comparison
Side-by-side comparison of two fully configurable scenarios. Colour-coded KPI cards, winner banner, grouped bar chart, and a radar chart scoring each scenario across throughput, disruption, staff efficiency, cost, and risk dimensions.

### Tab 3 — What-If Optimizer
Set a target throughput and budget. The optimizer runs all 81 combinations of staff hours (4–12) and disruption hours (0–8) and finds the cheapest configuration that meets your target. Outputs a heatmap, optimal recommendation, and a ranked feasibility table.

### Tab 4 — Model Intelligence
Shows model performance metrics, feature importance charts for both models, and a histogram of all 150 individual tree predictions for the current scenario — visualising the full prediction uncertainty distribution.

### Tab 5 — Export Reports
One-click downloads for a full multi-sheet Excel executive dashboard (with live scenario prediction sheet, charts, and conditional formatting) and a one-page PDF executive summary with KPIs, cost breakdown, model performance, and tailored recommendations.

---

## System Components

### 1. Throughput Prediction

Used a **Random Forest Regressor (150 trees, max depth 12)** to predict shift-level throughput.

- R² = 0.934 on held-out test data
- MAE = ±192 units
- Confidence intervals derived from P10/P90 spread across individual tree predictions
- Top drivers: Disruption Hours (43%), Staff Hours (32%), Order Volume (22%)

### 2. Risk Classification

Used a **Random Forest Classifier (150 trees, balanced class weights)** to classify operational risk as Low, Medium, or High.

- Accuracy = 91.7%
- Class-balanced training to handle imbalanced risk distribution
- Top driver: Disruption Hours (67%)

### 3. What-If Optimizer

A grid search over all staffing and disruption combinations filtered against a user-defined throughput target and cost budget, with the optimal configuration highlighted on a heatmap.

### 4. Excel Dashboard

Multi-sheet openpyxl workbook with a dynamically generated Scenario Prediction sheet (live KPIs, feature impact table, bar chart), plus pre-built sheets for Throughput Analysis, Risk & Disruptions, Staffing Plan, Demand Forecast, and an Executive Overview.

### 5. PDF Executive Summary

One-page reportlab PDF with header banner, KPI table (colour-coded by risk), scenario inputs, model performance metrics, and automatically generated recommendations based on the current scenario.

### 6. SQL Data Architecture

Built a structured **MySQL schema** with normalized tables and analytical queries.

- organizes operational data cleanly
- supports downstream analytics and ML pipelines
- answers warehouse performance questions through SQL

### 7. Statistical Validation

Used **R** to perform formal hypothesis testing and validate business claims.

- verifies that observed patterns are statistically meaningful
- avoids relying on visual trends or assumptions alone

### 8. Explainability

Used **SHAP** to explain feature importance and prediction behavior across the original model suite.

---

## Tech Stack

- **Python 3.10+** — data processing and machine learning
- **scikit-learn** — Random Forest throughput predictor and risk classifier
- **Streamlit** — live interactive 5-tab decision app
- **Plotly** — interactive charts (bar, pie, histogram, heatmap, radar, scatter)
- **openpyxl** — multi-sheet Excel dashboard with charts and conditional formatting
- **reportlab** — PDF executive summary generation
- **pandas / numpy** — data wrangling and numerical computation
- **joblib** — model serialisation
- **Facebook Prophet** — demand forecasting (notebooks)
- **XGBoost** — original risk classification experiments (notebooks)
- **R** — statistical validation (notebooks)
- **SHAP** — model explainability (notebooks)
- **SQL / MySQL** — schema design and analytical queries
- **Excel** — pre-built executive dashboard template

---

## Repository Structure

```text
warehouse-decision-system/
├── README.md
├── requirements.txt
├── app.py                          # Main Streamlit app (5 tabs, v2.0)
├── warehouse_data.csv              # 1,200-row operational dataset
├── models/
│   ├── throughput_model.pkl        # RandomForestRegressor (R²=0.934)
│   ├── risk_classifier.pkl         # RandomForestClassifier (91.7% accuracy)
│   ├── shift_encoder.pkl           # LabelEncoder for shift column
│   ├── risk_encoder.pkl            # LabelEncoder for risk_level column
│   └── metrics.json                # Stored model metrics and feature importances
├── dashboard/
│   └── warehouse_operations_dashboard.xlsx   # Pre-built Excel dashboard template
├── notebooks/
│   ├── 01_load_data.ipynb
│   ├── 02_demand_forecasting.ipynb
│   ├── 03_risk_classifier.ipynb
│   ├── 04_throughput_model.ipynb
│   ├── 05_interactive_dashboard.ipynb
│   └── 06_shap_explainability.ipynb
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_analytical_queries_part1.sql
│   └── 04_analytical_queries_part2.sql
└── images/
    ├── demand_patterns.png
    ├── forecast_accuracy.png
    ├── staffing_forecast_chart.png
    ├── throughput_model_results.png
    ├── throughput_patterns.png
    ├── risk_model_evaluation.png
    ├── feature_importance_risk.png
    ├── shap_risk_bar.png
    ├── shap_risk_dot.png
    ├── shap_throughput_bar.png
    ├── shap_throughput_dot.png
    ├── dashboard_risk.png
    ├── dashboard_throughput.png
    ├── test1_staffing_gap.png
    ├── test4_regression_fit.png
    ├── test5_ks_distributions.png
    └── test6_confidence_intervals.png
```

---

## Running Locally

```bash
git clone https://github.com/garvit-mittal04/warehouse-decision-system.git
cd warehouse-decision-system
pip install -r requirements.txt
streamlit run app.py
```

---

*Built by Garvit Mittal · Warehouse Decision Support System · v2.0*
