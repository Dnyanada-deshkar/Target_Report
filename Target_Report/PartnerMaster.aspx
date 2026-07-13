<%@ Page Title="Partner Master" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="PartnerMaster.aspx.cs" Inherits="Target_Report.PartnerMaster" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="cphHead" runat="server">
    <link rel="stylesheet" href="PartnerMaster.css" />
</asp:Content>

<asp:Content ID="ContentBody" ContentPlaceHolderID="cphBody" runat="server">

        <div class="module-page">
            <div class="module-container">

                <!-- =====================================================
                     TOP HEADER
                     ===================================================== -->
                <div class="module-header">
                    <div class="module-heading-block">
                        <h1 class="module-title">Partner Master</h1>
                        <p class="module-subtitle">Manage business partners associated with the organization.</p>
                    </div>
                    <nav class="module-breadcrumb" aria-label="Breadcrumb">
                        <span>Dashboard</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                        <span>Masters</span>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18l6-6-6-6"></path></svg>
                        <span class="crumb-current">Partner Master</span>
                    </nav>
                </div>

                <!-- =====================================================
                     SECTION 1 — PARTNER INFORMATION FORM
                     ===================================================== -->
                <section class="panel">
                    <div class="panel-header">
                        <div class="panel-header-title">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <span>Partner Information</span>
                        </div>
                        <asp:Panel ID="pnlFormMode" runat="server" CssClass="form-mode-tag">
                            <span class="dot"></span>
                            <asp:Literal ID="litFormMode" runat="server" Text="New Partner" />
                        </asp:Panel>
                    </div>

                    <div class="panel-body">
                        <div class="form-grid">

                            <!-- Hidden field carrying the PartnerID being edited -->
                            <asp:HiddenField ID="hdnPartnerId" runat="server" Value="0" />

                            <!-- Row 1: Partner Name | Contact Number -->
                            <div class="field-group">
                                <asp:Label runat="server" AssociatedControlID="txtPartnerName" CssClass="field-label">
                                    Partner Name<span class="required-mark">*</span>
                                </asp:Label>
                                <div class="field-control-wrap">
                                    <asp:TextBox ID="txtPartnerName" runat="server" CssClass="field-input" placeholder="e.g. Shree Enterprises" autocomplete="off" MaxLength="100" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPartnerName" runat="server"
                                    ControlToValidate="txtPartnerName"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please enter partner name."
                                    ValidationGroup="PartnerForm" />
                            </div>

                            <div class="field-group">
                                <asp:Label runat="server" AssociatedControlID="txtContactNumber" CssClass="field-label" >
                                    Contact Number<span class="required-mark">*</span>
                                </asp:Label>
                                <div class="field-control-wrap">
                                    <asp:TextBox ID="txtContactNumber" runat="server" CssClass="field-input" placeholder="10-digit mobile number" autocomplete="off" MaxLength="10" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvContactNumber" runat="server"
                                    ControlToValidate="txtContactNumber"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please enter contact number."
                                    ValidationGroup="PartnerForm" />
                                <asp:RegularExpressionValidator ID="revContactNumber" runat="server"
                                    ControlToValidate="txtContactNumber"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please enter a valid 10-digit contact number."
                                    ValidationExpression="^\d{10}$"
                                    ValidationGroup="PartnerForm" />
                            </div>

                            <!-- Row 2: City | Native Branch -->
                            <div class="field-group">
                                <asp:Label runat="server" AssociatedControlID="txtCity" CssClass="field-label">
                                    City<span class="required-mark">*</span>
                                </asp:Label>
                                <div class="field-control-wrap">
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="field-input" placeholder="e.g. Pune" autocomplete="off" MaxLength="50" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                                    ControlToValidate="txtCity"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please enter city."
                                    ValidationGroup="PartnerForm" />
                            </div>

                            <div class="field-group">
                                <asp:Label runat="server" AssociatedControlID="ddlNativeBranch" CssClass="field-label">
                                    Native Branch<span class="required-mark">*</span>
                                </asp:Label>
                                <div class="field-select-wrap">
                                    <asp:DropDownList ID="ddlNativeBranch" runat="server" CssClass="field-select">
                                        <asp:ListItem Text="Select branch" Value="" />
                                        <asp:ListItem Text="Pune" Value="Pune" />
                                        <asp:ListItem Text="Nagpur" Value="Nagpur" />
                                    </asp:DropDownList>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvNativeBranch" runat="server"
                                    ControlToValidate="ddlNativeBranch"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please select native branch."
                                    InitialValue=""
                                    ValidationGroup="PartnerForm" />
                            </div>

                            <div class="field-group brand-group">

                                <asp:Label
                                    runat="server"
                                    CssClass="field-label">

                                    Brands
                                    <span class="required-mark">*</span>

                                </asp:Label>

                                <asp:CheckBoxList
                                    ID="cblBrands"
                                    runat="server"
                                    CssClass="brand-checkbox-list"
                                    RepeatColumns="2"
                                    RepeatDirection="Horizontal">
                                </asp:CheckBoxList>

                            </div>

                            <!-- Server-side duplicate / business-rule message -->
                            <asp:Panel ID="pnlFormMessage" runat="server" CssClass="field-error" Style="grid-column: 1 / -1; margin-top: -6px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <asp:Literal ID="litFormMessage" runat="server" />
                            </asp:Panel>

                            <!-- Row 3: Buttons -->
                            <div class="form-actions">
                                <div class="form-actions-spacer"></div>
                                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-muted" CausesValidation="false" OnClick="btnClear_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline" CausesValidation="false" OnClick="btnCancel_Click" Visible="false" />
                                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" ValidationGroup="PartnerForm" OnClick="btnSave_Click" />
                                <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-success" ValidationGroup="PartnerForm" OnClick="btnUpdate_Click" Visible="false" />
                            </div>

                        </div>
                    </div>
                </section>

                <!-- =====================================================
                     SECTION 2 — PARTNER LISTING GRID
                     ===================================================== -->
                <section class="panel">

                    <!-- Search / filter toolbar -->
                    <div class="toolbar">
                        <div class="search-control">
                            <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="7"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search partners, contacts, or cities" AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" autocomplete="off" />
                        </div>
                        <div class="toolbar-filters">
                            <div class="filter-select-wrap">
                                <asp:DropDownList ID="ddlBranchFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBranchFilter_SelectedIndexChanged">
                                    <asp:ListItem Text="All Branches" Value="" />
                                    <asp:ListItem Text="Pune" Value="Pune" />
                                    <asp:ListItem Text="Nagpur" Value="Nagpur" />
                                </asp:DropDownList>
                            </div>
                            <span class="toolbar-result-count">
                                <asp:Literal ID="litResultCount" runat="server" Text="0 partners" />
                            </span>
                        </div>
                    </div>   

                    <!-- Data grid -->
                    <div class="table-scroll">
                        <asp:GridView ID="gvPartners" runat="server"
                            CssClass="data-table"
                            AutoGenerateColumns="false"
                            GridLines="None"
                            ShowHeaderWhenEmpty="false"
                            AllowSorting="false"
                            OnSorting="gvPartners_Sorting"
                            OnRowCommand="gvPartners_RowCommand"
                            DataKeyNames="PartnerID">
                            <Columns>
                                <asp:TemplateField HeaderText="Partner ID" SortExpression="PartnerID">
                                    <HeaderTemplate>
                                        <span class="th-sort-wrap">Partner ID
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M7 10l5 5 5-5"></path></svg>
                                        </span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <span class="cell-id"><%# Eval("PartnerID", "PTR-{0:0000}") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

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

                                <asp:TemplateField HeaderText="Contact Number" SortExpression="ContactNumber">
                                    <ItemTemplate>
                                        <span class="cell-secondary"><%# Eval("ContactNumber") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="City" SortExpression="City">
                                    <ItemTemplate>
                                        <span class="cell-secondary"><%# Eval("City") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Native Branch" SortExpression="NativeBranch">
                                    <ItemTemplate>
                                        <span class='<%# "branch-tag" + (Eval("NativeBranch").ToString() == "Nagpur" ? " is-nagpur" : "") %>'>
                                            <span class="dot"></span>
                                            <%# Eval("NativeBranch") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Brands">
                                        <ItemTemplate>
                                            <span class="cell-brands"
                                                  title='<%# Eval("Brands") %>'>

                                                <%# string.IsNullOrWhiteSpace(Eval("Brands").ToString())
                                                        ? "-"
                                                        : Eval("Brands") %>

                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                <asp:TemplateField HeaderText="Created Date" SortExpression="CreatedDate">
                                    <ItemTemplate>
                                        <span class="cell-secondary"><%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="cell-actions">
                                            <asp:LinkButton ID="lnkEdit" runat="server" CssClass="icon-btn icon-btn-edit"
                                                CommandName="EditPartner" CommandArgument='<%# Eval("PartnerID") %>'
                                                ToolTip="Edit partner">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                    <path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5Z"></path>
                                                </svg>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkDelete" runat="server" CssClass="icon-btn icon-btn-delete"
                                                CommandName="DeletePartner" CommandArgument='<%# Eval("PartnerID") %>'
                                                ToolTip="Delete partner"
                                                OnClientClick='<%# "return confirmDelete(\u0027" + Eval("PartnerID") + "\u0027, \u0027" + Eval("PartnerName") + "\u0027);" %>'>
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
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    <p class="table-empty-title">No partners found.</p>
                                    <p class="table-empty-text">Try adjusting your search or filters, or add a new partner using the form above.</p>
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
                <h3 class="modal-title">Delete this partner?</h3>
                <p class="modal-text">
                    You are about to delete <strong><asp:Literal ID="litDeletePartnerName" runat="server" /></strong>.
                    This action cannot be undone, and any dependent target or sales records referencing this partner may be affected.
                </p>
                <div class="modal-actions">
                    <asp:Button ID="btnCancelDelete" runat="server" Text="Cancel" CssClass="btn btn-outline" CausesValidation="false" OnClick="btnCancelDelete_Click" />
                    <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete Partner" CssClass="btn btn-danger-outline" CausesValidation="false" OnClick="btnConfirmDelete_Click" />
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


    <script>
        var pendingDeleteId = null;

        function confirmDelete(partnerId, partnerName) {
            // The actual delete modal is server-rendered (asp:Panel),
            // so this client hook just stops the default postback —
            // the LinkButton's CommandArgument carries the ID server-side
            // and the code-behind opens the modal via pnlDeleteModalOverlay.
            return true;
        }

        window.onload = function () {

            var toast =
                document.querySelector('.toast');

            if (toast) {

                setTimeout(function () {

                    toast.classList.add('toast-hide');

                    setTimeout(function () {

                        var toastStack =
                            document.querySelector('.toast-stack');

                        if (toastStack) {
                            toastStack.style.display = 'none';
                        }

                    }, 500);

                }, 3000);

            }

        };

    </script>
</asp:Content>
