<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CpuScheduling.aspx.cs"
    Inherits="IOSMSystem.CpuScheduling" MasterPageFile="~/AppMaster.master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center mb-1">
        <h3 class="page-title mb-0 me-2">CPU Scheduling Simulator</h3>
        <a href="#cpu-help" class="help-btn" title="What is this?" aria-label="Help">?</a>
    </div>
    <div class="page-title-bar bar-cpu"></div>

    <div class="row">
        <div class="col-md-5">
            <div class="card mb-3">
                <div class="card-header"><strong>Process Input</strong></div>
                <div class="card-body">

                    <div class="mb-2">
                        <label class="form-label">Algorithm</label>
                        <asp:DropDownList ID="ddlAlgorithm" runat="server" CssClass="form-select">
                            <asp:ListItem Value="FCFS">FCFS - First Come First Served</asp:ListItem>
                            <asp:ListItem Value="SJF">SJF - Shortest Job First</asp:ListItem>
                            <asp:ListItem Value="RR">Round Robin</asp:ListItem>
                            <asp:ListItem Value="Priority">Priority (Non-Preemptive)</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Time Quantum (for Round Robin)</label>
                        <asp:TextBox ID="txtQuantum" runat="server" CssClass="form-control"
                            Text="2" Width="80px" />
                    </div>

                    <table class="table table-sm table-bordered mt-2">
                        <thead class="table-light">
                            <tr>
                                <th>PID</th>
                                <th>Arrival</th>
                                <th>Burst</th>
                                <th>Priority</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptProcesses" runat="server"
                                OnItemCommand="rptProcesses_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtPID"     runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("PID") %>'      Width="55px" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtArrival" runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("Arrival") %>'  Width="55px" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtBurst"   runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("Burst") %>'    Width="55px" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtPriority" runat="server" CssClass="form-control form-control-sm"
                                                Text='<%# Eval("Priority") %>' Width="55px" />
                                        </td>
                                        <td>
                                            <asp:LinkButton runat="server" CommandName="Remove"
                                                CommandArgument='<%# Container.ItemIndex %>'
                                                CssClass="btn btn-sm btn-danger">X</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>

                    <asp:Button ID="btnAdd" runat="server" Text="+ Add Process"
                        CssClass="btn btn-secondary btn-sm me-2" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnRun" runat="server" Text="Run Simulation"
                        CssClass="btn btn-primary" OnClick="btnRun_Click" />

                </div>
            </div>

            <!-- History -->
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

        <!-- Results -->
        <div class="col-md-7">
            <asp:Panel ID="pnlResults" runat="server" Visible="false">
                <div class="card mb-3">
                    <div class="card-header"><strong>Gantt Chart</strong></div>
                    <div class="card-body">
                        <asp:Literal ID="litGantt" runat="server" />
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <strong>Results</strong>
                        <small>
                            Avg Turnaround: <asp:Label ID="lblAvgTAT" runat="server" CssClass="fw-bold" />
                            &nbsp;|&nbsp;
                            Avg Waiting: <asp:Label ID="lblAvgWT" runat="server" CssClass="fw-bold" />
                        </small>
                    </div>
                    <div class="card-body p-2">
                        <asp:GridView ID="gvResults" runat="server" CssClass="table table-bordered table-sm mb-0"
                            AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="PID"        HeaderText="Process" />
                                <asp:BoundField DataField="Arrival"    HeaderText="Arrival" />
                                <asp:BoundField DataField="Burst"      HeaderText="Burst" />
                                <asp:BoundField DataField="Start"      HeaderText="Start" />
                                <asp:BoundField DataField="Finish"     HeaderText="Finish" />
                                <asp:BoundField DataField="Turnaround" HeaderText="Turnaround" />
                                <asp:BoundField DataField="Waiting"    HeaderText="Waiting" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <asp:Button ID="btnSave" runat="server" Text="Save Simulation"
                    CssClass="btn btn-success" OnClick="btnSave_Click" />
                <asp:Label ID="lblSaved" runat="server" CssClass="text-success ms-2" Visible="false"
                    Text="Saved successfully!" />
            </asp:Panel>
        </div>
    </div>

    <%-- Help popup --%>
    <div id="cpu-help" class="help-modal" role="dialog" aria-labelledby="cpu-help-title">
        <a href="#!" class="help-modal-backdrop" aria-label="Close"></a>
        <div class="help-modal-card">
            <div class="help-modal-header">
                <h5 id="cpu-help-title" class="mb-0">Understanding CPU Scheduling</h5>
                <a href="#!" class="help-modal-close" aria-label="Close">&times;</a>
            </div>
            <div class="help-modal-body small">
                <p>
                    <strong>CPU Scheduling</strong> decides which process runs next on the CPU when multiple
                    processes are ready. Different strategies trade off fairness, throughput, and response time.
                </p>
                <p class="mb-1"><strong>Inputs you provide for each process:</strong></p>
                <ul class="ps-3">
                    <li><strong>PID</strong> - a label like P1, P2.</li>
                    <li><strong>Arrival</strong> - the time the process enters the ready queue.</li>
                    <li><strong>Burst</strong> - how much CPU time the process needs.</li>
                    <li><strong>Priority</strong> - lower number = higher priority (used by Priority).</li>
                </ul>
                <p class="mb-1"><strong>Algorithms:</strong></p>
                <ul class="ps-3">
                    <li><strong>FCFS</strong> - First Come, First Served. Runs in arrival order.</li>
                    <li><strong>SJF</strong> - Shortest Job First. Picks the ready process with the smallest burst.</li>
                    <li><strong>Round Robin</strong> - Each process gets a fixed <em>time quantum</em>, then goes back of the queue.</li>
                    <li><strong>Priority</strong> - Picks the ready process with the highest priority (lowest number).</li>
                </ul>
                <p class="mb-1"><strong>What you see:</strong></p>
                <ul class="ps-3">
                    <li><strong>Gantt Chart</strong> - visual timeline of which process ran when.</li>
                    <li><strong>Turnaround</strong> = Finish - Arrival. Total time in the system.</li>
                    <li><strong>Waiting</strong> = Turnaround - Burst. Time spent waiting, not running.</li>
                </ul>
            </div>
            <div class="help-modal-footer">
                <a href="#!" class="btn btn-primary btn-sm">Got it</a>
            </div>
        </div>
    </div>

</asp:Content>
