<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" MaintainScrollPositionOnPostback="true" Inherits="Target_Report.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In · Sales Target Report Management System</title>

    <style>

        :root {
    --color-bg: #F3F5F8;
    --color-primary: #1E3A8A;
    --color-primary-hover: #16306F;
    --color-primary-active: #102451;
    --color-sidebar: #0F172A;
    --color-text: #111827;
    --color-text-secondary: #6B7280;
    --color-border: #E5E7EB;
    --color-card: #FFFFFF;
    --color-success: #16A34A;

    --font-base: "Segoe UI", "Inter", -apple-system, BlinkMacSystemFont, Roboto, Helvetica, Arial, sans-serif;

    --radius-card: 14px;
    --radius-control: 7px;

    --shadow-card:
        0 1px 1px rgba(15, 23, 42, 0.03),
        0 4px 10px rgba(15, 23, 42, 0.04),
        0 24px 48px -16px rgba(15, 23, 42, 0.16);
}

* {
    box-sizing: border-box;
}

html, body {
    margin: 0;
    padding: 0;
    height: 100%;
    font-family: var(--font-base);
    color: var(--color-text);
    -webkit-font-smoothing: antialiased;
}

.page-bg {
    position: relative;
    min-height: 100vh;
    width: 100%;
    background-color: var(--color-bg);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 28px 24px;
    overflow: hidden;
}

.page-bg::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(to right, rgba(15, 23, 42, 0.045) 2px, transparent 1px),
        linear-gradient(to bottom, rgba(15, 23, 42, 0.045) 2px, transparent 1px);
    background-size: 56px 56px;
    pointer-events: none;
}

.page-bg::after {
    content: "";
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 50% 38%, rgba(243, 245, 248, 0) 0%, rgba(243, 245, 248, 0) 38%, #F3F5F8 88%);
    pointer-events: none;
}

.bg-frame-line-top,
.bg-frame-line-bottom {
    position: absolute;
    left: 0;
    right: 0;
    height: 1px;
    background: rgba(15, 23, 42, 0.06);
    pointer-events: none;
}

.bg-frame-line-top { top: 64px; }
.bg-frame-line-bottom { bottom: 64px; }

.bg-frame-tag {
    position: absolute;
    top: 28px;
    left: 32px;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 1.6px;
    text-transform: uppercase;
    color: #A8B1BF;
    pointer-events: none;
}

.bg-frame-tag.is-right {
    left: auto;
    right: 32px;
}

@media (max-width: 640px) {
    .bg-frame-line-top,
    .bg-frame-line-bottom,
    .bg-frame-tag {
        display: none;
    }
}

.login-column {
    position: relative;
    top: -17px;
    z-index: 1;
    width: 100%;
    max-width: 460px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.identity-block {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    margin-bottom: 36px;
}

.identity-mark {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0 auto 18px;
}

.identity-logo {
   display: block;
    width: 200px;
    height: auto;
    margin: 0 auto;
    transform: translateX(-8px);
}

.identity-company {
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 2.4px;
    text-transform: uppercase;
    color: var(--color-text-secondary);
    margin: 0 0 8px 0;
}

.identity-system {
    font-size: 20px;
    font-weight: 600;
    color: var(--color-text);
    margin: 0 0 10px 0;
    letter-spacing: -0.1px;
}

.identity-description {
    font-size: 13.5px;
    line-height: 1.55;
    color: var(--color-text-secondary);
    margin: 0;
    max-width: 320px;
}

.login-card {
    width: 100%;
    background-color: var(--color-card);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-card);
    box-shadow: var(--shadow-card);
    padding: 36px 36px 30px 36px;
}

.field-group {
    margin-bottom: 20px;
}

.field-label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: var(--color-text);
    margin-bottom: 7px;
}

.field-control-wrap {
    position: relative;
}

.field-icon {
    position: absolute;
    left: 13px;
    top: 50%;
    transform: translateY(-50%);
    width: 16px;
    height: 16px;
    color: #9CA6B4;
    pointer-events: none;
}

.field-input {
    width: 100%;
    height: 44px;
    padding: 0 14px 0 38px;
    font-size: 14px;
    font-family: var(--font-base);
    color: var(--color-text);
    background-color: #FFFFFF;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-control);
    outline: none;
    transition: border-color 0.15s ease, box-shadow 0.15s ease;
}

.field-input::placeholder {
    color: #9CA6B4;
}

.field-input:hover {
    border-color: #C7CDD6;
}

.field-input:focus {
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.12);
}

.field-input.password-input {
    padding-right: 42px;
}

.toggle-password {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    padding: 4px;
    cursor: pointer;
    color: #9CA6B4;
    display: flex;
    align-items: center;
}

.toggle-password:hover {
    color: var(--color-text-secondary);
}

.toggle-password svg {
    width: 17px;
    height: 17px;
}

.field-row-between {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24px;
}

.remember-wrap {
    display: flex;
    align-items: center;
    gap: 8px;
}

.remember-checkbox {
    width: 16px;
    height: 16px;
    accent-color: var(--color-primary);
    cursor: pointer;
}

.remember-label {
    font-size: 13.5px;
    color: var(--color-text);
    cursor: pointer;
}

.forgot-link {
    font-size: 13.5px;
    font-weight: 600;
    color: var(--color-primary);
    text-decoration: none;
}

.forgot-link:hover {
    text-decoration: underline;
}

.btn-signin {
    width: 100%;
    height: 46px;
    background-color: var(--color-primary);
    color: #FFFFFF;
    font-size: 14.5px;
    font-weight: 600;
    font-family: var(--font-base);
    border: none;
    border-radius: var(--radius-control);
    cursor: pointer;
    letter-spacing: 0.2px;
    transition: background-color 0.15s ease, transform 0.05s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.08);
}

.btn-signin svg {
    width: 16px;
    height: 16px;
}

.btn-signin:hover {
    background-color: var(--color-primary-hover);
}

.btn-signin:active {
    background-color: var(--color-primary-active);
    transform: translateY(1px);
}

.login-message {
    margin-top: 16px;
    padding: 10px 14px;
    border-radius: var(--radius-control);
    font-size: 13px;
    font-weight: 500;
    background-color: #FEF2F2;
    border: 1px solid #FECACA;
    color: #B91C1C;
}

.login-message.is-hidden {
    display: none;
}

.card-divider {
    height: 1px;
    background-color: var(--color-border);
    margin: 26px 0 18px 0;
}

.security-badge {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    font-size: 12.5px;
    color: var(--color-text-secondary);
    font-weight: 500;
}

.security-badge svg {
    width: 13px;
    height: 13px;
    color: var(--color-success);
    flex-shrink: 0;
}

.login-footer {
    margin-top: 28px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 12px;
    color: #9AA3AF;
}

.login-footer .dot {
    width: 3px;
    height: 3px;
    border-radius: 50%;
    background-color: #C2C8D1;
    flex-shrink: 0;
}

.version-tag {
    font-family: "Consolas", "SFMono-Regular", monospace;
    letter-spacing: 0.2px;
}

@media (max-width: 480px) {
    .login-card {
        padding: 28px 22px 24px;
    }

    .identity-system {
        font-size: 18px;
    }

    .identity-description {
        font-size: 13px;
    }

    .login-footer {
        flex-wrap: wrap;
        justify-content: center;
        text-align: center;
    }
}

.field-input:focus-visible,
.btn-signin:focus-visible,
.toggle-password:focus-visible,
.forgot-link:focus-visible,
.remember-checkbox:focus-visible {
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
    <form id="loginForm" runat="server" autocomplete="off">

        <div class="page-bg">

            <!-- Quiet structural framing — hairlines and corner tags,
                 no marketing content, no imagery -->
            <div class="bg-frame-line-top" aria-hidden="true"></div>
            <div class="bg-frame-line-bottom" aria-hidden="true"></div>
            <span class="bg-frame-tag" aria-hidden="true">Ally Solutions</span>
            <span class="bg-frame-tag is-right" aria-hidden="true">Internal System</span>

            <div class="login-column">

                <!-- Identity: logo mark, company, system name -->
                <div class="identity-block">
                    <!-- <div class="identity-mark">XYZ</div> -->
                    <div class="identity-mark">
    <img src="Images/allylogo.png" alt="Ally Solutions Logo" class="identity-logo" />
</div>

                    <p class="identity-company">Ally Solutions</p>
                    <h1 class="identity-system">Sales Target Report Management System</h1>
                    <p class="identity-description">Sign in with your administrator account to access the management console.</p>
                </div>

                <!-- Login card -->
                <div class="login-card">

                    <!-- Username -->
                    <div class="field-group">
                        <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="field-label">Username</asp:Label>
                        <div class="field-control-wrap">
                            <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="field-input" placeholder="Enter your username"    AutoCompleteType="Disabled"   onkeydown="return moveToPassword(event);" />
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="field-group">
                        <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="field-label">Password</asp:Label>
                        <div class="field-control-wrap">
                            <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="5" y="11" width="14" height="9" rx="2"></rect>
                                <path d="M8 11V7a4 4 0 0 1 8 0v4"></path>
                            </svg>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="field-input password-input" TextMode="Password" placeholder="Enter your password"    AutoCompleteType="Disabled" />
                            <button type="button" class="toggle-password" id="btnTogglePassword" aria-label="Show password" onclick="togglePasswordVisibility()">
                                <svg id="iconEye" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8Z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Remember Me / Forgot Password -->
                    <div class="field-row-between">
                        <div class="remember-wrap">
                            <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="remember-checkbox" />
                            <asp:Label runat="server" AssociatedControlID="chkRememberMe" CssClass="remember-label">Remember me</asp:Label>
                        </div>
                        <asp:HyperLink ID="lnkForgotPassword" runat="server" CssClass="forgot-link" NavigateUrl="~/ForgotPassword.aspx">Forgot password?</asp:HyperLink>
                    </div>

                    <!-- Sign In -->
                    <asp:Button ID="btnSignIn" runat="server" Text="Sign In" CssClass="btn-signin" OnClick="btnSignIn_Click" />

                    <!-- Validation / Error Message -->
                    <asp:Panel ID="pnlMessage" runat="server" CssClass="login-message is-hidden">
                        <asp:Literal ID="litMessage" runat="server" />
                    </asp:Panel>

                    <div class="card-divider"></div>

                    <!-- Secure Login Badge -->
                    <div class="security-badge">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"></path>
                        </svg>
                        <span>Secure enterprise access</span>
                    </div>

                </div>

                <!-- Footer beneath the card -->
                <div class="login-footer">
                    <span class="version-tag">v1.0.0</span>
                    <span class="dot" aria-hidden="true"></span>
                    <span>&copy; <%= TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("India Standard Time")).Year %> Ally Solutions</span>                    <span class="dot" aria-hidden="true"></span>
                    <span>All rights reserved</span>
                </div>

            </div>

        </div>

    </form>

    <script>
        function togglePasswordVisibility() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            var btn = document.getElementById('btnTogglePassword');
            var isHidden = pwd.type === 'password';
            pwd.type = isHidden ? 'text' : 'password';
            btn.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');
        }

        function moveToPassword(event) {
            if (event.key === "Enter") {
                event.preventDefault();
                document.getElementById('<%= txtPassword.ClientID %>').focus();
                return false;
            }
            return true;
        }

    </script>
</body>
</html>


