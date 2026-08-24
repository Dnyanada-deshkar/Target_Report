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

## 💰 Daily Sales Entry

- Select Partner
- Record Daily Sales
- Auto Calculate Remaining Target Balance
- Prevent Invalid Entries
- Today's Sales Entry List
- Search Today's Entries
- Edit Daily Sale
- Delete Daily Sale
- Pagination 
- Sales Activity Tracking
- Automatic Target Balance Recalculation
- Sales Update Support
---

## 📈 Monthly Target Snapshot

Automatically stores monthly achievement details including:

- Sales Target
- Total Achievement
- Remaining Balance
- Achievement Percentage

---

# 🛠 Technologies Used

### Frontend
- ASP.NET Web Forms
- HTML5
- CSS3
- JavaScript

### Backend
- C#
- ADO.NET

### Database
- Microsoft SQL Server

### IDE
- Visual Studio 2022

---

# 🗂 Database Tables

- PartnerMaster
- BrandMaster
- PartnerBrandMapping
- TargetMaster
- DailySalesEntry
- MonthlyTargetSnapshot
- BranchMaster

---

# 🔒 Validation & Data Integrity

- Required Field Validation
- Duplicate Partner Name Validation
- Duplicate Contact Number Validation
- Foreign Key Constraints
- Server-side Validation
- SQL Stored Procedure Based Operations
-  Activity Logging for Important Operations
- Server-side Database Validation
- Stored Procedure Based Data Operations

# ⚙ Stored Procedures

Examples:

- USP_GetPartners
- USP_GetPartnerTarget
- USP_SaveDailySale
- USP_Target_Insert
- USP_Target_Update
- USP_Target_Delete
- USP_DailySales_GetToday
- USP_DailySales_Update
- USP_DailySales_Delete
- USP_Partner_Insert
- USP_Partner_Update
- USP_Partner_GetAll
- USP_Partner_GetByID
- USP_Brand_GetAll
- USP_PartnerBrandMapping_Save
- USP_Dashboard_GetSummary
- USP_Dashboard_GetRecentActivity
- USP_Partner_Insert
- USP_Partner_Update
- USP_Target_Insert
- USP_Target_Update
- USP_Sales_Insert
- USP_Sales_Update
---

# ✨ Highlights

- Built using ASP.NET Web Forms and ADO.NET
- SQL Server database with Stored Procedures
- Layered project structure for easier maintenance
- Real-time sales achievement calculations
- Partner & Brand relationship management
- Input validation and duplicate record prevention
- Responsive admin dashboard with toast notifications
---

# 🎨 User Interface

- Professional Admin Dashboard
- Responsive Forms
- Modern Data Grid
- Search and Filtering
- Pagination Controls
- Success & Error Toast Notifications
- Clean Card-Based Layout
# 📂 Project Structure

```
Target_Report
│
├── Dashboard.aspx
├── PartnerMaster.aspx
├── TargetMaster.aspx
├── DailySalesEntry.aspx
│
├── CSS
│   ├── Dashboard.css
│   ├── PartnerMaster.css
│   ├── TargetMaster.css
│   └── DailySalesEntry.css
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
- ADO.NET
- SQL Server
- Stored Procedures
- CRUD Operations
- GridView
- Validation Controls
- Dashboard Design
- Master Pages
- Layered UI Development

---

# 👨‍💻 Developed By

GitHub: [https://github.com/Dnyanada-deshkar]
GitHub: [https://github.com/Abhishek400217]

---

# 📄 License

This project is developed for learning and educational purposes.
