<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="IOSMSystem.Register" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Register - Integrated OS Learning Management System</title>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <link href='<%= ResolveUrl("~/Content/dark.css") + "?v=" + System.IO.File.GetLastWriteTimeUtc(Server.MapPath("~/Content/dark.css")).Ticks %>' rel="stylesheet" />
</head>
<body>
<form runat="server">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card mt-5">
                    <div class="card-header text-center">
                        <h4>Create Account</h4>
                    </div>
                    <div class="card-body">

                        <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />

                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="At least 3 characters" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                                TextMode="Password" placeholder="At least 12 characters" />
                            <div class="form-text">Min. 12 characters with uppercase, lowercase, number &amp; symbol</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirm Password</label>
                            <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control"
                                TextMode="Password" placeholder="Repeat password" />
                        </div>
                        <asp:Button ID="btnRegister" runat="server" Text="Register"
                            CssClass="btn btn-primary w-100" OnClick="btnRegister_Click" />

                        <div class="mt-3 text-center">
                            <a href="Login.aspx">Already have an account? Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
