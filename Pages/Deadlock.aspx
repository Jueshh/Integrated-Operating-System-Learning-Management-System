<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Deadlock.aspx.cs"
    Inherits="IOSMSystem.Deadlock" MasterPageFile="~/AppMaster.master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center mb-1">
        <h3 class="page-title mb-0 me-2">Deadlock Detection - Banker's Algorithm</h3>
        <a href="#deadlock-help" class="help-btn" title="What is this?" aria-label="Help">?</a>
    </div>
    <div class="page-title-bar bar-deadlock"></div>

    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header"><strong>System Configuration</strong></div>
                <div class="card-body">

                    <div class="row mb-2">
                        <div class="col">
                            <label class="form-label">Number of Processes (n)</label>
                            <asp:TextBox ID="txtN" runat="server" CssClass="form-control"
                                Text="5" Width="80px" />
                        </div>
                        <div class="col">
                            <label class="form-label">Resource Types (m)</label>
                            <asp:TextBox ID="txtM" runat="server" CssClass="form-control"
                                Text="3" Width="80px" />
                        </div>
                    </div>

                    <asp:Button ID="btnBuild" runat="server" Text="Build Tables"
                        CssClass="btn btn-secondary mb-3" OnClick="btnBuild_Click" />

                    <asp:HiddenField ID="hdnN" runat="server" Value="5" />
                    <asp:HiddenField ID="hdnM" runat="server" Value="3" />

                    <asp:Panel ID="pnlTables" runat="server" Visible="false">

                        <div class="mb-3">
                            <label class="form-label">
                                Total Resources (space-separated, <asp:Label ID="lblMLabel" runat="server" Text="3" /> values)
                            </label>
                            <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control"
                                placeholder="e.g. 10 5 7" />
                            <div class="form-text">
                                The total instances of each resource type that exist in the system.
                                Example: <code>10 5 7</code> means 10 of resource A, 5 of B, 7 of C.
                            </div>
                        </div>

                        <h6>Allocation Matrix</h6>
                        <div class="form-text mb-2">
                            How many units of each resource each process is <strong>currently holding</strong>.
                            Row = process, column = resource type.
                        </div>
                        <div class="table-responsive mb-3">
                            <asp:PlaceHolder ID="phAllocation" runat="server" />
                        </div>

                        <h6>Max Matrix</h6>
                        <div class="form-text mb-2">
                            The <strong>maximum</strong> units of each resource each process may ever request.
                            The system computes <em>Need = Max - Allocation</em> automatically.
                        </div>
                        <div class="table-responsive mb-3">
                            <asp:PlaceHolder ID="phMax" runat="server" />
                        </div>

                        <asp:Button ID="btnRun" runat="server" Text="Run Banker's Algorithm"
                            CssClass="btn btn-primary" OnClick="btnRun_Click" />

                        <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mt-2" Visible="false" />

                    </asp:Panel>
                </div>
            </div>

            <asp:Panel ID="pnlHistory" runat="server" Visible="false">
                <div class="card">
                    <div class="card-header"><strong>Saved Simulations</strong></div>
                    <div class="card-body p-2">
                        <asp:GridView ID="gvHistory" runat="server" CssClass="table table-sm table-bordered mb-0"
                            AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="SimulationID" HeaderText="#" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
        </div>

        <div class="col-md-6">
            <asp:Panel ID="pnlResults" runat="server" Visible="false">

                <div class="card mb-3">
                    <div class="card-header"><strong>Result</strong></div>
                    <div class="card-body">
                        <asp:Literal ID="litVerdict" runat="server" />
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header"><strong>Need Matrix (Max - Allocation)</strong></div>
                    <div class="card-body p-2">
                        <asp:Literal ID="litNeed" runat="server" />
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header"><strong>Safe Sequence Steps</strong></div>
                    <div class="card-body p-2">
                        <asp:GridView ID="gvSteps" runat="server"
                            CssClass="table table-bordered table-sm mb-0"
                            AutoGenerateColumns="false"
                            EmptyDataText="No safe sequence found - the system is in an unsafe state, so no order of processes can complete without deadlock.">
                            <Columns>
                                <asp:BoundField DataField="StepNo"     HeaderText="Step" />
                                <asp:BoundField DataField="Process"    HeaderText="Process" />
                                <asp:BoundField DataField="WorkBefore" HeaderText="Work Before" />
                                <asp:BoundField DataField="WorkAfter"  HeaderText="Work After" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save Simulation"
                    CssClass="btn btn-success" OnClick="btnSave_Click" />
                <asp:Label ID="lblSaved" runat="server" CssClass="text-success ms-2"
                    Visible="false" Text="Saved successfully!" />

            </asp:Panel>
        </div>
    </div>

    <%-- Help popup (CSS-only, opens via #deadlock-help fragment) --%>
    <div id="deadlock-help" class="help-modal" role="dialog" aria-labelledby="deadlock-help-title">
        <a href="#!" class="help-modal-backdrop" aria-label="Close"></a>
        <div class="help-modal-card">
            <div class="help-modal-header">
                <h5 id="deadlock-help-title" class="mb-0">Understanding Deadlock</h5>
                <a href="#!" class="help-modal-close" aria-label="Close">&times;</a>
            </div>
            <div class="help-modal-body small">
                <p>
                    A <strong>deadlock</strong> happens when a group of processes are each waiting
                    for a resource that another process in the group is holding - so none of them
                    can ever continue. Classic example: process P1 holds the printer and is waiting
                    for the scanner; process P2 holds the scanner and is waiting for the printer.
                    Neither will let go, both are stuck forever.
                </p>
                <p>
                    The <strong>Banker's Algorithm</strong> checks whether the current state of the
                    system is <em>safe</em> - meaning at least one ordering of processes exists
                    where every process can finish without anyone getting stuck. It treats the
                    OS like a bank that only lends money if it can still pay everyone back.
                </p>
                <p class="mb-1"><strong>Inputs you provide:</strong></p>
                <ul class="ps-3">
                    <li><strong>Total Resources</strong> - how many of each resource exist in total.</li>
                    <li><strong>Allocation</strong> - what each process currently holds.</li>
                    <li><strong>Max</strong> - the most each process could ever ask for.</li>
                </ul>
                <p class="mb-1"><strong>What the algorithm does:</strong></p>
                <ol class="ps-3">
                    <li>Computes <em>Available = Total - sum(Allocation)</em>.</li>
                    <li>Computes <em>Need = Max - Allocation</em>.</li>
                    <li>Repeatedly picks any process whose <em>Need &le; Available</em>,
                        pretends it finishes, and adds its <em>Allocation</em> back to Available.</li>
                    <li>If every process finishes this way, the state is <strong>SAFE</strong>
                        and the order picked is the <em>safe sequence</em>.
                        Otherwise the state is <strong>UNSAFE</strong> and a deadlock may occur.</li>
                </ol>
                <p class="mb-0">
                    <span class="badge bg-success">SAFE</span> = the system can satisfy all current
                    and future requests in some order.
                    <span class="badge bg-danger ms-1">UNSAFE</span> = no such order exists; granting
                    the current allocation puts the system at risk of deadlock.
                </p>
            </div>
            <div class="help-modal-footer">
                <a href="#!" class="btn btn-primary btn-sm">Got it</a>
            </div>
        </div>
    </div>

</asp:Content>
