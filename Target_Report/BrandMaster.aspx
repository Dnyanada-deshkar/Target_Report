<%@ Page Title="Brand Master"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BrandMaster.aspx.cs"
    Inherits="Target_Report.BrandMaster" %>

<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Brand Master · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">

    <link rel="stylesheet" href="/BrandMaster.css" />

</asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

<div class="module-page">
<div class="module-container">

    <!-- ============================================
         PAGE HEADER
    ============================================= -->

    <div class="module-header">

        <div class="module-heading-block">

            <h1 class="module-title">
                Brand Master
            </h1>

            <p class="module-subtitle">
                Manage all brands associated with the organization.
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
                Brand Master
            </span>

        </nav>

    </div>

    <!-- ============================================
         TOAST
    ============================================= -->

    <asp:Panel
        ID="pnlToast"
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
                    <asp:Literal
                        ID="litToastTitle"
                        runat="server" />
                </p>

                <p class="toast-text">
                    <asp:Literal
                        ID="litToastText"
                        runat="server" />
                </p>

            </div>

        </div>

    </asp:Panel>

    <!-- ============================================
         BRAND INFORMATION
    ============================================= -->

    <section class="panel">

        <div class="panel-header">

            <div class="panel-header-title">

                <svg viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="1.8"
                    stroke-linecap="round"
                    stroke-linejoin="round">

                    <path d="M20 12L12 4L4 12"></path>
                    <path d="M6 10V20H18V10"></path>

                </svg>

                <span>
                    Brand Information
                </span>

            </div>

            <asp:Panel
                ID="pnlFormMode"
                runat="server"
                CssClass="form-mode-tag">

                <span class="dot"></span>

                <asp:Literal
                    ID="litFormMode"
                    runat="server"
                    Text="New Brand" />

            </asp:Panel>

        </div>

        <div class="panel-body">

            <div class="form-grid">

                <asp:HiddenField
                    ID="hdnBrandID"
                    runat="server"
                    Value="0" />

              

                <div class="field-group">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtBrandName"
                        CssClass="field-label">

                        Brand Name
                        <span class="required-mark">*</span>

                    </asp:Label>

                    <asp:TextBox
                        ID="txtBrandName"
                        runat="server"
                        CssClass="field-input"
                        MaxLength="250"
                        placeholder="Enter Brand Name"
                        autocomplete="off" />

                    <asp:RequiredFieldValidator
                        ID="rfvBrandName"
                        runat="server"
                        ControlToValidate="txtBrandName"
                        ValidationGroup="BrandGroup"
                        CssClass="field-error"
                        ErrorMessage="Brand Name is required." />

                </div>

               

                <div class="field-group">
                </div>

              
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
                        Text="Save Brand"
                        CssClass="btn btn-primary"
                        ValidationGroup="BrandGroup"
                        OnClick="btnSave_Click" />

                </div>

            </div>

        </div>

    </section>

        <!-- ===========================================
         BRAND LIST
    ============================================ -->

   <section class="panel">

    <div class="panel-header">

        <div class="panel-header-title">
            <span>Brand List</span>
        </div>

    </div>

    <div class="panel-body">

        <div class="table-toolbar">

            <div class="table-search">

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="field-input search-input"
                    AutoPostBack="true"
                    OnTextChanged="txtSearch_TextChanged"
                    autocomplete="off"
                    placeholder="Search Brand..." />

            </div>

        </div>

        <div class="table-wrapper">

            <asp:GridView
                ID="gvBrand"
                runat="server"
                CssClass="grid"
                AutoGenerateColumns="False"
                AllowPaging="False"
                PageSize="10"
                Width="100%"
                GridLines="None"
                BorderStyle="None"
                CellPadding="0"
                CellSpacing="0"
                DataKeyNames="BrandID"
                EmptyDataText="No Brand Found"
                OnPageIndexChanging="gvBrand_PageIndexChanging"
                OnRowCommand="gvBrand_RowCommand"
                OnRowDataBound="gvBrand_RowDataBound"
                OnPreRender="gvBrand_PreRender">

                <Columns>

                    <asp:BoundField
                        DataField="BrandName"
                        HeaderText="Brand Name" />

                    <asp:BoundField
                        DataField="CreatedDate"
                        HeaderText="Created Date"
                        DataFormatString="{0:dd MMM yyyy}" />

                    <asp:TemplateField
                        HeaderText="Actions"
                        ItemStyle-Width="110">

                        <ItemTemplate>

                            <div class="cell-actions">

                                <asp:LinkButton
                                    ID="lnkEdit"
                                    runat="server"
                                    CssClass="table-action edit"
                                    CommandName="EditBrand"
                                    CommandArgument='<%# Eval("BrandID") %>'
                                    CausesValidation="false"
                                    ToolTip="Edit">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>

                                        <path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5Z"></path>

                                    </svg>

                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="lnkDelete"
                                    runat="server"
                                    CssClass="table-action delete"
                                    CommandName="DeleteBrand"
                                    CommandArgument='<%# Eval("BrandID") %>'
                                    CausesValidation="false"
                                    ToolTip="Delete">

                                    <svg viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round">

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

        <div class="table-toolbar-right">

    <span class="rows-label">
        Rows per page
    </span>

    <asp:DropDownList
        ID="ddlPageSize"
        runat="server"
        CssClass="page-size-select"
        AutoPostBack="true"
        OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">

        <asp:ListItem Selected="True">20</asp:ListItem>
        <asp:ListItem>50</asp:ListItem>
        <asp:ListItem>100</asp:ListItem>

    </asp:DropDownList>

</div>

    </div>

</section>

</div>

</div>

<!-- ===========================================
     TOAST SCRIPT
=========================================== -->

<script>

    window.onload = function () {

        var toast = document.querySelector('.toast');

        if (toast) {

            setTimeout(function () {

                toast.classList.add('toast-hide');

                setTimeout(function () {

                    var stack =
                        document.querySelector('.toast-stack');

                    if (stack)
                        stack.style.display = 'none';

                }, 500);

            }, 3000);

        }

    };

</script>

</asp:Content>