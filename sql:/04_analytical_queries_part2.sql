USE warehouse_ops;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE throughput_scans;
TRUNCATE TABLE dock_events;
TRUNCATE TABLE disruptions;
TRUNCATE TABLE shifts;
TRUNCATE TABLE shipments;

SET FOREIGN_KEY_CHECKS = 1;

-- Verify all tables are now empty
SELECT 'shipments'        AS table_name, COUNT(*) AS row_count FROM shipments        UNION ALL
SELECT 'shifts',                         COUNT(*)              FROM shifts             UNION ALL
SELECT 'dock_events',                    COUNT(*)              FROM dock_events        UNION ALL
SELECT 'throughput_scans',               COUNT(*)              FROM throughput_scans   UNION ALL
SELECT 'disruptions',                    COUNT(*)              FROM disruptions;

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

USE warehouse_ops;

-- 1. Shipments
LOAD DATA LOCAL INFILE '/Users/garvitmittal/Desktop/warehouse_ops_project/01_data/Processed data/shipments.csv'
INTO TABLE shipments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(shipment_date, carrier_id, shipment_type, product_category,
 unit_count, pallet_count, scheduled_dock, shipping_mode,
 status, late_risk_flag, sales_amount, profit);

-- 2. Shifts
LOAD DATA LOCAL INFILE '/Users/garvitmittal/Desktop/warehouse_ops_project/01_data/Processed data/shifts.csv'
INTO TABLE shifts
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(shift_id, shift_date, shift_type, planned_workers,
 actual_workers, labor_hours, overtime_hours, supervisor_id);

-- 3. Dock Events
LOAD DATA LOCAL INFILE '/Users/garvitmittal/Desktop/warehouse_ops_project/01_data/Processed data/dock_events.csv'
INTO TABLE dock_events
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(event_id, event_date, dock_door, carrier_id,
 scheduled_start, actual_start, actual_end, wait_time_min);

-- 4. Throughput Scans
LOAD DATA LOCAL INFILE '/Users/garvitmittal/Desktop/warehouse_ops_project/01_data/Processed data/throughput_scans.csv'
INTO TABLE throughput_scans
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(scan_id, scan_datetime, shift_id, units_scanned, scan_type);

-- 5. Disruptions
LOAD DATA LOCAL INFILE '/Users/garvitmittal/Desktop/warehouse_ops_project/01_data/Processed data/disruptions.csv'
INTO TABLE disruptions
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(disruption_id, disruption_date, disruption_type, severity,
 duration_hours, root_cause, cost_impact, shift_id);