<%@ Page Title="Sales Executive Master"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="SalesExecutiveMaster.aspx.cs"
    Inherits="Target_Report.SalesExecutiveMaster" %>

<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Sales Executive Master · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">

    <link rel="stylesheet" href="/SalesExecutiveMaster.css" />

</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

<div class="module-page">
<div class="module-container">

    <!-- =====================================================
         PAGE HEADER
    ====================================================== -->

    <div class="module-header">

        <div class="module-heading-block">

            <h1 class="module-title">
                Sales Executive Master
            </h1>

            <p class="module-subtitle">
                Manage sales executives responsible for partner sales activities.
            </p>

        </div>

        <nav class="module-breadcrumb">

            <span>Dashboard</span>

            <svg viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round">

                <path d="M9 18l6-6-6-6"></path>

            </svg>

            <span>Masters</span>

            <svg viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round">

                <path d="M9 18l6-6-6-6"></path>

            </svg>

            <span class="crumb-current">
                Sales Executive Master
            </span>

        </nav>

    </div>

    <!-- =====================================================
         TOAST
    ====================================================== -->

    <asp:Panel ID="pnlToast"
        runat="server"
        CssClass="toast-stack"
        Visible="false">

        <div class="toast">

            <svg class="toast-icon"
                style="width:18px;height:18px;flex-shrink:0;margin-top:2px;"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#16A34A"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round">

                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>

            </svg>

            <div class="toast-content">

                <p class="toast-title">
                    <asp:Literal ID="litToastTitle" runat="server" />
                </p>

                <p class="toast-text">
                    <asp:Literal ID="litToastText" runat="server" />
                </p>

            </div>

        </div>

    </asp:Panel>

    <!-- =====================================================
         EXECUTIVE FORM
    ====================================================== -->

    <section class="panel">

        <div class="panel-header">

            <div class="panel-header-title">

                <svg viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="1.8"
                    stroke-linecap="round"
                    stroke-linejoin="round">

                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>

                </svg>

                <span>
                    Sales Executive Information
                </span>

            </div>

            <asp:Panel ID="pnlFormMode"
                runat="server"
                CssClass="form-mode-tag">

                <span class="dot"></span>

                <asp:Literal ID="litFormMode"
                    runat="server"
                    Text="New Executive" />

            </asp:Panel>

        </div>

        <div class="panel-body">

            <div class="form-grid">

                <asp:HiddenField
                    ID="hdnExecutiveID"
                    runat="server"
                    Value="0" />

                                <!-- Executive Name -->
                <div class="field-group">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtExecutiveName"
                        CssClass="field-label">

                        Executive Name
                        <span class="required-mark">*</span>

                    </asp:Label>

                    <asp:TextBox
                        ID="txtExecutiveName"
                        runat="server"
                        CssClass="field-input"
                        MaxLength="200"
                        placeholder="Enter Executive Name" />

                    <asp:RequiredFieldValidator
                        ID="rfvExecutiveName"
                        runat="server"
                        ControlToValidate="txtExecutiveName"
                        ValidationGroup="ExecutiveGroup"
                        CssClass="field-error"
                        ErrorMessage="Executive Name is required." />

                </div>


                <!-- Contact Number -->
                <div class="field-group">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtContactNumber"
                        CssClass="field-label">

                        Contact Number
                        <span class="required-mark">*</span>

                    </asp:Label>

                    <asp:TextBox
                        ID="txtContactNumber"
                        runat="server"
                        CssClass="field-input"
                        MaxLength="10"
                        placeholder="Enter Contact Number" />

                    <asp:RequiredFieldValidator
                        ID="rfvContactNumber"
                        runat="server"
                        ControlToValidate="txtContactNumber"
                        ValidationGroup="ExecutiveGroup"
                        CssClass="field-error"
                        ErrorMessage="Contact Number is required." />

                    <asp:RegularExpressionValidator
                        ID="revContactNumber"
                        runat="server"
                        ControlToValidate="txtContactNumber"
                        ValidationGroup="ExecutiveGroup"
                        CssClass="field-error"
                        ValidationExpression="^[0-9]{10}$"
                        ErrorMessage="Enter a valid 10 digit mobile number." />

                </div>


                <!-- Native Branch -->
                <div class="field-group">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlBranch"
                        CssClass="field-label">

                        Native Branch
                        <span class="required-mark">*</span>

                    </asp:Label>

                    <asp:DropDownList
                        ID="ddlBranch"
                        runat="server"
                        CssClass="field-select">

                    </asp:DropDownList>

                    <asp:RequiredFieldValidator
                        ID="rfvBranch"
                        runat="server"
                        InitialValue="0"
                        ControlToValidate="ddlBranch"
                        ValidationGroup="ExecutiveGroup"
                        CssClass="field-error"
                        ErrorMessage="Please select a branch." />

                </div>


                <!-- Empty Column -->
                <div class="field-group"></div>


                <!-- Action Buttons -->
                <div class="form-actions">

                    <div class="form-actions-spacer"></div>

                    <asp:Button
                        ID="btnClear"
                        runat="server"
                        Text="Clear"
                        CssClass="btn btn-muted"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <asp:Button
                        ID="btnSave"
                        runat="server"
                        Text="Save Executive"
                        CssClass="btn btn-primary"
                        ValidationGroup="ExecutiveGroup"
                        OnClick="btnSave_Click" />

                </div>

            </div>

        </div>

    </section>


    

                        <!-- ===========================================
                 SALES EXECUTIVE LIST
            ============================================ -->

            <section class="panel">

                <div class="panel-header">

                    <div class="panel-header-title">
                        <span>Sales Executive List</span>
                    </div>

                </div>

                <div class="panel-body">

                    <!-- Toolbar -->

                    <div class="table-toolbar">

                        <div class="table-search">

                            <asp:TextBox
                                ID="txtSearch"
                                runat="server"
                                CssClass="field-input"
                                AutoPostBack="true"
                                OnTextChanged="txtSearch_TextChanged"
                                placeholder="Search Executive..." />

                        </div>

                        <div class="table-right">

                            Show

                            <asp:DropDownList
                                ID="ddlPageSize"
                                runat="server"
                                CssClass="field-select"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">

                                <asp:ListItem Selected="True">10</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>

                            </asp:DropDownList>

                            entries

                        </div>

                    </div>

                    <!-- Grid -->

                   <asp:GridView
    ID="gvExecutive"
    runat="server"
    CssClass="grid"
    AutoGenerateColumns="False"
    AllowPaging="True"
    PageSize="10"
    DataKeyNames="ExecutiveID"
    OnPageIndexChanging="gvExecutive_PageIndexChanging"
    OnRowCommand="gvExecutive_RowCommand"
    OnRowDataBound="gvExecutive_RowDataBound"
    OnPreRender="gvExecutive_PreRender"
    EmptyDataText="No Sales Executive Found">
                        <Columns>

                            <asp:BoundField
                                DataField="ExecutiveName"
                                HeaderText="Executive Name" />

                            <asp:BoundField
                                DataField="ContactNumber"
                                HeaderText="Contact Number" />

                            <asp:BoundField
                                DataField="NativeBranch"
                                HeaderText="Native Branch" />

                            <asp:BoundField
                                DataField="CreatedDate"
                                HeaderText="Created On"
                                DataFormatString="{0:dd MMM yyyy}" />

                            <asp:TemplateField HeaderText="Action">
    <ItemTemplate>

        <div class="cell-actions">

           <asp:LinkButton
    ID="lnkEdit"
    runat="server"
    CssClass="icon-btn icon-btn-edit"
    CommandName="EditExecutive"
    CommandArgument='<%# Eval("ExecutiveID") %>'
    CausesValidation="false"
    ToolTip="Edit">

                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                    <path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5Z"></path>
                </svg>

            </asp:LinkButton>

           <asp:LinkButton
    ID="lnkDelete"
    runat="server"
    CssClass="icon-btn icon-btn-delete"
    CommandName="DeleteExecutive"
    CommandArgument='<%# Eval("ExecutiveID") %>'
    CausesValidation="false"
    ToolTip="Delete">

                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
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

                    </asp:GridView>

                </div>

            </section>

        </div>

    </div>

    <!-- ===========================
         JAVASCRIPT
    ============================ -->

    <script>

        window.onload = function () {

            var toast = document.querySelector('.toast');

            if (toast) {

                setTimeout(function () {

                    toast.classList.add('toast-hide');

                    setTimeout(function () {

                        var stack = document.querySelector('.toast-stack');

                        if (stack)
                            stack.style.display = 'none';

                    }, 500);

                }, 3000);

            }

        };

    </script>

</asp:Content>