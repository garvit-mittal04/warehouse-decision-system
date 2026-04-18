import streamlit as st
import pandas as pd
import plotly.express as px
import joblib
import io

st.set_page_config(page_title="Warehouse Decision System", layout="wide")
st.title("🚀 Warehouse Decision Support System")
st.markdown("**Interactive ML-powered insights for staffing, throughput & risk**")

# Load data
@st.cache_data
def load_data():
    return pd.read_csv("warehouse_data.csv")

df = load_data()

# Load models safely
@st.cache_resource
def load_models():
    try:
        throughput_model = joblib.load("models/throughput_model.pkl")
        risk_model = joblib.load("models/risk_classifier.pkl")
        st.success("✅ Real models loaded successfully!")
        return throughput_model, risk_model
    except Exception as e:
        st.warning("⚠️ Could not load models. Using simulated predictions.")
        return None, None

model_throughput, model_risk = load_models()

# Sidebar
st.sidebar.header("🎛️ Scenario Controls")
selected_shift = st.sidebar.selectbox("Select Shift", df["shift"].unique())
staff_hours = st.sidebar.slider("Staff Hours", 4, 12, 8)
disruption_hours = st.sidebar.slider("Disruption Hours", 0, 8, 1)
order_volume = st.sidebar.number_input("Expected Order Volume", 500, 5000, 1500)

# Prediction
if model_throughput is not None:
    try:
        input_data = pd.DataFrame({
            'staff_hours': [staff_hours],
            'disruption_hours': [disruption_hours],
            'order_volume': [order_volume]
        })
        predicted_throughput = int(model_throughput.predict(input_data)[0])
        risk_level = model_risk.predict(input_data)[0] if model_risk is not None else "Medium"
    except:
        predicted_throughput = int(800 + staff_hours * 250 - disruption_hours * 300 + (order_volume / 2))
        risk_level = "Medium"
else:
    predicted_throughput = int(800 + staff_hours * 250 - disruption_hours * 300 + (order_volume / 2))
    risk_level = "Medium"

# Cost calculation
disruption_cost = disruption_hours * 2286

# Main UI
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Predicted Throughput", f"{predicted_throughput:,} units")
with col2:
    st.metric("Risk Level", risk_level)
with col3:
    st.metric("Est. Disruption Cost", f"${disruption_cost:,.0f}", f"+${disruption_cost:,.0f}")

st.info("**Morning vs Night gap observed in data: +89% units**")

# Tabs
tab1, tab2, tab3 = st.tabs(["📊 Overview", "🔮 Predictions", "📥 Executive Dashboard"])

with tab1:
    st.subheader("Throughput by Shift")
    fig = px.bar(df, x="shift", y="throughput_units", color="risk_level", 
                 title="Morning vs Night Performance")
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(df, use_container_width=True)

with tab2:
    st.subheader("Model Prediction")
    st.success(f"For {selected_shift} shift → Predicted Throughput: {predicted_throughput:,} units")

with tab3:
    st.subheader("Executive Dashboard Export")
    if st.button("📥 Download Full Executive Report (Excel)"):
        output = io.BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, sheet_name="Raw Data", index=False)
        st.download_button(
            label="Click to Download Excel",
            data=output.getvalue(),
            file_name="Warehouse_Executive_Dashboard.xlsx",
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )

st.caption("Built by Garvit Mittal")
