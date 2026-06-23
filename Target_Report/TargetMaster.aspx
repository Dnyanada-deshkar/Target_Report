<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TargetMaster.aspx.cs" Inherits="Target_Report.TargetMaster" %>


<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Target Master · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">
    <link rel="stylesheet" href="TargetMaster.css" />
</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

    <div class="module-page">
        <div class="module-container">

            <!-- =================================================
                 TOP HEADER
                 ================================================= -->
            <div class="module-header">
                <div class="module-heading-block">
                    <h1 class="module-title">Target Master</h1>
                    <p class="module-subtitle">Manage monthly sales targets assigned to business partners.</p>
                </div>
                <nav class="module-breadcrumb" aria-label="Breadcrumb">
                    <span>Dashboard</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span>Masters</span>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                    <span class="crumb-current">Target Master</span>
                </nav>
            </div>

            <!-- =================================================
                 SECTION 1 — TARGET INFORMATION FORM
                 ================================================= -->
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-header-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="9"></circle>
                            <circle cx="12" cy="12" r="4.5"></circle>
                            <circle cx="12" cy="12" r="0.8" fill="currentColor"></circle>
                        </svg>
                        <span>Target Information</span>
                    </div>
                    <asp:Panel ID="pnlFormMode" runat="server" CssClass="form-mode-tag">
                        <span class="dot"></span>
                        <asp:Literal ID="litFormMode" runat="server" Text="New Target" />
                    </asp:Panel>
                </div>

                <div class="panel-body">
                    <div class="form-grid">

                        <!-- Hidden field carrying the TargetID being edited -->
                        <asp:HiddenField ID="hdnTargetId" runat="server" Value="0" />

                        <!-- Row 1: Partner | Partner Contact (auto-filled, read-only) -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlPartner" CssClass="field-label">
                                Partner Name<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-select-wrap">
                                <asp:DropDownList ID="ddlPartner" runat="server" CssClass="field-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPartner_SelectedIndexChanged">
                                    <asp:ListItem Text="Select partner" Value="" />
                                </asp:DropDownList>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPartner" runat="server"
                                ControlToValidate="ddlPartner"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please select a partner."
                                InitialValue=""
                                ValidationGroup="TargetForm" />
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtPartnerContact" CssClass="field-label">
                                Partner Contact
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtPartnerContact" runat="server" CssClass="field-input is-readonly" ReadOnly="true" TabIndex="-1" placeholder="Auto-filled from partner" />
                            </div>
                        </div>

                        <!-- Row 2: City (auto-filled) | Branch (auto-filled) -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtCity" CssClass="field-label">
                                City
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtCity" runat="server" CssClass="field-input is-readonly" ReadOnly="true" TabIndex="-1" placeholder="Auto-filled from partner" />
                            </div>
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtBranch" CssClass="field-label">
                                Branch
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtBranch" runat="server" CssClass="field-input is-readonly" ReadOnly="true" TabIndex="-1" placeholder="Auto-filled from partner" />
                            </div>
                        </div>

                        <!-- Row 3: Month + Year tag | Sales Target -->
                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="ddlMonth" CssClass="field-label">
                                Month<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="month-year-row">
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
                                <span class="year-tag">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    <asp:Literal ID="litTargetYear" runat="server" />
                                </span>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvMonth" runat="server"
                                ControlToValidate="ddlMonth"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please select a month."
                                InitialValue=""
                                ValidationGroup="TargetForm" />
                        </div>

                        <div class="field-group">
                            <asp:Label runat="server" AssociatedControlID="txtSalesTarget" CssClass="field-label">
                                Sales Target<span class="required-mark">*</span>
                            </asp:Label>
                            <div class="field-control-wrap">
                                <asp:TextBox ID="txtSalesTarget" runat="server" CssClass="field-input" placeholder="e.g. 500000" MaxLength="15" />
                            </div>
                            <asp:RequiredFieldValidator ID="rfvSalesTarget" runat="server"
                                ControlToValidate="txtSalesTarget"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Please enter sales target."
                                ValidationGroup="TargetForm" />
                            <asp:RegularExpressionValidator ID="revSalesTarget" runat="server"
                                ControlToValidate="txtSalesTarget"
                                CssClass="field-error" Display="Dynamic"
                                ErrorMessage="Sales target must be a positive number."
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ValidationGroup="TargetForm" />
                        </div>

                        <!-- Row 4: Remarks (optional, full width) -->
                        <div class="field-group" style="grid-column: 1 / -1;">
                            <asp:Label runat="server" AssociatedControlID="txtRemarks" CssClass="field-label">
                                Remarks<span class="optional-tag">(optional)</span>
                            </asp:Label>
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="field-textarea" TextMode="MultiLine" Rows="3" MaxLength="500" placeholder="Any additional notes about this target" />
                        </div>

                        <!-- Server-side business rule message (duplicate target, past month, etc.) -->
                        <asp:Panel ID="pnlFormMessage" runat="server" CssClass="field-error" Style="grid-column: 1 / -1; margin-top: -6px;" Visible="false">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <asp:Literal ID="litFormMessage" runat="server" />
                        </asp:Panel>

                        <!-- Row 5: Buttons -->
                        <div class="form-actions">
                            <div class="form-actions-spacer"></div>
                            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-muted" CausesValidation="false" OnClick="btnClear_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline" CausesValidation="false" OnClick="btnCancel_Click" Visible="false" />
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" ValidationGroup="TargetForm" OnClick="btnSave_Click" />
                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-success" ValidationGroup="TargetForm" OnClick="btnUpdate_Click" Visible="false" />
                        </div>

                    </div>
                </div>
            </section>

            <!-- =================================================
                 SECTION 2 — TARGET RECORDS GRID
                 ================================================= -->
            <section class="panel">

                <!-- Search / filter toolbar -->
                <div class="toolbar">
                    <div class="search-control">
                        <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="7"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search by partner name" AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                    </div>
                    <div class="toolbar-filters">
                        <div class="filter-select-wrap">
                            <asp:DropDownList ID="ddlBranchFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBranchFilter_SelectedIndexChanged">
                                <asp:ListItem Text="All Branches" Value="" />
                                <asp:ListItem Text="Pune" Value="Pune" />
                                <asp:ListItem Text="Nagpur" Value="Nagpur" />
                            </asp:DropDownList>
                        </div>
                        <div class="filter-select-wrap">
                            <asp:DropDownList ID="ddlMonthFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlMonthFilter_SelectedIndexChanged">
                                <asp:ListItem Text="All Months" Value="" />
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
                        <span class="toolbar-result-count">
                            <asp:Literal ID="litResultCount" runat="server" Text="0 targets" />
                        </span>
                    </div>
                </div>

                <!-- Data grid -->
                <div class="table-scroll">
                    <asp:GridView ID="gvTargets" runat="server"
                        CssClass="data-table"
                        AutoGenerateColumns="false"
                        GridLines="None"
                        ShowHeaderWhenEmpty="false"
                        AllowSorting="true"
                        OnSorting="gvTargets_Sorting"
                        OnRowCommand="gvTargets_RowCommand"
                        DataKeyNames="TargetID">
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

                            <asp:TemplateField HeaderText="Branch">
                                <ItemTemplate>
                                    <span class='<%# "branch-tag" + (Eval("Branch").ToString() == "Nagpur" ? " is-nagpur" : "") %>'>
                                        <span class="dot"></span>
                                        <%# Eval("Branch") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Month" SortExpression="TargetMonth">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Month
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-month">
                                        <%# GetMonthName(Convert.ToInt32(Eval("TargetMonth"))) %>
                                        <span class="cell-month-year"><%# Eval("TargetYear") %></span>
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
                                    <span class="cell-secondary"><%# Eval("SalesTarget", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Achievement">
                                <ItemTemplate>
                                    <span class="cell-secondary"><%# Eval("Achievement", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Balance">
                                <ItemTemplate>
                                    <span class="cell-secondary"><%# Eval("Balance", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Achievement %">
                                <ItemTemplate>
                                    <div class="achievement-bar-wrap">
                                        <div class="achievement-bar-track">
<div class="achievement-bar-fill is-pending"
     style='<%# "width:" + Math.Min(100, Convert.ToDouble(Eval("AchievementPercentage"))) + "%;" %>'>
</div>                                        </div>
                                        <span class="achievement-bar-text"><%# Eval("AchievementPercentage", "{0:N0}%") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Created Date" SortExpression="CreatedDate">
                                <HeaderTemplate>
                                    <span class="th-sort-wrap">Created Date
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                    </span>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <span class="cell-secondary"><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="cell-actions">
                                        <asp:LinkButton ID="lnkEdit" runat="server" CssClass="icon-btn icon-btn-edit"
                                            CommandName="EditTarget" CommandArgument='<%# Eval("TargetID") %>'
                                            ToolTip="Edit target">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                <path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5Z"></path>
                                            </svg>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkDelete" runat="server" CssClass="icon-btn icon-btn-delete"
                                            CommandName="DeleteTarget" CommandArgument='<%# Eval("TargetID") %>'
                                            ToolTip="Delete target">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
                                                <path d="M10 11v6"></path>
                                                <path d="M14 11v6"></path>
                                                <path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"></path>
                                            </svg>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="table-empty-state">
                                <svg class="table-empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="9"></circle>
                                    <circle cx="12" cy="12" r="4.5"></circle>
                                    <circle cx="12" cy="12" r="0.8" fill="currentColor"></circle>
                                </svg>
                                <p class="table-empty-title">No targets found.</p>
                                <p class="table-empty-text">Try adjusting your search or filters, or create a new target using the form above.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <!-- Pagination footer -->
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
                </div>

            </section>

        </div>
    </div>

    <!-- =========================================================
         DELETE CONFIRMATION MODAL
         ========================================================= -->
    <asp:Panel ID="pnlDeleteModalOverlay" runat="server" CssClass="modal-overlay is-hidden">
        <div class="modal-card">
            <div class="modal-icon-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
            </div>
            <h3 class="modal-title">Delete this target?</h3>
            <p class="modal-text">
                You are about to delete the target for <strong><asp:Literal ID="litDeleteTargetLabel" runat="server" /></strong>.
                This will remove it from all reports. This action cannot be undone from this screen.
            </p>
            <div class="modal-actions">
                <asp:Button ID="btnCancelDelete" runat="server" Text="Cancel" CssClass="btn btn-outline" CausesValidation="false" OnClick="btnCancelDelete_Click" />
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete Target" CssClass="btn btn-danger-outline" CausesValidation="false" OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </asp:Panel>

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

</asp:Content>