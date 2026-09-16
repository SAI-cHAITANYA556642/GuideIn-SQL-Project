# GuideIn-SQL-Project
MySQL-based GuideIn user funnel analysis using SQL to analyze visits, registrations, logins, subscriptions, conversion rates, and user drop-offs.
# GuideIn SQL Project

## Project Overview

This project focuses on analyzing GuideIn user funnel data using MySQL and SQL.

The analysis tracks the user journey from visiting the platform to registration, login, and subscription.

## Funnel

Visit → Register → Login → Subscribe

## Objectives

- Analyze total users
- Analyze visitors
- Analyze registered users
- Analyze logged-in users
- Analyze subscribed users
- Calculate conversion rates
- Identify funnel drop-offs
- Analyze monthly user activity
- Analyze services
- Analyze traffic sources
- Analyze devices

## Tools Used

- MySQL
- SQL

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- COUNT
- DISTINCT
- SUM
- CASE WHEN
- ROUND
- NULLIF
- DATE_FORMAT
- LIMIT
- Aggregate Functions

## Analysis Performed

### 1. User Funnel Analysis

Analyzed:

- Total Users
- Visitors
- Registrations
- Logins
- Subscriptions

### 2. Conversion Analysis

Calculated:

- Visit → Register Conversion
- Register → Login Conversion
- Login → Subscribe Conversion
- Overall Subscription Rate

### 3. Monthly Analysis

Analyzed user activity by month.

### 4. Service Analysis

Analyzed:

- Total visits by service
- Visitors by service
- Registrations by service
- Logins by service
- Subscriptions by service

### 5. Source Analysis

Analyzed user activity by traffic source.

### 6. Device Analysis

Analyzed user activity by device.

### 7. Drop-off Analysis

Identified users who:

- Visited but did not register
- Registered but did not login
- Logged in but did not subscribe

## Project Structure

```text
GuideIn-SQL-Project/
│
├── README.md
│
└── guidein_analysis.sql
