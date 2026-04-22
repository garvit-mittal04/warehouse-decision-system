# Power Automate Integration – Warehouse Alert System

## Overview
This project integrates Microsoft Power Automate to create a real-time alerting system for warehouse operations.

Whenever a new warehouse report is uploaded, the system automatically:
- Detects the file upload
- Sends an email alert
- Logs the event into an Excel file

## Workflow Logic

Trigger:
- When a file is created in OneDrive (Incoming Reports folder)

Actions:
1. Send Email Notification
   - Includes file name, file path, and timestamp

2. Log Event in Excel
   - Timestamp
   - File Name
   - File Path
   - Alert Type
   - Status

## Email Example

- Subject: Warehouse Alert: New report uploaded
- Body includes:
  - File Name
  - File Path
  - Detection Time

## Business Impact

- Eliminates manual monitoring of warehouse reports
- Enables real-time operational awareness
- Creates automated audit logs
- Reduces delay in decision-making

## Tech Stack

- Microsoft Power Automate
- OneDrive
- Excel (logging)
- Outlook (notifications)

## Future Improvements

- Add anomaly detection triggers
- Integrate with Power BI dashboards
- Push alerts to Teams / Slack
