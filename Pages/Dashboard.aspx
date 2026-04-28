<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
    Inherits="IOSMSystem.Dashboard" MasterPageFile="~/AppMaster.master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center mb-1">
        <h3 class="page-title mb-0 me-2">Dashboard</h3>
        <a href="#dash-help" class="help-btn" title="What is this?" aria-label="Help">?</a>
    </div>
    <div class="page-title-bar bar-dashboard"></div>

    <div class="row mb-4 g-3">
        <div class="col-md-3">
            <div class="card text-center stat-card-total">
                <div class="card-body py-3">
                    <p class="stat-label mb-1">Total Simulations</p>
                    <p class="stat-number text-primary-custom mb-0"><asp:Label ID="lblTotal" runat="server" Text="0" /></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center stat-card-cpu">
                <div class="card-body py-3">
                    <p class="stat-label mb-1">CPU Scheduling</p>
                    <p class="stat-number text-accent mb-0"><asp:Label ID="lblCpu" runat="server" Text="0" /></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center stat-card-memory">
                <div class="card-body py-3">
                    <p class="stat-label mb-1">Memory Management</p>
                    <p class="stat-number text-info-custom mb-0"><asp:Label ID="lblMemory" runat="server" Text="0" /></p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center stat-card-deadlock">
                <div class="card-body py-3">
                    <p class="stat-label mb-1">Deadlock</p>
                    <p class="stat-number text-warning-custom mb-0"><asp:Label ID="lblDeadlock" runat="server" Text="0" /></p>
                </div>
            </div>
        </div>
    </div>

    <h5>Recent Simulations</h5>
    <asp:GridView ID="gvRecent" runat="server" CssClass="table table-bordered table-striped"
        AutoGenerateColumns="false" EmptyDataText="No simulations yet.">
        <Columns>
            <asp:BoundField  DataField="SimulationID" HeaderText="#" />
            <asp:BoundField  DataField="ModuleName"   HeaderText="Module" />
        </Columns>
    </asp:GridView>

    <%-- Help popup --%>
    <div id="dash-help" class="help-modal" role="dialog" aria-labelledby="dash-help-title">
        <a href="#!" class="help-modal-backdrop" aria-label="Close"></a>
        <div class="help-modal-card">
            <div class="help-modal-header">
                <h5 id="dash-help-title" class="mb-0">About the Dashboard</h5>
                <a href="#!" class="help-modal-close" aria-label="Close">&times;</a>
            </div>
            <div class="help-modal-body small">
                <p>
                    The <strong>Dashboard</strong> shows a quick summary of how often you have used each
                    OS simulator, plus the most recent simulations you have saved.
                </p>
                <p class="mb-1"><strong>The four cards count:</strong></p>
                <ul class="ps-3">
                    <li><strong>Total Simulations</strong> - everything you have ever saved.</li>
                    <li><strong>CPU Scheduling</strong> - simulations from the CPU page.</li>
                    <li><strong>Memory Management</strong> - simulations from the Memory page.</li>
                    <li><strong>Deadlock</strong> - Banker's Algorithm runs you saved.</li>
                </ul>
                <p class="mb-0">
                    The <strong>Recent Simulations</strong> table lists your latest saves with their
                    simulation ID and which module they came from. Use the navbar to open a module and run a new one.
                </p>
            </div>
            <div class="help-modal-footer">
                <a href="#!" class="btn btn-primary btn-sm">Got it</a>
            </div>
        </div>
    </div>

</asp:Content>
