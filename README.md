# 🎯 Sales Target Report Management System

A complete **ASP.NET Web Forms** application developed for managing **Sales Targets**, **Daily Sales Entries**, and **Partner Performance Tracking**.

The system allows administrators to manage partners, assign monthly sales targets, record daily sales, and monitor target achievement through an interactive dashboard.

---

# 🚀 Features

## 📊 Dashboard
- Total Partners
- Active Monthly Targets
- Sales Achievement Summary
- Remaining Target Balance
- Quick Navigation Cards

---

## 👥 Partner Master
- Add New Partner
- Update Partner Details
- Delete Partner
- Search Partner
- Pagination
- Input Validation
- Toast Notifications

---

## 🎯 Target Master

- Assign Monthly Sales Target
- Purchase Potential Management
- Target Validation
- Edit Existing Target
- Delete Target
- Search Records
- Pagination
- Achievement Calculation

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
- TargetMaster
- DailySalesEntry
- MonthlyTargetSnapshot
- BranchMaster

---

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

---

# ✨ Project Highlights

✔ Clean Dashboard UI

✔ Responsive Card Layout

✔ Search Functionality

✔ Pagination

✔ CRUD Operations

✔ SQL Stored Procedures

✔ Layered Code Structure

✔ Validation Controls

✔ Toast Notifications

✔ Professional Admin Interface

---

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

**Your Name**

GitHub: [https://github.com/Dnyanada-deshkar]
GitHub: [https://github.com/Abhishek400217]

---

# 📄 License

This project is developed for learning and educational purposes.
