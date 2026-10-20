# 🎯 Sales Target Report Management System

A complete **ASP.NET Web Forms** application developed for managing **Partners, Sales Targets, Daily Sales Entries, Follow-ups, and Performance Reporting**.

The system allows administrators to manage partners and brands, configure partner-level sales targets, record daily sales with automatic target-balance calculations, manage follow-ups, and monitor performance through dashboards and detailed reports.

---   

# 🚀 Features

## 📊 Dashboard

- Total Active Partners
- Current Month Sales Target
- Current Month Sales Achievement
- Pending Target Balance
- Achievement Percentage
- Active Branch Summary
- Target vs Achievement Monthly Comparison
- Target Status Doughnut Chart
- Branch Performance Overview
- Monthly Achievement Trend
- Recent Activity Feed
- Quick Navigation Cards

---

## 📋 Recent Activity

The dashboard provides a recent activity feed for important system actions.

Tracked activities include:

- Partner Added
- Partner Updated
- Target Updated
- Daily Sale Recorded
- Daily Sale Updated
- Follow-up Activity

Activities are displayed with the latest action first along with the activity time and relevant information where applicable.

---

## 👥 Partner Master

- Add New Partner
- Update Partner Details
- Soft Delete Partner
- Search Partner
- Pagination
- Input Validation
- Toast Notifications
- Duplicate Partner Validation
- Duplicate Contact Validation
- Contact Person Management
- Purchase Potential Management
- Partner-level Sales Target Management
- Multiple Brand Assignment
- Brand Mapping Support
- Partner Performance Display
- Active/Deleted Partner Handling
- Responsive Layout
- Edit Mode Support

---
## 💰 Daily Sales & Follow-up

- Select Active Partner
- Select Sales Executive
- Record Daily Sales
- Automatic Target Balance Calculation
- Partner-level Target Tracking
- Current Target Cycle Calculation
- Running Sales Achievement Calculation
- Target Balance Recalculation after Sale Update
- Target Balance Recalculation after Sale Delete
- Today's Sales Entry List
- Current Month Sales List
- Search Current Month Sales
- Edit Daily Sale
- Delete Daily Sale
- Pagination
- Sales Executive Tracking
- Partner Brand Display
- Follow-up Remark Management
- Follow-up Date Management
- Follow-up Sales Executive Assignment
- Contact Number Auto-fill
- Sales Activity Tracking
- Server-side Validation
- Toast Notifications
---

## 📞 Partner Follow-up

- Follow-up Remark Entry
- Follow-up Date Scheduling
- Sales Executive Assignment
- Partner Contact Information
- Follow-up History
- Pending Follow-up Tracking
- Follow-up Reminder/Alert
- Follow-up Status Management
- Follow-up Activity Tracking

## 📊 Sales Performance Report

The reporting module provides live sales-performance data based on partner targets and daily sales entries.

Features include:

- Year-wise Sales Report
- Month-wise Sales Report
- Partner Filter
- Branch Filter
- Sales Executive Filter
- Active Partner Filtering
- Sales Achievement
- Running Target Balance
- Achievement Percentage
- Sales Executive-wise Sales Entries
- Sorting
- Pagination
- Excel Export

---

# 🛠 Technologies Used

### Application
- ASP.NET Web Forms
- C#
- ADO.NET

### Frontend
- HTML5
- CSS3
- JavaScript

### Database
- Microsoft SQL Server
- T-SQL
- Stored Procedures

### IDE
- Visual Studio 2022
---

## 🗂 Database Tables

- PartnerMaster
- BrandMaster
- PartnerBrandMapping
- DailySalesEntry
- SalesExecutiveMaster
- MonthlyTargetSnapshot
- BranchMaster

---

# 🔒 Validation & Data Integrity

- Required Field Validation
- Duplicate Partner Name Validation
- Duplicate Contact Number Validation
- Server-side Validation
- Database-level Validation
- Foreign Key Constraints
- Stored Procedure Based Database Operations
- Soft Delete Support
- Active Partner Filtering
- Automatic Target Balance Recalculation
- Sales Update/Delete Recalculation
- Activity Logging

# ⚙ Stored Procedures

Examples of stored procedures used by the application:

### Partner
- USP_GetPartners
- USP_GetPartnerContact
- USP_GetPartnerTarget
- usp_PartnerMaster_GetList
- USP_Partner_Insert
- USP_Partner_Update

### Sales
- USP_SaveDailySale
- USP_GetCurrentDaySales
- USP_GetCurrentMonthSales
- USP_UpdateDailySale
- USP_DeleteDailySale
- usp_DailySales_GetPartnerBrands

### Follow-up
- USP_SavePartnerFollowUp
- USP_GetPendingFollowUps

### Sales Executive
- USP_GetSalesExecutiveList

### Dashboard
- USP_Dashboard_GetSummary
- USP_Dashboard_GetRecentActivity

### Reports
- usp_MonthlySnapshotReport
- usp_MonthlySnapshot_GetList
---
# ✨ Highlights

- ASP.NET Web Forms based admin management system
- SQL Server with T-SQL Stored Procedures
- Partner-level target management
- Real-time daily sales tracking
- Automatic running target-balance calculation
- Sales Executive-wise sales tracking
- Partner & Brand relationship management
- Partner follow-up management
- Active partner and soft-delete handling
- Dynamic sales reporting
- Year, Month, Branch, Partner and Executive filters
- Sorting and pagination
- Excel report export
- Server-side validation
- Responsive admin UI
- Toast-based success and error notifications
---

# 🎨 User Interface

- Professional Admin Dashboard
- Responsive Forms
- Modern Data Grids
- Dynamic Filters
- Sorting & Pagination
- Search Controls
- Success & Error Toast Notifications
- Card-Based KPI Layout
- Partner & Sales Management Screens
- Follow-up Management UI
- Excel Export Action
- Clean Admin Navigation
  
# 📂 Project Structure

```
Target_Report
│
├── Dashboard.aspx
├── PartnerMaster.aspx
├── DailySalesEntry.aspx
├── MonthlySnapshotReport.aspx
│
├── CSS
│   ├── Dashboard.css
│   ├── PartnerMaster.css
│   ├── DailySalesEntry.css
│   └── MonthlySnapshotReport.css
│
├── SQL
│   ├── Tables.sql
│   └── StoredProcedures.sql
│
└── Web.config
```

---

# ▶ How to Run

1. Clone the repository

2. Open the project in Visual Studio.

3. Restore the SQL Database.

4. Update the connection string in **Web.config**.

5. Run the project.

---

# 📚 Learning Objectives

This project demonstrates:

- ASP.NET Web Forms
- C#
- ADO.NET
- SQL Server
- T-SQL Stored Procedures
- CRUD Operations
- GridView
- Validation Controls
- Master Pages
- Dashboard Development
- Dynamic Filtering
- Pagination & Sorting
- Sales Tracking
- Target Balance Calculations
- Follow-up Management
- Soft Delete Handling
- Excel Export

---

# 👨‍💻 Developed By

GitHub: [https://github.com/Dnyanada-deshkar]
GitHub: [https://github.com/Abhishek400217]

---

# 📄 License

This project is developed for learning and educational purposes.
