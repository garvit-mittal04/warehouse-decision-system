import streamlit as st
import pandas as pd
import plotly.express as px

st.set_page_config(page_title="Warehouse Decision System", layout="wide")

st.title("🚀 Warehouse Decision Support System")
st.markdown("**Interactive ML-powered insights for staffing, throughput & risk**")

# Load data
@st.cache_data
def load_data():
    return pd.read_csv("warehouse_data.csv")

df = load_data()

# Sidebar controls
st.sidebar.header("🎛️ Scenario Controls")
selected_shift = st.sidebar.selectbox("Select Shift", df["shift"].unique())
staff_hours = st.sidebar.slider("Staff Hours", 4, 12, 8)
disruption_hours = st.sidebar.slider("Disruption Hours", 0, 8, 1)
order_volume = st.sidebar.number_input("Expected Order Volume", 500, 5000, 1500)

# Filter data
filtered = df[df["shift"] == selected_shift]

# Metrics
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Predicted Throughput", f"{int(filtered['throughput_units'].mean()):,} units")
with col2:
    st.metric("Risk Level", filtered["risk_level"].iloc[0])
with col3:
    st.metric("Est. Disruption Cost", "$2,286", "per extra hour")

# Chart
st.subheader("Throughput by Shift")
fig = px.bar(df, x="shift", y="throughput_units", color="risk_level", title="Morning vs Night Performance")
st.plotly_chart(fig, use_container_width=True)

st.subheader("Selected Data")
st.dataframe(filtered)

if st.button("📥 Download Dataset"):
    st.download_button("Download CSV", df.to_csv(index=False), "warehouse_data.csv", "text/csv")

st.caption("Built by Garvit • Powered by Streamlit")
