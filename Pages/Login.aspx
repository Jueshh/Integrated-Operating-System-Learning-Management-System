<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="IOSMSystem.Login" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Login - Integrated OS Learning Management System</title>
	<link href="/Content/bootstrap.min.css" rel="stylesheet" />
	<link href='<%= ResolveUrl("~/Content/dark.css") + "?v=" + System.IO.File.GetLastWriteTimeUtc(Server.MapPath("~/Content/dark.css")).Ticks %>' rel="stylesheet" />
</head>
<body>
	<form runat="server">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-md-4">
					<div class="card auth-card">
						<div class="card-header text-center">
							<h3>Group 7</h3>
							<h4>Integrated OS Learning Management System</h4>
						</div>
						<div class="card-body">

							<asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />
							<asp:Label ID="lblSuccess" runat="server" CssClass="text-success" Visible="false" />

							<div class="mb-3">
								<label class="form-label">Username</label>
								<asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username" />
							</div>
							<div class="mb-3">
								<label class="form-label">Password</label>
								<asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
									TextMode="Password" placeholder="Enter password" />
							</div>
							<asp:Button ID="btnLogin" runat="server" Text="Login"
								CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />

							<div class="mt-3 text-center">
								<a href="Register.aspx">Don't have an account? Register</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
