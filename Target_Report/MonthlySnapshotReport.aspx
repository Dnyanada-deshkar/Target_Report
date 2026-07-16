<%@ Page Title="Monthly Snapshot Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="MonthlySnapshotReport.aspx.cs" Inherits="Target_Report.MonthlySnapshotReport" %>
<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Monthly Snapshot Report · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">
    <link rel="stylesheet" href="MonthlySnapshotReport.css" />
</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

    <div class="module-page">
        <div class="module-container">

            <!-- =================================================
                 TOP HEADER
                 ================================================= -->
            <div class="module-header">
                <div class="module-heading-block">
                    <h1 class="module-title">Monthly Snapshot Report</h1>
                    <p class="module-subtitle">View finalized month-end performance snapshots.</p>
                </div>
                <nav class="module-breadcrumb" aria-label="Breadcrumb">
                    <span>Dashboard</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span>Reports</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span class="crumb-current">Monthly Snapshot Report</span>
                </nav>
            </div>

            <!-- =================================================
                 FILTER PANEL
                 ================================================= -->
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3Z"></path></svg>
                        <span>Filters</span>
                    </div>
                    <span class="panel-header-meta">Month and year are required</span>
                </div>
                <div class="panel-body">
                    <div class="form-grid">

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlMonth" CssClass="field-label">
                                Month<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="field-select">
                                    <asp:ListItem Text="Select month" Value="" />
                                    <asp:ListItem Text="January" Value="1" />
                                    <asp:ListItem Text="February" Value="2" />
                                    <asp:ListItem Text="March" Value="3" />
                                    <asp:ListItem Text="April" Value="4" />
                                    <asp:ListItem Text="May" Value="5" />
                                    <asp:ListItem Text="June" Value="6" />
                                    <asp:ListItem Text="July" Value="7" />
                                    <asp:ListItem Text="August" Value="8" />
                                    <asp:ListItem Text="September" Value="9" />
                                    <asp:ListItem Text="October" Value="10" />
                                    <asp:ListItem Text="November" Value="11" />
                                    <asp:ListItem Text="December" Value="12" />
                                </asp:DropDownList>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvMonth" runat="server"
                                ControlToValidate="ddlMonth"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please select a month."
                                InitialValue=""
                                ValidationGroup="ReportFilters" />
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlYear" CssClass="field-label">
                                Year<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="field-select" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvYear" runat="server"
                                ControlToValidate="ddlYear"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please select a year."
                                InitialValue=""
                                ValidationGroup="ReportFilters" />
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlBranch" CssClass="field-label">
                                Branch
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlBranch" runat="server" CssClass="field-select">
                                    <asp:ListItem Text="All Branches" Value="" />
                                    <asp:ListItem Text="Pune" Value="Pune" />
                                    <asp:ListItem Text="Nagpur" Value="Nagpur" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlPartner" CssClass="field-label">
                                Partner
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlPartner" runat="server" CssClass="field-select">
                                    <asp:ListItem Text="All Partners" Value="" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-actions">
                            <div class="form-actions-spacer"></div>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" ValidationGroup="ReportFilters" OnClick="btnSearch_Click" />
                        </div>

                    </div>
                </div>
            </section>

            <!-- =================================================
                 KPI SUMMARY CARDS
                 ================================================= -->
            <section class="panel" style="margin-top: 24px; border: none; box-shadow: none; background: transparent;">
                <div class="kpi-grid">

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="4.5"></circle><circle cx="12" cy="12" r="0.8" fill="currentColor"></circle></svg>
                            </div>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblTotalTarget" runat="server" Text="₹0.00" /></div>
                        <div class="kpi-label">Total Target</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-success">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            </div>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblTotalAchievement" runat="server" Text="₹0.00" /></div>
                        <div class="kpi-label">Total Achievement</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-danger">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            </div>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblTotalBalance" runat="server" Text="₹0.00" /></div>
                        <div class="kpi-label">Total Balance</div>
                    </div>

                    <div class="kpi-card">
                        <div class="kpi-card-top">
                            <div class="kpi-icon-wrap is-success">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path><path d="M22 12A10 10 0 0 0 12 2v10z"></path></svg>
                            </div>
                        </div>
                        <div class="kpi-value"><asp:Label ID="lblAchievementPercentage" runat="server" Text="0.00%" /></div>
                        <div class="kpi-label">Achievement %</div>
                    </div>

                </div>
            </section>

            <!-- =================================================
                 GRID SECTION
                 ================================================= -->
            <section class="panel">

                <div class="toolbar">
                    <div class="search-control">
                        <span class="toolbar-result-count">
                            <asp:Literal ID="litResultCount" runat="server" Text="0 records" />
                        </span>
                    </div>
                </div>

                <div class="table-scroll">
                    <asp:GridView
                                    ID="gvSnapshot"
                                    runat="server"
                                    CssClass="data-table"
                                    AutoGenerateColumns="false"
                                    GridLines="None"
                                    UseAccessibleHeader="true"
                                    ShowHeaderWhenEmpty="true"
                                    AllowSorting="true"
                                    OnSorting="gvSnapshot_Sorting"
                                    DataKeyNames="PartnerName">
                        <Columns>
                            <asp:TemplateField HeaderText="Partner Name" SortExpression="PartnerName">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Partner Name
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-name"><%# Eval("PartnerName") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Branch" SortExpression="NativeBranch">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Branch
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class='<%# "branch-tag" + (Eval("NativeBranch").ToString() == "Nagpur" ? " is-nagpur" : "") %>'>
                                        <span class="dot"></span>
                                        <%# Eval("NativeBranch") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Sales Target" SortExpression="SalesTarget">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Sales Target
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-secondary cell-numeric"><%# Eval("SalesTarget", "{0:N2}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Achievement" SortExpression="Achievement">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Achievement
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-secondary cell-numeric"><%# Eval("Achievement", "{0:N2}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Balance" SortExpression="Balance">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Balance
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-secondary cell-numeric"><%# Eval("Balance", "{0:N2}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Achievement %" SortExpression="AchievementPercentage">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Achievement %
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class='<%# "achievement-pct-tag " + GetAchievementPctClass(Convert.ToDecimal(Eval("AchievementPercentage"))) %>'><%# Eval("AchievementPercentage", "{0:N2}%") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Closed Date" SortExpression="ClosedDate">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Closed Date
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-secondary"><%# Eval("ClosedDate", "{0:dd-MMM-yyyy}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="table-empty-state">
                                <svg class="table-empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3Z"></path>
                                </svg>
                                <p class="table-empty-title">No snapshot data found.</p>
                                <p class="table-empty-text">Try a different month, year, or filter combination. Snapshots only exist for months that have been closed.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="table-footer">
                    <div class="page-size-control">
                        <span>Rows per page</span>
                        <div class="page-size-wrap">
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="page-size-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                                <asp:ListItem Text="10" Value="10" />
                                <asp:ListItem Text="25" Value="25" />
                                <asp:ListItem Text="50" Value="50" />
                                <asp:ListItem Text="100" Value="100" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="pagination">
                        <asp:LinkButton ID="lnkFirst" runat="server" CssClass="page-btn" OnClick="lnkFirst_Click" ToolTip="First page">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="11 17 6 12 11 7"></polyline><polyline points="18 17 13 12 18 7"></polyline></svg>
                        </asp:LinkButton>
                        <asp:LinkButton ID="lnkPrev" runat="server" CssClass="page-btn" OnClick="lnkPrev_Click" ToolTip="Previous page">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                        </asp:LinkButton>

                        <asp:Repeater ID="rptPageNumbers" runat="server" OnItemCommand="rptPageNumbers_ItemCommand">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkPageNumber" runat="server"
                                    CssClass='<%# "page-btn" + (Convert.ToInt32(Eval("PageNumber")) == Convert.ToInt32(Eval("CurrentPage")) ? " is-active" : "") %>'
                                    CommandName="GoToPage" CommandArgument='<%# Eval("PageNumber") %>'
                                    Text='<%# Eval("PageNumber") %>' />
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-btn" OnClick="lnkNext_Click" ToolTip="Next page">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </asp:LinkButton>
                        <asp:LinkButton ID="lnkLast" runat="server" CssClass="page-btn" OnClick="lnkLast_Click" ToolTip="Last page">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 17 18 12 13 7"></polyline><polyline points="6 17 11 12 6 7"></polyline></svg>
                        </asp:LinkButton>
                    </div>

                        <asp:LinkButton
    ID="btnExportBottom"
    runat="server"
    CssClass="btn-export-bottom"
    CausesValidation="false"
    OnClick="btnExport_Click">

    <svg width="18" height="18"
     viewBox="0 0 24 24"
     fill="none"
     stroke="currentColor"
     stroke-width="2"
     stroke-linecap="round"
     stroke-linejoin="round">

    <path d="M12 3v12"></path>
    <path d="M7 10l5 5 5-5"></path>
    <path d="M5 21h14"></path>

</svg>

<span>Export Excel</span>

</asp:LinkButton>

                </div>

            </section>

        </div>
    </div>

    <!-- =========================================================
         TOAST NOTIFICATION
         ========================================================= -->
    <asp:Panel ID="pnlToast" runat="server" CssClass="toast-stack" Visible="false">
        <div class="toast">
            <svg class="toast-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            <div class="toast-content">
                <p class="toast-title"><asp:Literal ID="litToastTitle" runat="server" /></p>
                <p class="toast-text"><asp:Literal ID="litToastText" runat="server" /></p>
            </div>
        </div>
    </asp:Panel>

    <script>
        (function () {
            var toast = document.querySelector('.toast-stack');
            if (toast) {
                window.setTimeout(function () {
                    toast.style.display = 'none';
                }, 3000);
            }
        })();
    </script>
</asp:Content>