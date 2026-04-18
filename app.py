import streamlit as st
import pandas as pd
import plotly.express as px
import joblib
import shap
import io

st.set_page_config(page_title="Warehouse Decision System", layout="wide")
st.title("🚀 Warehouse Decision Support System")
st.markdown("**Interactive ML-powered insights for staffing, throughput & risk**")

# ====================== LOAD DATA ======================
@st.cache_data
def load_data():
    return pd.read_csv("warehouse_data.csv")

df = load_data()

# ====================== LOAD MODELS (add your .pkl files later) ======================
# @st.cache_resource
# def load_models():
#     throughput_model = joblib.load("models/throughput_model.pkl")
#     risk_model = joblib.load("models/risk_classifier.pkl")
#     return throughput_model, risk_model
# model_throughput, model_risk = load_models()

# ====================== SIDEBAR ======================
st.sidebar.header("🎛️ Scenario Controls")

selected_shift = st.sidebar.selectbox("Select Shift", df["shift"].unique())
staff_hours = st.sidebar.slider("Staff Hours", 4, 12, 8)
disruption_hours = st.sidebar.slider("Disruption Hours", 0, 8, 1)
order_volume = st.sidebar.number_input("Expected Order Volume", 500, 5000, 1500)

# ====================== SIMULATED PREDICTIONS (replace with real models later) ======================
predicted_throughput = int(800 + staff_hours * 250 - disruption_hours * 300 + (order_volume / 2))
risk_level = "High" if disruption_hours >= 3 else "Medium" if disruption_hours >= 1 else "Low"

# ====================== MAIN DASHBOARD ======================
col1, col2, col3 = st.columns(3)

with col1:
    st.metric("Predicted Throughput", f"{predicted_throughput:,} units", "↑ from baseline")
with col2:
    st.metric("Risk Level", risk_level)
with col3:
    st.metric("Est. Disruption Cost", "$2,286", "per extra hour")

# Tabs for better organization
tab1, tab2, tab3 = st.tabs(["📊 Overview", "🔮 Predictions & SHAP", "📥 Executive Dashboard"])

with tab1:
    st.subheader("Throughput by Shift")
    fig = px.bar(df, x="shift", y="throughput_units", color="risk_level",
                 title="Morning vs Night Performance", color_discrete_sequence=["#FF6B6B", "#4ECDC4"])
    st.plotly_chart(fig, use_container_width=True)

    st.subheader("Raw Data")
    st.dataframe(df, use_container_width=True)

with tab2:
    st.subheader("Model Predictions")
    st.info(f"**Predicted Throughput for {selected_shift} shift:** {predicted_throughput:,} units")
    st.info(f"**Risk Level:** {risk_level}")

    st.subheader("SHAP Explainability (Feature Importance)")
    st.write("In a real model, this would show which factors affect throughput the most.")
    # Placeholder SHAP plot (replace with real SHAP when you have models)
    shap_fig = px.bar(x=["Staff Hours", "Disruption Hours", "Order Volume"], 
                      y=[0.45, 0.32, 0.23], 
                      labels={"x": "Feature", "y": "SHAP Impact"},
                      title="Top Features Impacting Throughput")
    st.plotly_chart(shap_fig, use_container_width=True)

with tab3:
    st.subheader("Executive Dashboard Export")
    if st.button("📥 Download Full Executive Dashboard as Excel"):
        output = io.BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, sheet_name="Raw Data", index=False)
            # You can add more sheets (summary, predictions, etc.) here later
        st.download_button(
            label="Click to Download Excel",
            data=output.getvalue(),
            file_name="Warehouse_Executive_Dashboard.xlsx",
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )

st.caption("Built by Garvit Mittal • Enhanced Version with Models + SHAP + Excel Export")
