<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Target_Report.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sales Target Dashboard</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI';
        }

        body {
            background: #F8FAFC;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */

        .sidebar {
            width: 260px;
            background: #0F172A;
            color: white;
            position: fixed;
            height: 100vh;
        }

        .logo {
            padding: 25px;
            font-size: 22px;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }

        .menu {
            padding-top: 20px;
        }

        .menu a {
            display: block;
            color: #CBD5E1;
            text-decoration: none;
            padding: 14px 25px;
            transition: .3s;
        }

        .menu a:hover {
            background: rgba(255,255,255,0.08);
            color: white;
        }

        .menu i {
            width: 25px;
        }

        /* MAIN */

        .main {
            margin-left: 260px;
            width: calc(100% - 260px);
        }

        /* NAVBAR */

        .navbar {
            background: #FFFFFF;
            height: 70px;
            padding: 0 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0px 2px 10px rgba(0,0,0,0.05);
        }

        .navbar h2 {
            color: #0F172A;
        }

        .profile {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .profile img {
            width: 42px;
            height: 42px;
            border-radius: 50%;
        }

        /* CONTENT */

        .content {
            padding: 25px;
        }

        /* CARDS */

        .cards {
            display: grid;
            grid-template-columns: repeat(5,1fr);
            gap: 20px;
        }

        .card {
            background: #FFFFFF;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .card .icon {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 22px;
            margin-bottom: 15px;
        }

        .blue {
            background: #2563EB;
        }

        .green {
            background: #10B981;
        }

        .orange {
            background: #F59E0B;
        }

        .red {
            background: #EF4444;
        }

        .dark {
            background: #0F172A;
        }

        .card h4 {
            color: #64748B;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .card h2 {
            color: #0F172A;
        }

        /* CHART SECTION */

        .chart-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-top: 25px;
        }

        .chart-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .chart-card h3 {
            margin-bottom: 20px;
            color: #0F172A;
        }

        .fake-chart {
            height: 280px;
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            padding: 10px;
        }

        .bar {
            width: 40px;
            background: #2563EB;
            border-radius: 8px 8px 0 0;
        }

        .bar:nth-child(2) {
            height: 180px;
        }

        .bar:nth-child(1) {
            height: 120px;
        }

        .bar:nth-child(3) {
            height: 220px;
        }

        .bar:nth-child(4) {
            height: 140px;
        }

        .bar:nth-child(5) {
            height: 250px;
        }

        .bar:nth-child(6) {
            height: 170px;
        }

        /* PIE */

        .pie-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 280px;
        }

        .pie {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background:
                conic-gradient(
                #10B981 0% 72%,
                #EF4444 72% 100%);
        }

        /* TABLE */

        .table-card {
            margin-top: 25px;
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background: #F8FAFC;
            color: #475569;
            text-align: left;
            padding: 12px;
        }

        table td {
            padding: 14px 12px;
            border-bottom: 1px solid #E2E8F0;
        }

        .badge-success {
            background: rgba(16,185,129,0.15);
            color: #10B981;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
        }

        .badge-warning {
            background: rgba(245,158,11,0.15);
            color: #F59E0B;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

<div class="wrapper">

    <!-- Sidebar -->

    <div class="sidebar">

        <div class="logo">
            Sales Target
        </div>

        <div class="menu">
            <a href="#"><i class="fa fa-chart-line"></i> Dashboard</a>
            <a href="#"><i class="fa fa-users"></i> Partner Master</a>
            <a href="#"><i class="fa fa-bullseye"></i> Target Master</a>
            <a href="#"><i class="fa fa-coins"></i> Daily Sales</a>
            <a href="#"><i class="fa fa-file-excel"></i> Reports</a>
        </div>

    </div>

    <!-- Main -->

    <div class="main">

        <div class="navbar">
            <h2>Dashboard</h2>

            <div class="profile">
                <i class="fa fa-user-circle fa-2x"></i>
                <span>Admin</span>
            </div>
        </div>

        <div class="content">

            <!-- KPI Cards -->

            <div class="cards">

                <div class="card">
                    <div class="icon dark">
                        <i class="fa fa-users"></i>
                    </div>
                    <h4>Total Partners</h4>
                    <h2>125</h2>
                </div>

                <div class="card">
                    <div class="icon blue">
                        <i class="fa fa-chart-bar"></i>
                    </div>
                    <h4>Sales Target</h4>
                    <h2>₹45L</h2>
                </div>

                <div class="card">
                    <div class="icon green">
                        <i class="fa fa-check"></i>
                    </div>
                    <h4>Achieved</h4>
                    <h2>₹31L</h2>
                </div>

                <div class="card">
                    <div class="icon orange">
                        <i class="fa fa-hourglass-half"></i>
                    </div>
                    <h4>Remaining</h4>
                    <h2>₹14L</h2>
                </div>

                <div class="card">
                    <div class="icon red">
                        <i class="fa fa-trophy"></i>
                    </div>
                    <h4>Top Performer</h4>
                    <h2>ABC Corp</h2>
                </div>

            </div>

            <!-- Charts -->

            <div class="chart-row">

                <div class="chart-card">
                    <h3>Monthly Target vs Achievement</h3>

                    <div class="fake-chart">
                        <div class="bar"></div>
                        <div class="bar"></div>
                        <div class="bar"></div>
                        <div class="bar"></div>
                        <div class="bar"></div>
                        <div class="bar"></div>
                    </div>
                </div>

                <div class="chart-card">
                    <h3>Achievement Ratio</h3>

                    <div class="pie-container">
                        <div class="pie"></div>
                    </div>
                </div>

            </div>

            <!-- Top Performers -->

            <div class="table-card">

                <h3 style="margin-bottom:20px;">Top Performing Partners</h3>

                <table>

                    <tr>
                        <th>Partner</th>
                        <th>Target</th>
                        <th>Achieved</th>
                        <th>Status</th>
                    </tr>

                    <tr>
                        <td>ABC Traders</td>
                        <td>₹5,00,000</td>
                        <td>₹5,80,000</td>
                        <td><span class="badge-success">Achieved</span></td>
                    </tr>

                    <tr>
                        <td>XYZ Enterprises</td>
                        <td>₹4,00,000</td>
                        <td>₹3,20,000</td>
                        <td><span class="badge-warning">Pending</span></td>
                    </tr>

                    <tr>
                        <td>PQR Distributors</td>
                        <td>₹6,00,000</td>
                        <td>₹6,40,000</td>
                        <td><span class="badge-success">Achieved</span></td>
                    </tr>

                </table>

            </div>

        </div>

    </div>

</div>

</form>

</body>
</html>
