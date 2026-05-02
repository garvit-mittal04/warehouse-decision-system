-- ============================================================
-- WAREHOUSE OPS PROJECT — ANALYTICAL QUERIES (PART 2)
-- Author: Garvit Mittal | Queries 9–15
-- Picks up where 02_analytical_queries_part1.sql left off.
-- ============================================================

USE warehouse_ops;

# Query 9 — Carrier Reliability Ranking
# Business question: Which carriers cause the most delays? Who should we deprioritise?

SELECT
    carrier_id,
    COUNT(*)                                                AS total_shipments,
    SUM(CASE WHEN status = 'on_time'    THEN 1 ELSE 0 END) AS on_time_count,
    SUM(CASE WHEN status = 'late'       THEN 1 ELSE 0 END) AS late_count,
    SUM(CASE WHEN status = 'cancelled'  THEN 1 ELSE 0 END) AS cancelled_count,
    SUM(CASE WHEN status = 'no_show'    THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                           AS late_pct,
    ROUND(SUM(sales_amount), 2)                            AS total_revenue,
    ROUND(AVG(unit_count), 1)                              AS avg_units_per_shipment
FROM shipments
GROUP BY carrier_id
ORDER BY late_pct DESC;


# Query 10 — Disruption Root-Cause Analysis
# Business question: What is actually causing our disruptions, and is it getting worse over time?

SELECT
    YEAR(disruption_date)                   AS year,
    MONTH(disruption_date)                  AS month,
    root_cause,
    COUNT(*)                                AS occurrences,
    ROUND(AVG(duration_hours), 2)           AS avg_duration_hrs,
    ROUND(SUM(cost_impact), 2)              AS total_cost_impact,
    SUM(CASE WHEN severity IN ('high','critical')
             THEN 1 ELSE 0 END)             AS high_severity_events
FROM disruptions
GROUP BY YEAR(disruption_date), MONTH(disruption_date), root_cause
ORDER BY year, month, total_cost_impact DESC;


# Query 11 — Shift-Level Disruption Impact on Throughput
# Business question: How much does a disruption during each shift type suppress throughput?

SELECT
    s.shift_type,
    CASE WHEN d.disruption_id IS NOT NULL THEN 'Disrupted' ELSE 'Clean' END AS shift_status,
    COUNT(DISTINCT s.shift_id)                AS total_shifts,
    ROUND(AVG(ts.units_scanned), 1)           AS avg_units_scanned,
    ROUND(AVG(s.overtime_hours), 2)           AS avg_overtime_hrs,
    ROUND(AVG(d.cost_impact), 2)              AS avg_disruption_cost
FROM shifts s
LEFT JOIN disruptions d  ON s.shift_id = d.shift_id
LEFT JOIN throughput_scans ts ON s.shift_id = ts.shift_id
GROUP BY s.shift_type,
         CASE WHEN d.disruption_id IS NOT NULL THEN 'Disrupted' ELSE 'Clean' END
ORDER BY s.shift_type, shift_status DESC;


# Query 12 — Overtime Cost Concentration
# Business question: Which supervisors / shifts are driving the bulk of overtime costs?
#                    (Assumes $45/hr overtime premium on top of base labour rate.)

SELECT
    supervisor_id,
    shift_type,
    COUNT(*)                                        AS total_shifts,
    ROUND(SUM(overtime_hours), 1)                   AS total_overtime_hrs,
    ROUND(AVG(overtime_hours), 2)                   AS avg_overtime_per_shift,
    ROUND(SUM(overtime_hours) * 45, 2)              AS estimated_overtime_cost,
    COUNT(CASE WHEN overtime_hours > 2 THEN 1 END)  AS shifts_over_2h_overtime
FROM shifts
WHERE overtime_hours > 0
GROUP BY supervisor_id, shift_type
ORDER BY total_overtime_hrs DESC
LIMIT 20;


# Query 13 — Inbound vs Outbound Performance Comparison
# Business question: Are our inbound or outbound flows the bigger source of delays and cost?

SELECT
    shipment_type,
    COUNT(*)                                            AS total_shipments,
    SUM(unit_count)                                     AS total_units,
    ROUND(AVG(unit_count), 1)                           AS avg_units,
    SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)   AS late_shipments,
    ROUND(SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                        AS late_pct,
    ROUND(SUM(sales_amount), 2)                         AS total_revenue,
    ROUND(AVG(sales_amount), 2)                         AS avg_revenue_per_shipment,
    ROUND(SUM(profit), 2)                               AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales_amount), 0) * 100, 1) AS profit_margin_pct
FROM shipments
GROUP BY shipment_type;


# Query 14 — Dock Utilisation Heat-Map Data
# Business question: Which dock doors are consistently overloaded vs. underused?
#                    (Feeds a downstream heat-map visualisation.)

SELECT
    dock_door,
    DAYNAME(event_date)                             AS day_of_week,
    DAYOFWEEK(event_date)                           AS day_num,
    COUNT(*)                                        AS total_events,
    ROUND(AVG(wait_time_min), 1)                    AS avg_wait_mins,
    SUM(CASE WHEN wait_time_min > 45 THEN 1 ELSE 0 END)  AS long_wait_events,
    ROUND(SUM(CASE WHEN wait_time_min > 45 THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                    AS long_wait_pct
FROM dock_events
GROUP BY dock_door, DAYNAME(event_date), DAYOFWEEK(event_date)
ORDER BY dock_door, day_num;


# Query 15 — Executive KPI Summary (single-row dashboard feed)
# Business question: What are our headline numbers for the reporting period?

SELECT
    COUNT(DISTINCT s.shipment_date)                          AS operating_days,
    COUNT(s.shipment_id)                                     AS total_shipments,
    SUM(s.unit_count)                                        AS total_units_processed,
    ROUND(SUM(s.sales_amount), 2)                            AS total_revenue,
    ROUND(SUM(s.profit), 2)                                  AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.sales_amount),0)*100, 1) AS overall_margin_pct,
    ROUND(SUM(CASE WHEN s.status = 'late' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1)                             AS overall_late_pct,
    ROUND(SUM(d.cost_impact), 2)                             AS total_disruption_cost,
    ROUND(SUM(sh.overtime_hours) * 45, 2)                    AS total_overtime_cost,
    ROUND(AVG(de.wait_time_min), 1)                          AS avg_dock_wait_mins
FROM shipments s
LEFT JOIN disruptions d   ON DATE(s.shipment_date) = d.disruption_date
LEFT JOIN shifts sh        ON DATE(s.shipment_date) = sh.shift_date
LEFT JOIN dock_events de   ON s.shipment_id = de.shipment_id;
