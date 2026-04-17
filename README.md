![Warehouse Decision System](images/06_app_screenshot.png)

## 🚀 Live Project Summary

- Built an end-to-end ML-powered warehouse decision system  
- Achieved R² = 0.874 for throughput prediction  
- Identified 89% performance gap between shifts  
- Quantified disruption cost impact at $2,286/hour  
- Combined forecasting, classification, and decision logic into one system  

# ML-Powered Warehouse Operations Decision System

An end-to-end warehouse analytics and decision-support system built using real supply chain data to improve staffing, disruption response, and throughput planning.

## Overview

Most warehouse operations still rely heavily on intuition for critical decisions such as staffing, disruption handling, and shift planning. This project was built to test what happens when those decisions are supported by a full analytics and machine learning pipeline instead.

The result is a complete warehouse decision system that combines:

- relational database design
- analytical SQL querying
- demand forecasting
- risk classification
- throughput prediction
- statistical validation
- explainability
- dashboarding
- interactive decision support

Rather than stopping at model building, this project focuses on translating model outputs into actions that managers can actually use.

---

## Business Problem

Warehouses often face three recurring challenges:

- staffing decisions made without forward-looking demand signals
- disruptions handled reactively after costs have already escalated
- throughput variation across shifts without clear data-driven intervention

This project addresses those problems by designing a system that helps answer:

- How much demand should we expect over the next 30 days?
- Which operational events are high risk and need escalation?
- How much throughput can a shift realistically deliver?
- What staffing or scheduling action should follow from these predictions?

---

## Key Results

- **Throughput prediction model achieved R² = 0.874**
- **Morning shift produced 89% more units than the night shift**
- **Each additional disruption hour added approximately $2,286 in cost**
- **6 formal statistical tests validated key operational patterns**
- **3 machine learning models deployed in one decision framework**

---

## System Components

### 1. Demand Forecasting
Used **Facebook Prophet** to generate 30-day shipment demand forecasts.

**Purpose**
- support staffing and planning decisions
- identify expected shipment volume ranges
- provide forward-looking operational visibility

### 2. Risk Classification
Used **XGBoost + business rules** to classify operational risk.

**Purpose**
- identify shipments or disruptions with elevated risk
- create escalation logic for managers
- combine ML predictions with business judgment

### 3. Throughput Prediction
Used **Gradient Boosting** to predict shift-level throughput.

**Purpose**
- estimate operational output by shift
- support staffing and scheduling decisions
- identify underperforming operating conditions

### 4. SQL Data Architecture
Built a structured **MySQL schema** with normalized tables and analytical queries.

**Purpose**
- organize operational data cleanly
- support downstream analytics and ML pipelines
- answer warehouse performance questions through SQL

### 5. Statistical Validation
Used **R** to perform formal hypothesis testing and validate business claims.

**Purpose**
- verify that observed patterns are statistically meaningful
- avoid relying on visual trends or assumptions alone

### 6. Explainability
Used **SHAP** to explain feature importance and prediction behavior.

**Purpose**
- make model outputs interpretable
- improve trust in recommendations
- show which variables drive predictions most strongly

### 7. Dashboard + Interactive App
Built an **Excel executive dashboard** and a **Google Colab interactive app**.

**Purpose**
- turn analysis into decision-ready outputs
- give stakeholders a usable reporting interface
- bridge the gap between modeling and action

---

## Tech Stack

- **SQL / MySQL** — schema design and analytical queries
- **Python** — data processing and machine learning
- **Facebook Prophet** — demand forecasting
- **XGBoost** — risk classification
- **Scikit-learn Gradient Boosting** — throughput prediction
- **R** — statistical validation
- **SHAP** — model explainability
- **Excel** — executive dashboard
- **Google Colab / Jupyter** — modeling and interactive app

---

## Repository Structure

```text
warehouse-decision-system/
├── README.md
├── .gitignore
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
├── dashboard/
│   └── [Excel dashboard files]
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