<%@ Page Title="Daily Sales Entry" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DailySalesEntry.aspx.cs" Inherits="Target_Report.DailySalesEntry" %>

<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Daily Sales Entry · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">
    <link rel="stylesheet" href="/DailySalesEntry.css" />
    <link rel="stylesheet" href="/Dashboard.css" />
</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

    <div class="module-page">
        <div class="module-container">

            <!-- =====================================================
                 TOP HEADER
                 ===================================================== -->
            <div class="module-header">
                <div class="module-heading-block">
                    <h1 class="module-title">Daily Sales Entry</h1>
                    <p class="module-subtitle">Record daily sales and automatically update target balance.</p>
                </div>
                <nav class="module-breadcrumb" aria-label="Breadcrumb">
                    <span>Dashboard</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span>Sales</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span class="crumb-current">Daily Sales Entry</span>
                </nav>
            </div>

            <!-- =====================================================
                 TOAST NOTIFICATION
                 ===================================================== -->
            <asp:Panel ID="pnlToast" runat="server" CssClass="toast-stack" Visible="false">
                <div class="toast">
                    <svg class="toast-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    <div class="toast-content">
                        <p class="toast-title"><asp:Literal ID="litToastTitle" runat="server" /></p>
                        <p class="toast-text"><asp:Literal ID="litToastText" runat="server" /></p>
                    </div>
                </div>
            </asp:Panel>

            <!-- =====================================================
                 SECTION 1 — FILTER PANEL
                 ===================================================== -->
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                        </svg>
                        <span>Select Partner &amp; Period</span>
                    </div>
                </div>

                <div class="panel-body">
                    <div class="form-grid">

                        <!-- Partner -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlPartner" CssClass="field-label">
                                Partner<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlPartner" runat="server" CssClass="field-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlPartner_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Month -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlMonth" CssClass="field-label">
                                Month<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="field-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged">
                                    <asp:ListItem Value="1">January</asp:ListItem>
                                    <asp:ListItem Value="2">February</asp:ListItem>
                                    <asp:ListItem Value="3">March</asp:ListItem>
                                    <asp:ListItem Value="4">April</asp:ListItem>
                                    <asp:ListItem Value="5">May</asp:ListItem>
                                    <asp:ListItem Value="6">June</asp:ListItem>
                                    <asp:ListItem Value="7">July</asp:ListItem>
                                    <asp:ListItem Value="8">August</asp:ListItem>
                                    <asp:ListItem Value="9">September</asp:ListItem>
                                    <asp:ListItem Value="10">October</asp:ListItem>
                                    <asp:ListItem Value="11">November</asp:ListItem>
                                    <asp:ListItem Value="12">December</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Year -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlYear" CssClass="field-label">
                                Year<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="field-select"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                        </div>

                    </div>
                </div>
            </section>

            <!-- =====================================================
                 SECTION 2 — KPI SUMMARY (visible only when target loads)
                 ===================================================== -->
            <asp:Panel ID="pnlKpiSection" runat="server" Visible="false">

                <div class="kpi-grid">

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="4.5"></circle><circle cx="12" cy="12" r="0.8" fill="currentColor"></circle></svg>
                            </div>
                            <span class="kpi-trend is-neutral">Fixed</span>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblKpiTarget" runat="server" Text="—" /></div>
                        <div class="kpi-label">Sales Target</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-danger">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            </div>
                            <span class="kpi-trend is-down">Pending</span>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblKpiBalance" runat="server" Text="—" /></div>
                        <div class="kpi-label">Target Balance</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-success">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            </div>
                            <span class="kpi-trend is-up"><asp:Literal ID="litAchievePct" runat="server" Text="0%" /></span>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblKpiAchievement" runat="server" Text="—" /></div>
                        <div class="kpi-label">Achievement</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-success">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path><path d="M22 12A10 10 0 0 0 12 2v10z"></path></svg>
                            </div>
                            <span class="kpi-trend is-up">This month</span>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblKpiAchievePct" runat="server" Text="0%" /></div>
                        <div class="kpi-label">Achievement %</div>
                    </div>

                </div>

                <!-- Achievement progress bar -->
                <section class="panel" style="margin-bottom: 24px;">
                    <div class="panel-body" style="padding: 16px 24px;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                            <span style="font-size:13px; font-weight:600; color:#374151;">Achievement Progress</span>
                            <span style="font-size:13px; font-weight:700; color:#1E3A8A;">
                                <asp:Literal ID="litProgressPct" runat="server" Text="0%" />
                            </span>
                        </div>
                        <div class="dse-progress-track">
                            <div class="dse-progress-fill" id="progressFill" style="width:0%"></div>
                        </div>
                    </div>
                </section>

            </asp:Panel>

            <!-- =====================================================
                 SECTION 3 — NO TARGET BANNER
                 ===================================================== -->
            <asp:Panel ID="pnlNoTarget" runat="server" Visible="false">
                <section class="panel dse-alert-panel is-warning">
                    <div class="panel-body dse-alert-body">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                        <div>
                            <strong>No Target Found</strong>
                            <p>No target has been set for the selected partner, month, and year. Please create a target from the <a href="TargetMaster.aspx">Target Master</a> page first.</p>
                        </div>
                    </div>
                </section>
            </asp:Panel>

            <!-- =====================================================
                 SECTION 4 — TARGET ACHIEVED BANNER
                 ===================================================== -->
            <asp:Panel ID="pnlAlreadyAchieved" runat="server" Visible="false">
                <section class="panel dse-alert-panel is-success">
                    <div class="panel-body dse-alert-body">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <div>
                            <strong>Target Already Achieved</strong>
                            <p>The full sales target for this period has been achieved. The balance is zero and no further entries are required.</p>
                        </div>
                    </div>
                </section>
            </asp:Panel>

            <!-- =====================================================
                 SECTION 5 — ENTRY FORM
                 ===================================================== -->
            <asp:Panel ID="pnlEntryForm" runat="server" Visible="false">
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 20V10"></path><path d="M18 20V4"></path><path d="M6 20v-4"></path>
                        </svg>
                        <span>Enter Daily Sale</span>
                    </div>
                    <asp:Panel ID="pnlFormMode" runat="server" CssClass="form-mode-tag">
                        <span class="dot"></span>
                        <asp:Literal ID="litFormMode" runat="server" Text="New Entry" />
                    </asp:Panel>
                </div>

                <div class="panel-body">
                    <div class="form-grid">

                        <!-- Hidden fields -->
                        <asp:HiddenField ID="hdnTargetId" runat="server" Value="0" />
                        <asp:HiddenField ID="hdnCurrentBalance" runat="server" Value="0" />

                        <!-- Sales Target (read-only) -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtSalesTarget" CssClass="field-label">
                                Sales Target
                                <span class="dse-badge">Fixed — Never Changes</span>
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtSalesTarget" runat="server"
                                    CssClass="field-input dse-readonly" ReadOnly="true" />
                            </div>
                        </div>

                        <!-- Current Balance (read-only) -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtCurrentBalance" CssClass="field-label">
                                Current Target Balance
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtCurrentBalance" runat="server"
                                    CssClass="field-input dse-readonly" ReadOnly="true" />
                            </div>
                        </div>

                        <!-- Daily Sale Input -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtDailySale" CssClass="field-label">
                                Today's Sale Amount<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtDailySale" runat="server"
                                    CssClass="field-input dse-sale-input"
                                    placeholder="e.g. 25000"
                                    MaxLength="12"
                                    autocomplete="off"
                                    onkeyup="dseCalcLive(this.value)" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvDailySale" runat="server"
                                ControlToValidate="txtDailySale"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please enter the sale amount."
                                ValidationGroup="SaleGroup" />
                            <asp:RegularExpressionValidator ID="revDailySale" runat="server"
                                ControlToValidate="txtDailySale"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please enter a valid numeric amount (e.g. 25000)."
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ValidationGroup="SaleGroup" />
                            <asp:CustomValidator ID="cvDailySale" runat="server"
                                ControlToValidate="txtDailySale"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Sale amount must be greater than zero."
                                OnServerValidate="cvDailySale_ServerValidate"
                                ValidationGroup="SaleGroup" />
                        </div>

                        <!-- Balance After Sale (live preview) -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtNewBalance" CssClass="field-label">
                                Balance After Sale
                                <span class="dse-badge dse-badge-live">Live Preview</span>
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtNewBalance" runat="server"
                                    CssClass="field-input dse-readonly" ReadOnly="true"
                                    placeholder="Auto-calculated" />
                            </div>
                        </div>

                        <!-- Server-side business rule message -->
                        <asp:Panel ID="pnlFormMessage" runat="server" CssClass="field-error" Visible="false"
                            Style="grid-column: 1 / -1; margin-top: -6px; display:flex; align-items:center; gap:6px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px;height:16px;flex-shrink:0;">
                                <circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            <asp:Literal ID="litFormMessage" runat="server" />
                        </asp:Panel>

                        <!-- Action buttons -->
                        <div class="form-actions">
                            <div class="form-actions-spacer"></div>
                            <asp:Button ID="btnClear" runat="server" Text="Clear"
                                CssClass="btn btn-muted" CausesValidation="false" OnClick="btnClear_Click" />
                            <asp:Button ID="btnSave" runat="server" Text="Save Daily Sale"
                                CssClass="btn btn-primary" ValidationGroup="SaleGroup"
                                OnClick="btnSave_Click" OnClientClick="return dseConfirmSave();" />
                        </div>

                    </div>
                </div>
            </section>
            </asp:Panel>

        </div>
    </div>

    <!-- =====================================================
         JAVASCRIPT
         ===================================================== -->
    <script>

        // Live balance calculation as user types
        function dseCalcLive(val) {
            var newBalField = document.getElementById('<%= txtNewBalance.ClientID %>');
            var currentBal  = parseFloat(document.getElementById('<%= hdnCurrentBalance.ClientID %>').value) || 0;
            var sale        = parseFloat(val);

            if (!val || isNaN(sale) || sale <= 0) {
                newBalField.value = '';
                return;
            }

            var newBal = currentBal - sale;
            if (newBal < 0) newBal = 0;

            newBalField.value = dseFormatINR(newBal);
        }

        // Indian numbering format: 500000 -> 5,00,000
        function dseFormatINR(num) {
            num = Math.round(Math.abs(num));
            var s = num.toString();
            if (s.length <= 3) return s;
            var last3 = s.substring(s.length - 3);
            var rest  = s.substring(0, s.length - 3);
            return rest.replace(/\B(?=(\d{2})+(?!\d))/g, ',') + ',' + last3;
        }

        // Confirm before posting
        function dseConfirmSave() {
            var saleEl = document.getElementById('<%= txtDailySale.ClientID %>');
            var sale   = parseFloat(saleEl.value);
            if (!saleEl.value || isNaN(sale) || sale <= 0) return true;
            return confirm('Confirm saving a daily sale of \u20B9' + dseFormatINR(sale) + '?');
        }

        // Progress bar width — must run after DOM is ready
        window.addEventListener('DOMContentLoaded', function () {
            var pctEl = document.getElementById('<%= litProgressPct.ClientID %>');
            var fill  = document.getElementById('progressFill');
            if (pctEl && fill) {
                var pct = parseFloat(pctEl.innerText || pctEl.textContent) || 0;
                fill.style.width = Math.min(pct, 100) + '%';
            }
        });

        // Auto-dismiss toast — identical pattern to PartnerMaster
        window.onload = function () {
            var toast = document.querySelector('.toast');
            if (toast) {
                setTimeout(function () {
                    toast.classList.add('toast-hide');
                    setTimeout(function () {
                        var stack = document.querySelector('.toast-stack');
                        if (stack) stack.style.display = 'none';
                    }, 500);
                }, 5000);
            }
        };

    </script>

</asp:Content>
