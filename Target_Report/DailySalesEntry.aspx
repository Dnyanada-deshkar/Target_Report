<%@ Page Title="Daily Sales Entry" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="DailySalesEntry.aspx.cs" Inherits="Target_Report.DailySalesEntry" %>

<asp:Content ID="cntTitle" ContentPlaceHolderID="cphTitle" runat="server">
    Daily Sales Entry · Sales Target Report Management System
</asp:Content>

<asp:Content ID="cntHead" ContentPlaceHolderID="cphHead" runat="server">
   <link rel="stylesheet" href="/Dashboard.css" />
<link rel="stylesheet" href="/DailySalesEntry.css" />
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

           <asp:Panel ID="pnlEntryForm" runat="server" Visible="true">

<section class="panel">

    <div class="panel-header panel-header-flex">

    <div class="panel-header-title">
        <span id="pageModeTitle">Daily Sales Entry</span>
    </div>

    <div class="mode-switch">

        <button
            type="button"
            id="btnSalesMode"
            class="mode-btn active">
            <i class="fa fa-chart-line"></i>
            Sales Entry
        </button>

        <button
            type="button"
            id="btnRemarkMode"
            class="mode-btn">
            <i class="fa fa-comments"></i>
            Follow-up
        </button>

    </div>

</div>

    <div class="panel-body">
        <div id="salesPanel">
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

                <asp:RegularExpressionValidator
                    ID="revDailySale"
                    runat="server"
                    ControlToValidate="txtDailySale"
                    ValidationExpression="^\d+(\.\d{1,2})?$"
                    ErrorMessage="Invalid Amount"
                    CssClass="field-error"
                    ValidationGroup="SaleGroup" />

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


    <div class="form-actions">

        <asp:ValidationSummary
            ID="vsSale"
            runat="server"
            ValidationGroup="SaleGroup"
            CssClass="field-error" />

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

        <div id="followPanel" style="display:none;">

         <div class="form-grid">

                <div class="field-group">

            <label class="field-label">
                Partner Name
            </label>

            <asp:TextBox
                ID="txtPartnerNameFollow"
                runat="server"
                CssClass="field-input dse-readonly"
                ReadOnly="true" />

        </div>


        <div class="field-group">

            <label class="field-label">
                Contact Number
            </label>

            <asp:TextBox
                ID="txtContactNumber"
                runat="server"
                CssClass="field-input dse-readonly"
                ReadOnly="true" />

        </div>

        <div class="field-group">

            <label class="field-label">
                Follow-up Date
            </label>

            <asp:TextBox
                ID="txtFollowDate"
                runat="server"
                CssClass="field-input"
                TextMode="Date" />

        </div>

    </div>

    <div class="field-group" style="margin-top:20px;">

        <label class="field-label">

            Customer's Remark

        </label>

        <asp:TextBox
    ID="txtRemark"
    runat="server"
    CssClass="field-input remark-box"
    TextMode="MultiLine"
    Rows="5"
    placeholder="Write Client's Follow-up Here ....">
</asp:TextBox>

        <asp:RequiredFieldValidator
    ID="rfvRemark"
    runat="server"
    ControlToValidate="txtRemark"
    ErrorMessage="Please enter remark."
    CssClass="field-error"
    ValidationGroup="FollowUpGroup" />

<asp:RegularExpressionValidator
    ID="revRemark"
    runat="server"
    ControlToValidate="txtRemark"
    ValidationExpression="^.{10,}$"
    ErrorMessage="Remark should contain at least 10 characters."
    CssClass="field-error"
    ValidationGroup="FollowUpGroup" />

<asp:RequiredFieldValidator
    ID="rfvFollowDate"
    runat="server"
    ControlToValidate="txtFollowDate"
    ErrorMessage="Select follow-up date."
    CssClass="field-error"
    ValidationGroup="FollowUpGroup" />

    </div>

    <div class="form-actions">

       <asp:Button
    ID="btnSaveFollowup"
    runat="server"
    Text="Save Follow-up"
    CssClass="btn btn-primary"
    ValidationGroup="FollowUpGroup"
    OnClick="btnSaveFollowup_Click" />

    </div>

</div>
</div>

</section>

</asp:Panel>



<!-- =====================================================
     TODAY'S SALES
===================================================== -->

<section class="panel">

    <div class="panel-header">
        <div class="panel-header-title">
            <span>Today's Sales</span>
        </div>
    </div>

    <div class="panel-body">

        <asp:GridView
            ID="gvTodaySales"
            runat="server"
            Width="100%"
            CssClass="table-grid"
            AutoGenerateColumns="False"
            GridLines="Horizontal"
            DataKeyNames="SaleID"
            AllowPaging="true"
            PageSize="10"
            OnRowEditing="gvTodaySales_RowEditing"
            OnRowUpdating="gvTodaySales_RowUpdating"
            OnRowCancelingEdit="gvTodaySales_RowCancelingEdit"
            OnRowDeleting="gvTodaySales_RowDeleting"
            OnPageIndexChanging="gvTodaySales_PageIndexChanging"
            RowStyle-CssClass="grid-row"
            HeaderStyle-CssClass="grid-header"
            PagerStyle-CssClass="grid-pager">

            <Columns>

                <asp:BoundField
                    DataField="SaleID"
                    HeaderText="SaleID"
                    Visible="false" />

               
                <asp:BoundField
                    DataField="SaleDate"
                    HeaderText="Sale Date"
                    ReadOnly="true"
                    DataFormatString="{0:dd-MMM-yyyy}" />


                <asp:BoundField
                    DataField="PartnerName"
                    HeaderText="Partner Name"
                    ReadOnly="true" />

                <asp:BoundField
                    DataField="SalesAchieved"
                    HeaderText="Sales Achieved"
                    HtmlEncode="false"
                    DataFormatString="₹ {0:N2}" />

                <asp:BoundField
                    DataField="TargetBalance"
                    HeaderText="Target Balance"
                    ReadOnly="true"
                    HtmlEncode="false"
                    DataFormatString="₹ {0:N2}" />

                <asp:BoundField
                    DataField="CreatedDate"
                    HeaderText="Created"
                    ReadOnly="true"
                    DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />

               
               <%-- <asp:CommandField
    HeaderText="Actions"
    ShowEditButton="true"
    ShowDeleteButton="true"
    ButtonType="Button"
    EditText="Edit"
    UpdateText="Update"
    CancelText="Cancel"
    DeleteText="Delete"
    CausesValidation="false"
    ControlStyle-CssClass="btn btn-primary" /> --%>

                <asp:TemplateField HeaderText="Edit">
    <ItemTemplate>
        <asp:LinkButton
            ID="btnEdit"
            runat="server"
            CommandName="Edit"
            CssClass="action-btn edit-btn"
            ToolTip="Edit">
            🖊️
        </asp:LinkButton>
    </ItemTemplate>

    <EditItemTemplate>
        <asp:LinkButton
            ID="btnUpdate"
            runat="server"
            CommandName="Update"
            CssClass="action-btn update-btn"
            ToolTip="Update">
            ↻
        </asp:LinkButton>

        <asp:LinkButton
            ID="btnCancel"
            runat="server"
            CommandName="Cancel"
            CssClass="action-btn cancel-btn"
            ToolTip="Cancel">
            ✖
        </asp:LinkButton>
    </EditItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Delete">
    <ItemTemplate>
        <asp:LinkButton
            ID="btnDelete"
            runat="server"
            CommandName="Delete"
            CssClass="action-btn delete-btn"
            OnClientClick="return confirm('Delete this record?');"
            ToolTip="Delete">
            🗑
        </asp:LinkButton>
    </ItemTemplate>
</asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>

                <div class="empty-grid">
                    No Sales Found For Today.
                </div>

            </EmptyDataTemplate>

            <PagerStyle CssClass="grid-pager" />

        </asp:GridView>

    </div>

</section>

<!-- =====================================================
     CURRENT MONTH SALES
===================================================== -->

<section class="panel">

    <div class="panel-header">

        <div class="panel-header-title">
            <span>Current Month Sales</span>
        </div>

        <div style="margin-left:auto;display:flex;gap:10px;align-items:center;">

            <asp:TextBox
                ID="txtSearch"
                runat="server"
                CssClass="field-input"
                Width="220px"
                placeholder="Search Partner..." />

            <asp:Button
                ID="btnSearch"
                runat="server"
                Text="Search"
                CssClass="btn btn-primary"
                OnClick="btnSearch_Click" />

            <asp:Button
                ID="btnResetSearch"
                runat="server"
                Text="Reset"
                CssClass="btn btn-muted"
                OnClick="btnResetSearch_Click" />

        </div>

    </div>

    <div class="panel-body">

        <asp:GridView
            ID="gvMonthSales"
            runat="server"
            CssClass="table-grid"
            AutoGenerateColumns="False"
            GridLines="Horizontal"
            AllowPaging="true"
            PageSize="10"
            DataKeyNames="SaleID"
            OnPageIndexChanging="gvMonthSales_PageIndexChanging"
            RowStyle-CssClass="grid-row"
            HeaderStyle-CssClass="grid-header"
            PagerStyle-CssClass="grid-pager">

            <Columns>

                 <asp:BoundField
        DataField="SaleID"
        HeaderText="Sale ID"
        Visible="false" />

    <asp:BoundField
        DataField="SaleDate"
        HeaderText="Sale Date"
        ReadOnly="true"
        DataFormatString="{0:dd-MMM-yyyy}" />

    <asp:BoundField
        DataField="PartnerName"
        HeaderText="Partner Name"
        ReadOnly="true" />

    <asp:BoundField
        DataField="SalesAchieved"
        HeaderText="Sales Achieved"
        DataFormatString="₹ {0:N2}"
        HtmlEncode="false" />

    <asp:BoundField
        DataField="TargetBalance"
        HeaderText="Target Balance"
        ReadOnly="true"
        DataFormatString="₹ {0:N2}"
        HtmlEncode="false" />

    <asp:BoundField
        DataField="CreatedDate"
        HeaderText="Created On"
        ReadOnly="true"
        DataFormatString="{0:dd-MMM-yyyy hh:mm tt}" />

            </Columns>

            <EmptyDataTemplate>

               <div class="empty-grid">
                No Sales Found For Current Month.
            </div>

            </EmptyDataTemplate>

            <PagerStyle CssClass="grid-pager" />

        </asp:GridView>

    </div>

</section>
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
                }, 3000);
            }
        };


        const btnSales = document.getElementById("btnSalesMode");
        const btnRemark = document.getElementById("btnRemarkMode");

        const salesPanel = document.getElementById("salesPanel");
        const followPanel = document.getElementById("followPanel");
        const title = document.getElementById("pageModeTitle");

        btnSales.onclick = function () {

            btnSales.classList.add("active");
            btnRemark.classList.remove("active");

            salesPanel.style.display = "block";
            followPanel.style.display = "none";

            title.innerHTML = "Daily Sales Entry";
        };

        btnRemark.onclick = function () {

            btnRemark.classList.add("active");
            btnSales.classList.remove("active");

            salesPanel.style.display = "none";
            followPanel.style.display = "block";

            title.innerHTML = "Partner Follow-up";
        };

    </script>

</asp:Content>
