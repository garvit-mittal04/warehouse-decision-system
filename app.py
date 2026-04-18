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

# ====================== LOAD REAL MODELS ======================
@st.cache_resource
def load_models():
    try:
        throughput_model = joblib.load("models/throughput_model.pkl")
        risk_model = joblib.load("models/risk_classifier.pkl")
        st.success("✅ Real models loaded successfully!")
        return throughput_model, risk_model
    except Exception as e:
        st.warning(f"⚠️ Models not loaded: {str(e)}. Using simulated predictions.")
        return None, None

model_throughput, model_risk = load_models()

# ====================== SIDEBAR ======================
st.sidebar.header("🎛️ Scenario Controls")
selected_shift = st.sidebar.selectbox("Select Shift", df["shift"].unique())
staff_hours = st.sidebar.slider("Staff Hours", 4, 12, 8)
disruption_hours = st.sidebar.slider("Disruption Hours", 0, 8, 1)
order_volume = st.sidebar.number_input("Expected Order Volume", 500, 5000, 1500)

# ====================== PREDICTION ======================
if model_throughput is not None:
    try:
        # Create input with correct feature names (adjust if your model was trained with different names)
        input_data = pd.DataFrame({
            'staff_hours': [staff_hours],
            'disruption_hours': [disruption_hours],
            'order_volume': [order_volume]
        })
        predicted_throughput = int(model_throughput.predict(input_data)[0])
        risk_level = model_risk.predict(input_data)[0] if model_risk is not None else "Medium"
    except Exception as e:
        st.error(f"Prediction error: {str(e)}")
        predicted_throughput = int(800 + staff_hours * 250 - disruption_hours * 300 + (order_volume / 2))
        risk_level = "Medium"
else:
    # Fallback
    predicted_throughput = int(800 + staff_hours * 250 - disruption_hours * 300 + (order_volume / 2))
    risk_level = "Medium"

# ====================== MAIN UI ======================
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Predicted Throughput", f"{predicted_throughput:,} units")
with col2:
    st.metric("Risk Level", risk_level)
with col3:
    st.metric("Est. Disruption Cost", "$2,286", "per extra hour")

st.info("**Morning vs Night gap observed in data: +89% units**")

# Tabs
tab1, tab2, tab3 = st.tabs(["📊 Overview", "🔮 Predictions & SHAP", "📥 Executive Dashboard"])

with tab1:
    st.subheader("Throughput by Shift")
    fig = px.bar(df, x="shift", y="throughput_units", color="risk_level", 
                 title="Morning vs Night Performance")
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(df, use_container_width=True)

with tab2:
    st.subheader("Model Prediction")
    st.success(f"For {selected_shift} shift → Predicted Throughput: {predicted_throughput:,} units")

    if model_throughput is not None:
        st.subheader("SHAP Explainability")
        try:
            explainer = shap.TreeExplainer(model_throughput)
            shap_values = explainer.shap_values(input_data)
            shap_fig = px.bar(x=input_data.columns, y=shap_values[0],
                              title="Feature Contribution to Throughput Prediction")
            st.plotly_chart(shap_fig, use_container_width=True)
        except:
            st.info("SHAP plot could not be generated. Make sure your model supports TreeExplainer.")

with tab3:
    st.subheader("Executive Dashboard Export")
    if st.button("📥 Download Full Executive Report (Excel)"):
        output = io.BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, sheet_name="Raw Data", index=False)
            pd.DataFrame({
                "Scenario": ["Current"],
                "Predicted Throughput": [predicted_throughput],
                "Risk Level": [risk_level],
                "Disruption Cost": [2286]
            }).to_excel(writer, sheet_name="Prediction Summary", index=False)
        st.download_button(
            label="Click to Download Excel",
            data=output.getvalue(),
            file_name="Warehouse_Executive_Dashboard.xlsx",
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )

st.caption("Built by Garvit Mittal • Real ML Models + SHAP + Executive Export")
