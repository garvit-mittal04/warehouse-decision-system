# ML-Powered Warehouse Operations Decision System

An end-to-end warehouse analytics and decision-support system built using real supply chain data to improve staffing, disruption response, throughput planning, and operational monitoring.

[![Live App](https://img.shields.io/badge/Live%20App-Streamlit-FF4B4B?logo=streamlit&logoColor=white)](https://warehouse-garvit.streamlit.app)

---

## 🚀 Live Project Summary

- Built an end-to-end ML-powered warehouse decision system  
- Achieved **R² = 0.874** for throughput prediction  
- Identified an **89% performance gap between shifts**  
- Quantified disruption cost impact at **$2,286/hour**  
- Combined forecasting, classification, prediction, and decision logic into one system  
- Extended the system with a **real-time Power Automate alerting layer**

**[→ Open the live Streamlit app](https://warehouse-garvit.streamlit.app)**

---

## Overview

Most warehouse operations still rely heavily on intuition for critical decisions such as staffing, disruption handling, and shift planning. This project demonstrates what happens when those decisions are supported by a full analytics and machine learning pipeline.

The system connects data, models, and decisions into one unified workflow — and extends it further with real-time automation.

---

## 🏗️ System Architecture

```text
                 ┌────────────────────┐
                 │   Warehouse Data   │
                 │ (CSV / Raw Input)  │
                 └─────────┬──────────┘
                           │
                           ▼
                 ┌────────────────────┐
                 │   SQL Layer        │
                 │ (MySQL + Queries)  │
                 └─────────┬──────────┘
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
┌──────────────┐  ┌────────────────┐  ┌──────────────────┐
│ Demand Model │  │ Risk Classifier│  │ Throughput Model │
│  (Prophet)   │  │  (XGBoost)     │  │ (Gradient Boost) │
└──────┬───────┘  └──────┬─────────┘  └──────┬───────────┘
       │                 │                   │
       └──────────┬──────┴───────────┬───────┘
                  ▼                  ▼
         ┌────────────────────────────────┐
         │ Decision Logic Layer           │
         │ (Business Rules + Insights)    │
         └──────────────┬─────────────────┘
                        ▼
         ┌────────────────────────────────┐
         │ Streamlit App (User Interface) │
         │ Scenario Testing & Decisions   │
         └──────────────┬─────────────────┘
                        ▼
         ┌────────────────────────────────┐
         │ Power Automate (Automation)    │
         │ Alerts + Logging (Excel)       │
         └────────────────────────────────┘
```

---

## ⚙️ How It Works

1. Raw warehouse data is ingested and structured using SQL  
2. ML models generate predictions:
   - demand forecasting  
   - risk classification  
   - throughput prediction  
3. A decision layer converts predictions into actionable insights  
4. The Streamlit app enables interactive scenario testing  
5. Power Automate adds a real-time automation layer:
   - detects new reports  
   - sends alerts  
   - logs activity for auditing  

This creates a full pipeline from **data → models → decisions → automation**

---

## Business Problem

Warehouses often face three recurring challenges:

- staffing decisions made without forward-looking demand signals  
- disruptions handled reactively after costs have already escalated  
- throughput variation across shifts without clear data-driven intervention  

This system helps answer:

- How much demand should we expect over the next 30 days?  
- Which operational events are high risk?  
- How much throughput can a shift realistically deliver?  
- What decisions should follow from these predictions?  
- How can monitoring be automated in real time?  

---

## Key Results

- **R² = 0.874** for throughput prediction  
- **89% shift performance gap identified**  
- **$2,286/hour disruption cost impact quantified**  
- **6 statistical tests validated findings**  
- **3 ML models integrated into one system**  
- **Real-time alerting system implemented**

---

## System Components

### Demand Forecasting
- Facebook Prophet  
- 30-day shipment predictions  

### Risk Classification
- XGBoost + business rules  
- Operational risk detection  

### Throughput Prediction
- Gradient Boosting  
- Shift-level output estimation  

### SQL Data Architecture
- MySQL schema + analytical queries  

### Statistical Validation
- R-based hypothesis testing  

### Explainability
- SHAP for model interpretation  

### Interactive App
- Streamlit-based decision interface  

---

## ⚡ Real-Time Warehouse Alert System (Power Automate)

![Power Automate Workflow](images/power_automate_flow.png)

### Workflow
- Trigger: new file uploaded to OneDrive  
- Action 1: send email alert  
- Action 2: log event in Excel  

### Business Value
- eliminates manual monitoring  
- enables real-time visibility  
- creates audit logs  
- improves response speed  

### Tools
- Power Automate  
- OneDrive  
- Excel  
- Outlook  

---

## Tech Stack

- Python, SQL, R  
- Prophet, XGBoost, Scikit-learn  
- SHAP  
- Streamlit  
- Power Automate  
- Excel  

---

## Repository Structure

```text
warehouse-decision-system/
├── automation/
├── dashboard/
├── images/
├── notebooks/
├── sql/
├── app.py
```

---

## What Makes This Project Different

Most projects stop at building models.

This project goes further by:
- connecting models to real business decisions  
- validating results statistically  
- making outputs interpretable  
- building an interactive system  
- adding real-time automation  

This makes it a **true end-to-end decision system**, not just a machine learning project.
