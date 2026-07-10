<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="Dashboard.aspx.cs" Inherits="Target_Report.Dashboard" %>
<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Dashboard · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">
    <link rel="stylesheet" href="Dashboard.css" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script></asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

    <div class="dashboard-container">

      
        <div class="dashboard-header">
            <div class="dashboard-heading-block">
                <h1 class="dashboard-title">Sales Dashboard</h1>
                <p class="dashboard-subtitle">Business performance overview and target tracking.</p>
            </div>
            <div class="dashboard-header-right">
                <nav class="dashboard-breadcrumb" aria-label="Breadcrumb">
                    <span class="crumb-current">Dashboard</span>
                </nav>
                <div class="dashboard-date">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    <asp:Literal ID="litCurrentDate" runat="server" />
                </div>
            </div>
        </div>

       
        <div class="kpi-grid">

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    </div>
                    <span class="kpi-trend is-up">
                        <asp:Literal ID="litTotalPartnersTrend" runat="server" Text="+4" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblTotalPartners" runat="server" Text="0" /></div>
                <div class="kpi-label">Total Partners</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="4.5"></circle><circle cx="12" cy="12" r="0.8" fill="currentColor"></circle></svg>
                    </div>
                    <span class="kpi-trend is-neutral">
                        <asp:Literal ID="litMonthlyTargetTrend" runat="server" Text="This month" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblMonthlyTarget" runat="server" Text="0" /></div>
                <div class="kpi-label">Monthly Target</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap is-success">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                    </div>
                    <span class="kpi-trend is-up">
                        <asp:Literal ID="litAchievementTrend" runat="server" Text="+8.2%" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblAchievement" runat="server" Text="0" /></div>
                <div class="kpi-label">Achievement</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap is-danger">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    </div>
                    <span class="kpi-trend is-down">
                        <asp:Literal ID="litPendingBalanceTrend" runat="server" Text="Due" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblPendingBalance" runat="server" Text="0" /></div>
                <div class="kpi-label">Pending Balance</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap is-success">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path><path d="M22 12A10 10 0 0 0 12 2v10z"></path></svg>
                    </div>
                    <span class="kpi-trend is-up">
                        <asp:Literal ID="litAchievementPercentageTrend" runat="server" Text="On track" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblAchievementPercentage" runat="server" Text="0%" /></div>
                <div class="kpi-label">Achievement %</div>
            </div>

            <div class="kpi-card">
                <div class="kpi-card-top">
                    <div class="kpi-icon-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    </div>
                    <span class="kpi-trend is-neutral">
                        <asp:Literal ID="litActiveBranchesTrend" runat="server" Text="Pune · Nagpur" />
                    </span>
                </div>
                <div class="kpi-value"><asp:Label ID="lblActiveBranches" runat="server" Text="0" /></div>
                <div class="kpi-label">Active Branches</div>
            </div>

        </div>
        <div class="charts-grid">

            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                        <span>Target vs Achievement</span>
                    </div>
                    <span class="panel-header-meta">Monthly comparison</span>
                </div>
                <div class="panel-body">
                    <div class="chart-canvas-wrap">
                        <canvas id="chartTargetVsAchievement"></canvas>
                    </div>
                    <div class="chart-legend-row">
                        <span class="chart-legend-item"><span class="chart-legend-dot is-target"></span><h3>Target</h3></span>
                        <span class="chart-legend-item"><span class="chart-legend-dot is-achievement"></span><h3>Achievement</h3></span>
                    </div>
                </div>
            </section>

            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="4" y1="6" x2="14" y2="6"></line><line x1="4" y1="12" x2="20" y2="12"></line><line x1="4" y1="18" x2="11" y2="18"></line></svg>
                                <span>Target Status</span>                    </div>
                    <span class="panel-header-meta">Achieved vs Balance</span>
                </div>
                <div class="panel-body">

    <div style="position:relative;width:100%;height:320px;">
        <canvas id="chartTargetStatus"></canvas>
    </div>

    <div style="display:flex;justify-content:center;gap:24px;margin-top:16px;flex-wrap:wrap;">

        <span style="display:flex;align-items:center;gap:8px;font-size:13px;color:#222533;font-weight:500;">
            <span id="legendAchievedColor"
                  style="width:15px;height:15px;border-radius:8px;background:#1E3A8A;display:inline-block;box-shadow:0 2px 8px rgba(21,128,61,.25);">
            </span>
            <h2>Achieved</h2>
        </span>

        <span style="display:flex;align-items:center;gap:8px;font-size:13px;color:#222533;font-weight:500;">
            <span style="width:15px;height:15px;border-radius:8px;background:#EEF2FF;border:1px solid #C7D2FE;display:inline-block;">
            </span>
            <h2>Target Balance</h2>
        </span>

    </div>

</div>
            </section>

        </div>

        <!-- =================================================
             CHARTS — row 2: Achievement Trend (full width)
             ================================================= -->
        <div class="charts-grid-secondary">
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 17 9 11 13 15 21 7"></polyline><polyline points="14 7 21 7 21 14"></polyline></svg>
                        <span>Achievement Trend</span>
                    </div>
                    <span class="panel-header-meta">Last 6 months</span>
                </div>
                <div class="panel-body">
                    <div class="chart-canvas-wrap" style="height: 220px;">
                        <canvas id="chartAchievementTrend"></canvas>
                    </div>
                </div>
            </section>
        </div>

        <!-- =================================================
             LOWER GRID — Top Partners | Recent Activity + Quick Actions
             ================================================= -->
        <div class="lower-grid">
          
            <!-- Recent Activity + Quick Actions -->
            <div class="lower-grid-side">
               
                <section class="panel">
                    <div class="panel-header">
                        <div class="panel-header-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            <span>Recent Activity</span>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="activity-feed">
                            <asp:Repeater ID="rptRecentActivity" runat="server">
                                <ItemTemplate>
                                    <div class="activity-item">
                                        <div class='<%# "activity-icon-wrap" + (Eval("IconType").ToString() == "success" ? " is-success" : "") %>'>
                                            <%# Eval("IconSvg") %>
                                        </div>
                                        <div class="activity-content">
                                            <p class="activity-text"><%# Eval("ActivityText") %></p>
                                            <span class="activity-time"><%# Eval("TimeAgo") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </section>

                <section class="panel">
                    <div class="panel-header">
                        <div class="panel-header-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2L3 14h7l-1 8 10-12h-7l1-8Z"></path></svg>
                            <span>Quick Actions</span>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="quick-actions-grid">
                            <asp:HyperLink ID="lnkQuickAddPartner" runat="server" NavigateUrl="~/PartnerMaster.aspx" CssClass="quick-action-card">
                                <div class="quick-action-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><line x1="20" y1="8" x2="20" y2="14"></line><line x1="17" y1="11" x2="23" y2="11"></line></svg>
                                </div>
                                <span class="quick-action-label">Add Partner</span>
                            </asp:HyperLink>

                            <asp:HyperLink ID="lnkQuickAddExecutive"
    runat="server"
    NavigateUrl="~/SalesExecutiveMaster.aspx"
    CssClass="quick-action-card">

    <div class="quick-action-icon">

        <svg viewBox="0 0 24 24"
             fill="none"
             stroke="currentColor"
             stroke-width="1.8"
             stroke-linecap="round"
             stroke-linejoin="round">

            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
            <circle cx="12" cy="7" r="4"></circle>

        </svg>

    </div>

    <span class="quick-action-label">
        Add Sales Executive
    </span>

</asp:HyperLink>

                            <asp:HyperLink ID="lnkQuickAddTarget" runat="server" NavigateUrl="~/TargetMaster.aspx" CssClass="quick-action-card">
                                <div class="quick-action-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="4.5"></circle><circle cx="12" cy="12" r="0.8" fill="currentColor"></circle></svg>
                                </div>
                                <span class="quick-action-label">Add Target</span>
                            </asp:HyperLink>
                            <asp:HyperLink ID="lnkQuickAddSalesEntry" runat="server" NavigateUrl="~/DailySalesEntry.aspx" CssClass="quick-action-card">
                                <div class="quick-action-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20V10"></path><path d="M18 20V4"></path><path d="M6 20v-4"></path></svg>
                                </div>
                                <span class="quick-action-label">Add Sales Entry</span>
                            </asp:HyperLink>
                            <asp:HyperLink ID="lnkQuickViewReports" runat="server" NavigateUrl="~/MonthlySnapshotReport.aspx" CssClass="quick-action-card">
                                <div class="quick-action-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="9" y1="13" x2="15" y2="13"></line><line x1="9" y1="17" x2="15" y2="17"></line></svg>
                                </div>
                                <span class="quick-action-label">View Reports</span>
                            </asp:HyperLink>
                        </div>
                    </div>
                </section>

            </div>

        </div>

    </div>


    <!-- ========================================================= -->
<!-- FOLLOWUP POPUP -->
<!-- ========================================================= -->

 <asp:Panel ID="pnlReminderPopup"
    runat="server"
    CssClass="followup-overlay"
    Visible="false">

    <div class="followup-popup">

        <div class="popup-header">

            <div>

                <div class="popup-title">
                    🔔 Pending Follow-up
                </div>

                <div class="popup-subtitle">
                    Please complete today's follow-up
                </div>

            </div>

            <span class="badge-today">
                TODAY
            </span>

        </div>


        <div class="popup-body">

            <div class="info-card">

                <div class="info-item">

                    <span class="label">Partner</span>

                    <div class="value">
                        <asp:Label ID="lblPopupPartner"
                            runat="server" />
                    </div>

                </div>

                <div class="info-item">

                    <span class="label">Contact</span>

                    <div class="value">
                        <asp:Label ID="lblPopupContact"
                            runat="server" />
                    </div>

                </div>

                <div class="info-item">

                    <span class="label">Follow-up Date</span>

                    <div class="value">
                        <asp:Label ID="lblPopupDate"
                            runat="server" />
                    </div>

                </div>

            </div>


            <div class="remark-card">

                <div class="remark-title">
                    Previous Remark
                </div>

                <asp:TextBox
                    ID="txtOldRemark"
                    runat="server"
                    CssClass="remark-view"
                    ReadOnly="true"
                    TextMode="MultiLine" />

            </div>


            <div class="remark-card">

                <div class="remark-title">
                    Today's Remark
                </div>

                <asp:TextBox
                    ID="txtNewRemark"
                    runat="server"
                    CssClass="remark-input"
                    TextMode="MultiLine" />

            </div>

        </div>


        <div class="popup-footer">

    <asp:HiddenField
        ID="hdnFollowupID"
        runat="server" />

    <asp:Button
        ID="btnCompleteFollowup"
        runat="server"
        Text="✔ Complete Follow-up"
        CssClass="btn-complete"
        OnClick="btnCompleteFollowup_Click" />



        </div>

    </div>

</asp:Panel>
    <!-- =====================================================
         CHART DATA HANDOFF — server-rendered JSON consumed by
         Chart.js below. Hidden fields keep the data layer and
         the rendering layer cleanly separated.
         ===================================================== -->
    <asp:HiddenField ID="hdnChartLabels" runat="server" />
    <asp:HiddenField ID="hdnTargetData" runat="server" />
    <asp:HiddenField ID="hdnAchievementData" runat="server" />
    <asp:HiddenField ID="hdnBranchLabels" runat="server" />
    <asp:HiddenField ID="hdnBranchAchievementData" runat="server" />
    <asp:HiddenField ID="hdnTrendLabels" runat="server" />
    <asp:HiddenField ID="hdnTrendData" runat="server" />
    <asp:HiddenField ID="hdnTotalTarget" runat="server" />
    <asp:HiddenField ID="hdnTotalAchievement" runat="server" />
    <asp:HiddenField ID="hdnTotalBalance" runat="server" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {

            var navy = '#1E3A8A';
            var navyLight = '#C7D2EC';
            var green = '#16A34A';
            var gridColor = '#E5E7EB';
            var textColor = '#6B7280';

            function parseJsonField(fieldId) {
                var el = document.getElementById(fieldId);
                if (!el || !el.value) return [];
                try { return JSON.parse(el.value); } catch (e) { return []; }
            }

            var chartLabels = parseJsonField('<%= hdnChartLabels.ClientID %>');
            var targetData = parseJsonField('<%= hdnTargetData.ClientID %>');
            var achievementData = parseJsonField('<%= hdnAchievementData.ClientID %>');
            var branchLabels = parseJsonField('<%= hdnBranchLabels.ClientID %>');
            var branchAchievementData = parseJsonField('<%= hdnBranchAchievementData.ClientID %>');
            var trendLabels = parseJsonField('<%= hdnTrendLabels.ClientID %>');
            var trendData = parseJsonField('<%= hdnTrendData.ClientID %>');

            // Chart 1 — Target vs Achievement (vertical bar)
            var ctxTargetVsAchievement = document.getElementById('chartTargetVsAchievement');
            if (ctxTargetVsAchievement) {
                new Chart(ctxTargetVsAchievement, {
                    type: 'bar',
                    data: {
                        labels: chartLabels,
                        datasets: [
                            { label: 'Target', data: targetData, backgroundColor: navyLight, borderRadius: 4, maxBarThickness: 28 },
                            { label: 'Achievement', data: achievementData, backgroundColor: navy, borderRadius: 4, maxBarThickness: 28 }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            x: { grid: { display: false }, ticks: { color: textColor, font: { size: 11 } } },
                            y: { grid: { color: gridColor }, ticks: { color: textColor, font: { size: 11 } }, beginAtZero: true }
                        }
                    }
                });
            }

            // Chart 2 — Branch Performance (horizontal bar)
            // Chart 2 — Target Status (Doughnut)

          

            // --- YOUR EXISTING DATA BINDINGS (keep as-is) ---
            var totalTarget =
                parseFloat(document.getElementById('<%= hdnTotalTarget.ClientID %>').value || 0);

var achieved =
                parseFloat(document.getElementById('<%= hdnTotalAchievement.ClientID %>').value || 0);

            var balance = Math.max(0, totalTarget - achieved);

            var achievementPct =
                totalTarget > 0 ? ((achieved / totalTarget) * 100) : 0;

            var ctxTargetStatus =
                document.getElementById('chartTargetStatus');

            if (ctxTargetStatus) {

                const centerTextPlugin = {
                    id: 'centerText',
                    afterDraw(chart) {

                        const meta = chart.getDatasetMeta(0);

                        if (!meta.data.length) return;

                        const x = meta.data[0].x;
                        const y = meta.data[0].y;

                        const ctx = chart.ctx;

                        ctx.save();

                        ctx.textAlign = 'center';

                        ctx.fillStyle = '#111827';
                        ctx.font = '700 40px Segoe UI';
                        ctx.fillText(
                            Math.round(achievementPct) + '%',
                            x,
                            y - 6
                        );

                        ctx.fillStyle = '#6B7280';
                        ctx.font = '600 13px Segoe UI';
                        ctx.fillText(
                            'Achievement',
                            x,
                            y + 18
                        );

                        ctx.restore();
                    }
                };

                new Chart(ctxTargetStatus, {

                    type: 'doughnut',

                    data: {
                        //labels: ['Achieved', 'Remaining'],

                        datasets: [{
                            data: [achieved, balance],

                            backgroundColor: [
                                '#1E3A8A',   // Navy Blue
                                '#E5E7EB'    // Light Gray
                            ],

                            borderWidth: 0,
                            borderRadius: 12,
                            spacing: 2,
                            hoverOffset: 8
                        }]
                    },

                    plugins: [centerTextPlugin],

                    options: {

                        responsive: true,
                        maintainAspectRatio: false,

                        cutout: '78%',

                        animation: {
                            animateRotate: true,
                            duration: 1500
                        },

                        plugins: {

                            legend: {
                                position: 'bottom',

                                labels: {
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 20,
                                    boxWidth: 10,
                                    font: {
                                        size: 12,
                                        weight: '600'
                                    }
                                }
                            },

                            tooltip: {
                                backgroundColor: '#111827',
                                padding: 12,
                                cornerRadius: 8,

                                callbacks: {
                                    label: function (context) {

                                        return context.label +
                                            ': ₹' +
                                            Number(context.raw)
                                                .toLocaleString('en-IN');
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Chart 3 — Achievement Trend (line)
            var ctxAchievementTrend = document.getElementById('chartAchievementTrend');
            if (ctxAchievementTrend) {
                new Chart(ctxAchievementTrend, {
                    type: 'line',
                    data: {
                        labels: trendLabels,
                        datasets: [{
                            label: 'Achievement %',
                            data: trendData,
                            borderColor: navy,
                            backgroundColor: 'rgba(30, 58, 138, 0.08)',
                            fill: true,
                            tension: 0.35,
                            pointBackgroundColor: navy,
                            pointRadius: 3.5,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '78%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    padding: 20,
                                    font: {
                                        size: 12,
                                        weight: '600'
                                    }
                                }
                            },
                            tooltip: {
                                backgroundColor: '#111827',
                                padding: 12,
                                displayColors: true
                            }
                        }
                    }
                });
            }

        });
    </script>

</asp:Content>
