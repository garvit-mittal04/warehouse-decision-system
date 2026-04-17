# Query 1 Business question: How many units did we process each day and is volume growing?
USE warehouse_ops;

SELECT
    shipment_date,
    COUNT(*)                                    AS total_shipments,
    SUM(unit_count)                             AS total_units,
    ROUND(AVG(unit_count), 1)                   AS avg_units_per_shipment,
    SUM(CASE WHEN status = 'late'      THEN 1 ELSE 0 END) AS late_count,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_count,
    ROUND(SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                AS late_pct
FROM shipments
GROUP BY shipment_date
ORDER BY shipment_date;

# Query 2 — Monthly Volume and Late Delivery Rate
# Business question: Which months are our worst for late deliveries? Where should we add staff?
SELECT
    DATE_FORMAT(shipment_date, '%Y-%m')         AS month,
    COUNT(*)                                    AS total_shipments,
    SUM(unit_count)                             AS total_units,
    SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)      AS late_shipments,
    ROUND(SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                AS late_pct,
    ROUND(SUM(sales_amount), 2)                 AS total_revenue,
    ROUND(SUM(profit), 2)                       AS total_profit
FROM shipments
GROUP BY DATE_FORMAT(shipment_date, '%Y-%m')
ORDER BY month;

# Query 3 — Workforce Efficiency by Shift Type
# Business question: Which shift gets the most work done per worker? Where are we overstaffed?

SELECT
    s.shift_type,
    COUNT(*)                                        AS total_shifts,
    ROUND(AVG(s.planned_workers), 1)                AS avg_planned_workers,
    ROUND(AVG(s.actual_workers), 1)                 AS avg_actual_workers,
    ROUND(AVG(s.planned_workers - s.actual_workers), 1) AS avg_understaffing,
    ROUND(AVG(s.overtime_hours), 2)                 AS avg_overtime_hrs,
    ROUND(SUM(s.overtime_hours), 1)                 AS total_overtime_hrs,
    ROUND(AVG(t.units_scanned), 1)                  AS avg_units_per_scan
FROM shifts s
LEFT JOIN throughput_scans t ON s.shift_id = t.shift_id
GROUP BY s.shift_type
ORDER BY avg_units_per_scan DESC;

# Query 4 — Dock Door Performance
# Business question: Which dock doors have the longest wait times? Which are underutilized?
SELECT
    dock_door,
    COUNT(*)                                        AS total_events,
    ROUND(AVG(wait_time_min), 1)                    AS avg_wait_mins,
    MAX(wait_time_min)                              AS max_wait_mins,
    SUM(CASE WHEN wait_time_min > 60 THEN 1 ELSE 0 END) AS events_over_60min,
    ROUND(SUM(CASE WHEN wait_time_min > 60 THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                    AS pct_over_60min,
    SUM(CASE WHEN actual_start IS NULL THEN 1 ELSE 0 END) AS no_shows
FROM dock_events
GROUP BY dock_door
ORDER BY avg_wait_mins DESC;

# Query 5 — Top 10 Highest Risk Days
# Business question: Which specific days had the worst operational performance?

SELECT
    s.shipment_date,
    DAYNAME(s.shipment_date)                        AS day_of_week,
    COUNT(*)                                        AS total_shipments,
    SUM(s.late_risk_flag)                           AS late_risk_count,
    ROUND(SUM(s.late_risk_flag) * 100.0
          / COUNT(*), 1)                            AS risk_pct,
    SUM(CASE WHEN s.status = 'late' THEN 1 ELSE 0 END) AS actual_late,
    COUNT(DISTINCT d.disruption_id)                 AS disruptions_that_day,
    ROUND(SUM(d.cost_impact), 2)                    AS disruption_cost
FROM shipments s
LEFT JOIN disruptions d ON s.shipment_date = d.disruption_date
GROUP BY s.shipment_date
ORDER BY risk_pct DESC
LIMIT 10;

# Query 6 — Disruption Cost by Type
# Business question: What kinds of disruptions cost us the most money?

SELECT
    disruption_type,
    COUNT(*)                                    AS occurrences,
    ROUND(AVG(duration_hours), 1)               AS avg_duration_hrs,
    ROUND(AVG(cost_impact), 2)                  AS avg_cost_per_event,
    ROUND(SUM(cost_impact), 2)                  AS total_cost_impact,
    severity,
    COUNT(CASE WHEN severity = 'high'
               OR severity = 'critical'
               THEN 1 END)                      AS high_severity_count
FROM disruptions
GROUP BY disruption_type, severity
ORDER BY total_cost_impact DESC;

# Query 7 — Weekly Staffing vs Demand Pattern
# Business question: Are we consistently understaffed on certain days of the week?

SELECT
    DAYNAME(shift_date)                         AS day_of_week,
    DAYOFWEEK(shift_date)                       AS day_num,
    shift_type,
    ROUND(AVG(planned_workers), 1)              AS avg_planned,
    ROUND(AVG(actual_workers), 1)               AS avg_actual,
    ROUND(AVG(planned_workers - actual_workers), 1) AS avg_gap,
    ROUND(AVG(overtime_hours), 2)               AS avg_overtime,
    COUNT(CASE WHEN actual_workers < planned_workers * 0.85
               THEN 1 END)                      AS understaffed_shifts
FROM shifts
GROUP BY DAYNAME(shift_date), DAYOFWEEK(shift_date), shift_type
ORDER BY day_num, shift_type;

# Query 8 — Product Category Performance
# Business question: Which product categories are most likely to be late?

SELECT
    product_category,
    COUNT(*)                                    AS total_shipments,
    SUM(unit_count)                             AS total_units,
    ROUND(AVG(unit_count), 1)                   AS avg_units,
    SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) AS late_count,
    ROUND(SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                AS late_pct,
    ROUND(SUM(sales_amount), 2)                 AS total_revenue,
    ROUND(SUM(profit), 2)                       AS total_profit
FROM shipments
GROUP BY product_category
ORDER BY late_pct DESC;