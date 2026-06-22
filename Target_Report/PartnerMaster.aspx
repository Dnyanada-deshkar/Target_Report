<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PartnerMaster.aspx.cs" Inherits="Target_Report.PartnerMaster" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Partner Master · Sales Target Report Management System</title>
    <style>



:root {
    --color-bg: #F3F5F8;
    --color-primary: #1E3A8A;
    --color-primary-hover: #16306F;
    --color-primary-active: #102451;
    --color-sidebar: #0F172A;
    --color-text: #111827;
    --color-text-secondary: #6B7280;
    --color-text-faint: #9AA3AF;
    --color-border: #E5E7EB;
    --color-border-strong: #D7DBE2;
    --color-card: #FFFFFF;

    --color-success: #16A34A;
    --color-success-bg: #F0FBF5;
    --color-success-hover: #128A3E;

    --color-danger: #DC2626;
    --color-danger-bg: #FEF2F2;
    --color-danger-hover: #B91C1C;

    --color-warning-text: #B45309;
    --color-warning-bg: #FFFBEB;
    --color-warning-border: #FDE9C8;

    --font-base: "Segoe UI", "Inter", -apple-system, BlinkMacSystemFont, Roboto, Helvetica, Arial, sans-serif;
    --font-mono: "Consolas", "SFMono-Regular", monospace;

    --radius-card: 10px;
    --radius-control: 7px;
    --radius-pill: 999px;

    --shadow-card:
        0 1px 1px rgba(15, 23, 42, 0.03),
        0 2px 6px rgba(15, 23, 42, 0.04),
        0 12px 28px -12px rgba(15, 23, 42, 0.10);

    --shadow-modal:
        0 4px 12px rgba(15, 23, 42, 0.08),
        0 32px 64px -20px rgba(15, 23, 42, 0.28);

    --shadow-toast: 0 8px 24px -6px rgba(15, 23, 42, 0.22);
}

* {
    box-sizing: border-box;
}

html, body {
    margin: 0;
    padding: 0;
    font-family: var(--font-base);
    color: var(--color-text);
    background-color: var(--color-bg);
    -webkit-font-smoothing: antialiased;
}

a {
    color: inherit;
}


.module-page {
    min-height: 100vh;
    width: 100%;
}

.module-container {
    max-width: 1320px;
    margin: 0 auto;
    padding: 28px 32px 56px;
}

/* =========================================================
   TOP HEADER
   ========================================================= */

.module-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 24px;
    margin-bottom: 24px;
}

.module-heading-block {
    display: flex;
    flex-direction: column;
}

.module-title {
    font-size: 22px;
    font-weight: 600;
    color: var(--color-text);
    margin: 0 0 5px 0;
    letter-spacing: -0.1px;
}

.module-subtitle {
    font-size: 13.5px;
    color: var(--color-text-secondary);
    margin: 0;
}

.module-breadcrumb {
    display: flex;
    align-items: center;
    gap: 7px;
    font-size: 12.5px;
    color: var(--color-text-faint);
    font-weight: 500;
    white-space: nowrap;
    margin-top: 4px;
}

.module-breadcrumb .crumb-current {
    color: var(--color-text-secondary);
    font-weight: 600;
}

.module-breadcrumb svg {
    width: 13px;
    height: 13px;
    color: #C7CDD6;
    flex-shrink: 0;
}

/* =========================================================
   SECTION CONTAINER (form panel, grid panel)
   ========================================================= */

.panel {
    background-color: var(--color-card);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-card);
    box-shadow: var(--shadow-card);
}

.panel + .panel {
    margin-top: 24px;
}

.panel-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 18px 24px;
    border-bottom: 1px solid var(--color-border);
}

.panel-header-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14.5px;
    font-weight: 600;
    color: var(--color-text);
}

.panel-header-title svg {
    width: 17px;
    height: 17px;
    color: var(--color-primary);
    flex-shrink: 0;
}

.panel-header-meta {
    font-size: 12.5px;
    color: var(--color-text-faint);
    font-weight: 500;
}

.panel-body {
    padding: 24px;
}

/* =========================================================
   FORM SECTION
   ========================================================= */

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    column-gap: 24px;
    row-gap: 18px;
}

.field-group {
    display: flex;
    flex-direction: column;
}

.field-label {
    font-size: 12.5px;
    font-weight: 600;
    color: var(--color-text);
    margin-bottom: 7px;
}

.field-label .required-mark {
    color: var(--color-danger);
    margin-left: 2px;
}

.field-control-wrap {
    position: relative;
}

.field-icon {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    width: 15px;
    height: 15px;
    color: #9CA6B4;
    pointer-events: none;
}

.field-input,
.field-select {
    width: 100%;
    height: 40px;
    padding: 0 13px;
    font-size: 13.5px;
    font-family: var(--font-base);
    color: var(--color-text);
    background-color: #FFFFFF;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-control);
    outline: none;
    transition: border-color 0.15s ease, box-shadow 0.15s ease;
    appearance: none;
}

.field-input.has-icon {
    padding-left: 36px;
}

.field-input::placeholder {
    color: #9CA6B4;
}

.field-input:hover,
.field-select:hover {
    border-color: var(--color-border-strong);
}

.field-input:focus,
.field-select:focus {
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.10);
}

.field-input.is-invalid,
.field-select.is-invalid {
    border-color: #EAB8B8;
    background-color: #FFFBFB;
}

.field-select-wrap {
    position: relative;
}

.field-select-wrap::after {
    content: "";
    position: absolute;
    right: 13px;
    top: 50%;
    width: 9px;
    height: 9px;
    border-right: 1.6px solid #8B96A6;
    border-bottom: 1.6px solid #8B96A6;
    transform: translateY(-65%) rotate(45deg);
    pointer-events: none;
}

.field-hint {
    font-size: 11.5px;
    color: var(--color-text-faint);
    margin-top: 5px;
}

.field-error {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 12px;
    font-weight: 500;
    color: var(--color-warning-text);
    margin-top: 6px;
}

.field-error svg {
    width: 13px;
    height: 13px;
    flex-shrink: 0;
}

.field-error:empty {
    display: none;
}

/* Form action row */

.form-actions {
    grid-column: 1 / -1;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 4px;
    padding-top: 18px;
    border-top: 1px solid var(--color-border);
}

.form-actions-spacer {
    flex: 1;
}

.form-mode-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 600;
    color: var(--color-text-secondary);
    background-color: var(--color-bg);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-pill);
    padding: 5px 12px 5px 10px;
}

.form-mode-tag .dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: var(--color-text-faint);
}

.form-mode-tag.is-editing {
    color: var(--color-primary);
    border-color: #C7D2EC;
    background-color: #EEF2FB;
}

.form-mode-tag.is-editing .dot {
    background-color: var(--color-primary);
}

/* =========================================================
   BUTTONS
   ========================================================= */

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    height: 38px;
    padding: 0 16px;
    font-size: 13.5px;
    font-weight: 600;
    font-family: var(--font-base);
    border-radius: var(--radius-control);
    border: 1px solid transparent;
    cursor: pointer;
    letter-spacing: 0.1px;
    transition: background-color 0.15s ease, border-color 0.15s ease, color 0.15s ease, transform 0.05s ease;
    white-space: nowrap;
}

.btn svg {
    width: 15px;
    height: 15px;
    flex-shrink: 0;
}

.btn:active {
    transform: translateY(1px);
}

.btn-primary {
    background-color: var(--color-primary);
    color: #FFFFFF;
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.08);
}

.btn-primary:hover {
    background-color: var(--color-primary-hover);
}

.btn-success {
    background-color: var(--color-success);
    color: #FFFFFF;
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.08);
}

.btn-success:hover {
    background-color: var(--color-success-hover);
}

.btn-muted {
    background-color: #EEF0F3;
    color: var(--color-text-secondary);
    border-color: #EEF0F3;
}

.btn-muted:hover {
    background-color: #E3E6EB;
}

.btn-outline {
    background-color: transparent;
    color: var(--color-text-secondary);
    border-color: var(--color-border-strong);
}

.btn-outline:hover {
    background-color: var(--color-bg);
    border-color: #B9C0CB;
    color: var(--color-text);
}

.btn-danger-outline {
    background-color: transparent;
    color: var(--color-danger);
    border-color: #F3C6C6;
}

.btn-danger-outline:hover {
    background-color: var(--color-danger-bg);
    border-color: var(--color-danger);
}

.btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* =========================================================
   SEARCH / FILTER BAR
   ========================================================= */

.toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 18px 24px;
    border-bottom: 1px solid var(--color-border);
    flex-wrap: wrap;
}

.search-control {
    position: relative;
    flex: 1 1 320px;
    min-width: 240px;
    max-width: 420px;
}

.search-control .field-icon {
    color: #9CA6B4;
}

.search-input {
    width: 100%;
    height: 38px;
    padding: 0 13px 0 36px;
    font-size: 13.5px;
    font-family: var(--font-base);
    color: var(--color-text);
    background-color: var(--color-bg);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-control);
    outline: none;
    transition: border-color 0.15s ease, background-color 0.15s ease, box-shadow 0.15s ease;
}

.search-input::placeholder {
    color: #9CA6B4;
}

.search-input:hover {
    border-color: var(--color-border-strong);
}

.search-input:focus {
    background-color: #FFFFFF;
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.10);
}

.toolbar-filters {
    display: flex;
    align-items: center;
    gap: 10px;
}

.filter-select {
    height: 38px;
    padding: 0 32px 0 13px;
    font-size: 13px;
    font-weight: 500;
    color: var(--color-text-secondary);
    background-color: #FFFFFF;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-control);
    outline: none;
    appearance: none;
    cursor: pointer;
}

.filter-select-wrap {
    position: relative;
}

.filter-select-wrap::after {
    content: "";
    position: absolute;
    right: 13px;
    top: 50%;
    width: 8px;
    height: 8px;
    border-right: 1.5px solid #8B96A6;
    border-bottom: 1.5px solid #8B96A6;
    transform: translateY(-65%) rotate(45deg);
    pointer-events: none;
}

.toolbar-result-count {
    font-size: 12.5px;
    color: var(--color-text-faint);
    font-weight: 500;
    white-space: nowrap;
}

/* =========================================================
   DATA TABLE
   ========================================================= */

.table-scroll {
    overflow-x: auto;
}

.data-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 13.5px;
}

.data-table thead th {
    position: sticky;
    top: 0;
    z-index: 1;
    background-color: #FAFBFC;
    text-align: left;
    font-size: 11.5px;
    font-weight: 700;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    color: var(--color-text-faint);
    padding: 12px 16px;
    border-bottom: 1px solid var(--color-border);
    white-space: nowrap;
}

.data-table thead th.is-sortable {
    cursor: pointer;
    user-select: none;
}

.data-table thead th.is-sortable:hover {
    color: var(--color-text-secondary);
}

.th-sort-wrap {
    display: inline-flex;
    align-items: center;
    gap: 5px;
}

.th-sort-wrap svg {
    width: 11px;
    height: 11px;
    color: #C7CDD6;
}

.data-table thead th.is-sorted .th-sort-wrap svg {
    color: var(--color-primary);
}

.data-table tbody td {
    padding: 13px 16px;
    border-bottom: 1px solid var(--color-border);
    color: var(--color-text);
    vertical-align: middle;
}

.data-table tbody tr {
    transition: background-color 0.1s ease;
}

.data-table tbody tr:hover {
    background-color: #F8FAFC;
}

.data-table tbody tr:last-child td {
    border-bottom: none;
}

.cell-id {
    color: var(--color-text-faint);
    font-family: var(--font-mono);
    font-size: 12.5px;
}

.cell-name {
    font-weight: 600;
    color: var(--color-text);
}

.cell-secondary {
    color: var(--color-text-secondary);
}

.branch-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 600;
    padding: 4px 10px;
    border-radius: var(--radius-pill);
    background-color: #EEF2FB;
    color: var(--color-primary);
}

.branch-tag .dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: var(--color-primary);
}

.branch-tag.is-nagpur {
    background-color: var(--color-success-bg);
    color: var(--color-success-hover);
}

.branch-tag.is-nagpur .dot {
    background-color: var(--color-success);
}

.cell-actions {
    display: flex;
    align-items: center;
    gap: 6px;
}

.icon-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    border-radius: var(--radius-control);
    border: 1px solid transparent;
    background-color: transparent;
    color: var(--color-text-faint);
    cursor: pointer;
    transition: background-color 0.15s ease, color 0.15s ease, border-color 0.15s ease;
}

.icon-btn svg {
    width: 16px;
    height: 16px;
}

.icon-btn:hover {
    background-color: var(--color-bg);
    border-color: var(--color-border);
    color: var(--color-text-secondary);
}

.icon-btn.icon-btn-edit:hover {
    color: var(--color-primary);
    background-color: #EEF2FB;
    border-color: #C7D2EC;
}

.icon-btn.icon-btn-delete:hover {
    color: var(--color-danger);
    background-color: var(--color-danger-bg);
    border-color: #F3C6C6;
}

/* --- Empty state --- */

.table-empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 64px 24px;
}

.table-empty-icon {
    width: 44px;
    height: 44px;
    color: #D7DBE2;
    margin-bottom: 16px;
}

.table-empty-title {
    font-size: 14.5px;
    font-weight: 600;
    color: var(--color-text);
    margin: 0 0 6px 0;
}

.table-empty-text {
    font-size: 13px;
    color: var(--color-text-secondary);
    margin: 0;
    max-width: 320px;
}

/* =========================================================
   PAGINATION FOOTER
   ========================================================= */

.table-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 14px 24px;
    border-top: 1px solid var(--color-border);
    flex-wrap: wrap;
}

.page-size-control {
    display: flex;
    align-items: center;
    gap: 9px;
    font-size: 12.5px;
    color: var(--color-text-secondary);
    font-weight: 500;
}

.page-size-select {
    height: 32px;
    padding: 0 26px 0 10px;
    font-size: 12.5px;
    font-weight: 600;
    color: var(--color-text);
    background-color: #FFFFFF;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-control);
    outline: none;
    appearance: none;
    cursor: pointer;
}

.page-size-wrap {
    position: relative;
}

.page-size-wrap::after {
    content: "";
    position: absolute;
    right: 11px;
    top: 50%;
    width: 7px;
    height: 7px;
    border-right: 1.4px solid #8B96A6;
    border-bottom: 1.4px solid #8B96A6;
    transform: translateY(-65%) rotate(45deg);
    pointer-events: none;
}

.pagination {
    display: flex;
    align-items: center;
    gap: 4px;
}

.page-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 32px;
    height: 32px;
    padding: 0 6px;
    font-size: 12.5px;
    font-weight: 600;
    color: var(--color-text-secondary);
    background-color: transparent;
    border: 1px solid transparent;
    border-radius: var(--radius-control);
    cursor: pointer;
    transition: background-color 0.15s ease, color 0.15s ease;
}

.page-btn:hover {
    background-color: var(--color-bg);
}

.page-btn.is-active {
    background-color: var(--color-primary);
    color: #FFFFFF;
}

.page-btn:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

.page-btn svg {
    width: 14px;
    height: 14px;
}

.page-ellipsis {
    color: var(--color-text-faint);
    font-size: 12.5px;
    padding: 0 4px;
}

/* =========================================================
   TOAST NOTIFICATION
   ========================================================= */

.toast-stack {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 1000;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.toast {
    display: flex;
    align-items: flex-start;
    gap: 11px;
    min-width: 300px;
    max-width: 360px;
    padding: 14px 16px;
    background-color: #FFFFFF;
    border: 1px solid var(--color-border);
    border-left: 3px solid var(--color-success);
    border-radius: var(--radius-control);
    box-shadow: var(--shadow-toast);
}

.toast.is-error {
    border-left-color: var(--color-danger);
}

.toast-icon {
    width: 18px;
    height: 18px;
    flex-shrink: 0;
    margin-top: 1px;
    color: var(--color-success);
}

.toast.is-error .toast-icon {
    color: var(--color-danger);
}

.toast-content {
    flex: 1;
}

.toast-title {
    font-size: 13.5px;
    font-weight: 600;
    color: var(--color-text);
    margin: 0 0 2px 0;
}

.toast-text {
    font-size: 12.5px;
    color: var(--color-text-secondary);
    margin: 0;
}

.toast-close {
    background: none;
    border: none;
    padding: 2px;
    cursor: pointer;
    color: var(--color-text-faint);
    flex-shrink: 0;
}

.toast-close svg {
    width: 14px;
    height: 14px;
}

/* =========================================================
   CONFIRMATION MODAL
   ========================================================= */

.modal-overlay {
    position: fixed;
    inset: 0;
    z-index: 999;
    background-color: rgba(15, 23, 42, 0.45);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
}

.modal-overlay.is-hidden {
    display: none;
}

.modal-card {
    width: 100%;
    max-width: 400px;
    background-color: #FFFFFF;
    border-radius: var(--radius-card);
    box-shadow: var(--shadow-modal);
    padding: 26px 26px 22px;
}

.modal-icon-wrap {
    width: 42px;
    height: 42px;
    border-radius: 10px;
    background-color: var(--color-danger-bg);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
}

.modal-icon-wrap svg {
    width: 21px;
    height: 21px;
    color: var(--color-danger);
}

.modal-title {
    font-size: 15.5px;
    font-weight: 600;
    color: var(--color-text);
    margin: 0 0 8px 0;
}

.modal-text {
    font-size: 13.5px;
    line-height: 1.55;
    color: var(--color-text-secondary);
    margin: 0 0 22px 0;
}

.modal-text strong {
    color: var(--color-text);
    font-weight: 600;
}

.modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

/* =========================================================
   RESPONSIVE
   ========================================================= */

@media (max-width: 1080px) {
    .module-container {
        padding: 24px 20px 48px;
    }
}

@media (max-width: 860px) {
    .module-header {
        flex-direction: column;
        gap: 8px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .toolbar {
        flex-direction: column;
        align-items: stretch;
    }

    .search-control {
        width: 100%;
        max-width: none;
        align-self: stretch;
        flex: none;
    }

    .search-control .field-icon {
        top: 19px;
        transform: none;
    }

    .toolbar-filters {
        justify-content: space-between;
    }

    .table-footer {
        flex-direction: column;
        align-items: stretch;
    }

    .pagination {
        justify-content: center;
    }
}

@media (max-width: 480px) {
    .panel-body {
        padding: 18px;
    }

    .panel-header,
    .toolbar,
    .table-footer {
        padding: 16px 18px;
    }

    .data-table thead th,
    .data-table tbody td {
        padding: 11px 12px;
    }
}

/* Accessibility */
.field-input:focus-visible,
.field-select:focus-visible,
.search-input:focus-visible,
.btn:focus-visible,
.icon-btn:focus-visible,
.page-btn:focus-visible,
.filter-select:focus-visible,
.page-size-select:focus-visible {
    outline: 2px solid var(--color-primary);
    outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
    * {
        transition: none !important;
    }
}


    </style>

</head>
<body>
    <form id="frmPartnerMaster" runat="server">

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
                                    <asp:TextBox ID="txtPartnerName" runat="server" CssClass="field-input" placeholder="e.g. Shree Enterprises" MaxLength="100" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPartnerName" runat="server"
                                    ControlToValidate="txtPartnerName"
                                    CssClass="field-error" Display="Dynamic"
                                    ErrorMessage="Please enter partner name."
                                    ValidationGroup="PartnerForm" />
                            </div>

                            <div class="field-group">
                                <asp:Label runat="server" AssociatedControlID="txtContactNumber" CssClass="field-label">
                                    Contact Number<span class="required-mark">*</span>
                                </asp:Label>
                                <div class="field-control-wrap">
                                    <asp:TextBox ID="txtContactNumber" runat="server" CssClass="field-input" placeholder="10-digit mobile number" MaxLength="10" />
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
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="field-input" placeholder="e.g. Pune" MaxLength="50" />
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
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search partners, contacts, or cities" AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
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
                            AllowSorting="true"
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

    </form>

    <script>
        var pendingDeleteId = null;

        function confirmDelete(partnerId, partnerName) {
            // The actual delete modal is server-rendered (asp:Panel),
            // so this client hook just stops the default postback —
            // the LinkButton's CommandArgument carries the ID server-side
            // and the code-behind opens the modal via pnlDeleteModalOverlay.
            return true;
        }
    </script>
</body>
</html>
