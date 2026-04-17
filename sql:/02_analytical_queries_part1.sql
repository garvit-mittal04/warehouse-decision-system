-- ============================================================
-- WAREHOUSE OPS PROJECT — DATABASE SCHEMA
-- Author: Garvit Mittal | Phase 1, Step 3
-- ============================================================

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS warehouse_ops;

-- Step 2: Tell MySQL to use it for all following commands
USE warehouse_ops;

-- ─────────────────────────────────────────────────────────────
-- TABLE 1: SHIPMENTS
-- Every shipment the warehouse processes (inbound + outbound).
-- This is the heart of the entire project.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS shipments (
    shipment_id       INT AUTO_INCREMENT PRIMARY KEY,
    shipment_date     DATE NOT NULL,
    carrier_id        VARCHAR(20),
    shipment_type     ENUM('inbound', 'outbound') NOT NULL,
    product_category  VARCHAR(50),
    unit_count        INT,
    pallet_count      INT,
    scheduled_dock    VARCHAR(10),
    arrival_time      TIME,
    departure_time    TIME,
    status            ENUM('on_time', 'late', 'cancelled', 'no_show') DEFAULT 'on_time',
    late_risk_flag    TINYINT(1) DEFAULT 0,
    shipping_mode     VARCHAR(30),
    sales_amount      DECIMAL(10,2),
    profit            DECIMAL(10,2),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────────────────────
-- TABLE 2: SHIFTS
-- Every work shift that was scheduled and actually staffed.
-- This is our labor data — the biggest cost driver.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS shifts (
    shift_id          INT AUTO_INCREMENT PRIMARY KEY,
    shift_date        DATE NOT NULL,
    shift_type        ENUM('morning', 'afternoon', 'night') NOT NULL,
    planned_workers   INT,
    actual_workers    INT,
    labor_hours       DECIMAL(6,2),
    overtime_hours    DECIMAL(6,2) DEFAULT 0,
    supervisor_id     VARCHAR(20),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────────────────────
-- TABLE 3: DOCK_EVENTS
-- Every time a carrier used a dock door.
-- Tracks wait times, delays, and door utilization.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dock_events (
    event_id          INT AUTO_INCREMENT PRIMARY KEY,
    event_date        DATE NOT NULL,
    dock_door         VARCHAR(10),
    carrier_id        VARCHAR(20),
    scheduled_start   TIME,
    actual_start      TIME,
    actual_end        TIME,
    wait_time_min     INT DEFAULT 0,
    shipment_id       INT,
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);

-- ─────────────────────────────────────────────────────────────
-- TABLE 4: THROUGHPUT_SCANS
-- Units scanned (processed) per hour per shift.
-- This is our productivity measurement.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS throughput_scans (
    scan_id           INT AUTO_INCREMENT PRIMARY KEY,
    scan_datetime     DATETIME NOT NULL,
    shift_id          INT,
    units_scanned     INT,
    scan_type         ENUM('receive', 'sort', 'load', 'dispatch'),
    FOREIGN KEY (shift_id) REFERENCES shifts(shift_id)
);

-- ─────────────────────────────────────────────────────────────
-- TABLE 5: DISRUPTIONS
-- Any operational incident — no-shows, breakdowns, surges.
-- This becomes our ML risk model's training data.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS disruptions (
    disruption_id     INT AUTO_INCREMENT PRIMARY KEY,
    disruption_date   DATE NOT NULL,
    disruption_type   VARCHAR(50),
    severity          ENUM('low', 'medium', 'high', 'critical'),
    duration_hours    DECIMAL(5,2),
    root_cause        VARCHAR(100),
    cost_impact       DECIMAL(10,2),
    shift_id          INT,
    FOREIGN KEY (shift_id) REFERENCES shifts(shift_id)
);

-- ─────────────────────────────────────────────────────────────
-- VERIFY: Run this to confirm all 5 tables were created
-- ─────────────────────────────────────────────────────────────
SHOW TABLES;


USE warehouse_ops;

SELECT 'shipments'        AS table_name, COUNT(*) AS row_count FROM shipments        UNION ALL
SELECT 'shifts',                         COUNT(*)              FROM shifts             UNION ALL
SELECT 'dock_events',                    COUNT(*)              FROM dock_events        UNION ALL
SELECT 'throughput_scans',               COUNT(*)              FROM throughput_scans   UNION ALL
SELECT 'disruptions',                    COUNT(*)              FROM disruptions;