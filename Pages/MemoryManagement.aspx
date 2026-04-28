<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemoryManagement.aspx.cs"
    Inherits="IOSMSystem.MemoryManagement" MasterPageFile="~/AppMaster.master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex align-items-center mb-1">
        <h3 class="page-title mb-0 me-2">Memory Management Simulator</h3>
        <a href="#mem-help" class="help-btn" title="What is this?" aria-label="Help">?</a>
    </div>
    <div class="page-title-bar bar-memory"></div>

    <div class="row">
        <div class="col-md-4">
            <div class="card mb-3">
                <div class="card-header"><strong>Configuration</strong></div>
                <div class="card-body">

                    <div class="mb-2">
                        <label class="form-label">Strategy</label>
                        <asp:DropDownList ID="ddlStrategy" runat="server" CssClass="form-select">
                            <asp:ListItem Value="FirstFit">Contiguous - First Fit</asp:ListItem>
                            <asp:ListItem Value="BestFit">Contiguous - Best Fit</asp:ListItem>
                            <asp:ListItem Value="WorstFit">Contiguous - Worst Fit</asp:ListItem>
                            <asp:ListItem Value="Paging">Non-Contiguous - Paging</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Memory Blocks in KB (comma-separated)</label>
                        <asp:TextBox ID="txtBlocks" runat="server" CssClass="form-control"
                            Text="100,500,200,300,600" />
                        <small class="text-muted">Used for First/Best/Worst Fit</small>
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Process Sizes in KB (comma-separated)</label>
                        <asp:TextBox ID="txtProcesses" runat="server" CssClass="form-control"
                            Text="212,417,112,426" />
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Total Memory in KB (for Paging)</label>
                        <asp:TextBox ID="txtTotalMemory" runat="server" CssClass="form-control"
                            Text="64" Width="100px" />
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Page Size in KB (for Paging)</label>
                        <asp:TextBox ID="txtPageSize" runat="server" CssClass="form-control"
                            Text="4" Width="100px" />
                    </div>

                    <asp:Button ID="btnRun" runat="server" Text="Run Simulation"
                        CssClass="btn btn-primary" OnClick="btnRun_Click" />

                    <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mt-2" Visible="false" />
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

        <div class="col-md-8">
            <asp:Panel ID="pnlResults" runat="server" Visible="false">

                <div class="card mb-3">
                    <div class="card-header"><strong>Memory Map</strong></div>
                    <div class="card-body">
                        <asp:Literal ID="litMap" runat="server" />
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header"><strong>Allocation Results</strong></div>
                    <div class="card-body p-2">
                        <asp:GridView ID="gvResults" runat="server"
                            CssClass="table table-bordered table-sm mb-0"
                            AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="ProcessName"   HeaderText="Process" />
                                <asp:BoundField DataField="ProcessSize"   HeaderText="Size (KB)" />
                                <asp:BoundField DataField="BlockNo"       HeaderText="Block #" NullDisplayText="-" />
                                <asp:BoundField DataField="BlockSize"     HeaderText="Block Size (KB)" NullDisplayText="-" />
                                <asp:BoundField DataField="Fragmentation" HeaderText="Internal Frag (KB)" NullDisplayText="-" />
                                <asp:BoundField DataField="Allocated"     HeaderText="Status" />
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

    <%-- Help popup --%>
    <div id="mem-help" class="help-modal" role="dialog" aria-labelledby="mem-help-title">
        <a href="#!" class="help-modal-backdrop" aria-label="Close"></a>
        <div class="help-modal-card">
            <div class="help-modal-header">
                <h5 id="mem-help-title" class="mb-0">Understanding Memory Management</h5>
                <a href="#!" class="help-modal-close" aria-label="Close">&times;</a>
            </div>
            <div class="help-modal-body small">
                <p>
                    <strong>Memory Management</strong> decides where each process is loaded in RAM.
                    The OS keeps track of free and used memory and chooses a place for each new process.
                </p>
                <p class="mb-1"><strong>Strategies:</strong></p>
                <ul class="ps-3">
                    <li><strong>First Fit</strong> - put the process in the first free block big enough. Fast.</li>
                    <li><strong>Best Fit</strong> - put it in the smallest free block that fits. Less waste, but more searching.</li>
                    <li><strong>Worst Fit</strong> - put it in the largest free block. Leaves big leftovers for future processes.</li>
                    <li><strong>Paging</strong> - split memory into fixed-size <em>frames</em> and processes into equal-size <em>pages</em>.
                        Pages can be placed in any free frame, so external fragmentation disappears.</li>
                </ul>
                <p class="mb-1"><strong>Inputs you provide:</strong></p>
                <ul class="ps-3">
                    <li><strong>Block Sizes</strong> - sizes of free memory blocks (contiguous strategies).</li>
                    <li><strong>Process Sizes</strong> - sizes of processes that need memory.</li>
                    <li><strong>Total Memory &amp; Page Size</strong> - used by Paging only.</li>
                </ul>
                <p class="mb-0">
                    <strong>Internal Fragmentation</strong> = block size - process size (or page size - last page used).
                    Wasted space inside an allocated chunk that no other process can use.
                </p>
            </div>
            <div class="help-modal-footer">
                <a href="#!" class="btn btn-primary btn-sm">Got it</a>
            </div>
        </div>
    </div>

</asp:Content>
