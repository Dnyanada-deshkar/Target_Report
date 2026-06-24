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
                   <svg class="toast-icon"
     style="width:18px;height:18px;flex-shrink:0;margin-top:2px;display:block;"
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
            <span>Select Partner</span>
        </div>
    </div>

    <div class="panel-body">
        <div class="form-grid">

            <div class="field-group">
                <asp:Label runat="server"
                    AssociatedControlID="ddlPartner"
                    CssClass="field-label">
                    Partner Name *
                </asp:Label>

                <asp:DropDownList
                    ID="ddlPartner"
                    runat="server"
                    CssClass="field-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlPartner_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

        </div>
    </div>
</section>

            <!-- =====================================================
                 SECTION 2 — KPI SUMMARY (visible only when target loads)
                 ===================================================== -->

                    

           

            <!-- =====================================================
                 SECTION 3 — NO TARGET BANNER
                 ===================================================== -->
            

            <!-- =====================================================
                 SECTION 4 — TARGET ACHIEVED BANNER
                 ===================================================== -->
            
            <!-- =====================================================
                 SECTION 5 — ENTRY FORM
                 ===================================================== -->
           <asp:Panel ID="pnlEntryForm" runat="server" Visible="true">

<section class="panel">

    <div class="panel-header">
        <div class="panel-header-title">
            <span>Daily Sales Entry</span>
        </div>
    </div>

    <div class="panel-body">

        <div class="form-grid">

            <div class="field-group">
                <asp:Label runat="server"
                    AssociatedControlID="txtDailySale"
                    CssClass="field-label">
                    Daily Sales Achieved *
                </asp:Label>

                <asp:TextBox
                    ID="txtDailySale"
                    runat="server"
                    CssClass="field-input dse-sale-input">
                </asp:TextBox>

                <asp:RequiredFieldValidator
                    ID="rfvDailySale"
                    runat="server"
                    ControlToValidate="txtDailySale"
                    ValidationGroup="SaleGroup"
                    CssClass="field-error"
                    ErrorMessage="Enter Daily Sale">
                </asp:RequiredFieldValidator>

            </div>

            <div class="field-group">

                <asp:Label runat="server"
                    AssociatedControlID="txtTargetBalance"
                    CssClass="field-label">
                    Target Balance
                </asp:Label>

                <asp:TextBox
                    ID="txtTargetBalance"
                    runat="server"
                    ReadOnly="true"
                    CssClass="field-input dse-readonly">
                </asp:TextBox>

            </div>

        </div>

        <div style="margin-top:20px;">

            <asp:Button
                ID="btnSave"
                runat="server"
                Text="Save Entry"
                CssClass="btn btn-primary"
                ValidationGroup="SaleGroup"
                OnClick="btnSave_Click" />

            <asp:Button
                ID="btnClear"
                runat="server"
                Text="Clear"
                CssClass="btn btn-muted"
                CausesValidation="false"
                OnClick="btnClear_Click" />

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
