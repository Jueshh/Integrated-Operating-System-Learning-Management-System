<%@ Page Title="Gantt Chart" Language="C#" MasterPageFile="~/AppMaster.master" AutoEventWireup="true" CodeBehind="GanttChart.aspx.cs" Inherits="IOSMSystem.GanttChart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h4 class="mb-3">Gantt Chart - Integrated OS Learning Management System</h4>

    <div class="d-flex gap-4 mb-3 small align-items-center">
        <span><span class="gantt-swatch gantt-start"></span>Start</span>
        <span><span class="gantt-swatch gantt-progress"></span>In Progress</span>
        <span><span class="gantt-swatch gantt-end"></span>End</span>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-sm text-center align-middle gantt-table">
            <thead>
                <tr class="gantt-head-month">
                    <th rowspan="2" class="text-start gantt-col-id">Task ID</th>
                    <th rowspan="2" class="text-start gantt-col-name">Task Name</th>
                    <th rowspan="2" class="gantt-col-date">Start Date</th>
                    <th rowspan="2" class="gantt-col-date">End Date</th>
                    <th colspan="4">MARCH 2026</th>
                    <th colspan="5">APRIL 2026</th>
                </tr>
                <tr class="gantt-head-week">
                    <th>W2</th><th>W3</th><th>W4</th><th>W5</th>
                    <th>W1</th><th>W2</th><th>W3</th><th>W4</th><th>W5</th>
                </tr>
            </thead>
            <tbody>

                <%-- T01 SYSTEM PLANNING & DESIGN --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T01</td>
                    <td class="text-start">SYSTEM PLANNING &amp; DESIGN</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T01.1</td><td class="text-start">Plan System Design &amp; Goals</td>
                    <td>3/25/26</td><td>3/26/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T01.2</td><td class="text-start">Identify Modules (CPU, Memory, Deadlock)</td>
                    <td>3/25/26</td><td>3/26/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T01.3</td><td class="text-start">Create System Workflow</td>
                    <td>3/25/26</td><td>3/26/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T01.4</td><td class="text-start">Design UI Layout (Wireframe)</td>
                    <td>3/25/26</td><td>3/26/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T01.5</td><td class="text-start">Design Database</td>
                    <td>3/25/26</td><td>3/26/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T02 DATABASE DEVELOPMENT --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T02</td>
                    <td class="text-start">DATABASE DEVELOPMENT</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T02.1</td><td class="text-start">Create Users Table</td>
                    <td>3/27/26</td><td>3/28/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T02.2</td><td class="text-start">Create Simulations Table</td>
                    <td>3/27/26</td><td>3/28/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T02.3</td><td class="text-start">Create Results Table</td>
                    <td>3/27/26</td><td>3/28/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T02.4</td><td class="text-start">Setup Database Connection</td>
                    <td>3/27/26</td><td>3/28/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T03 USER AUTHENTICATION --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T03</td>
                    <td class="text-start">USER AUTHENTICATION</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T03.1</td><td class="text-start">Create Register Page</td>
                    <td>3/28/26</td><td>3/29/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T03.2</td><td class="text-start">Create Login Page</td>
                    <td>3/28/26</td><td>3/29/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T03.3</td><td class="text-start">Backend Authentication Logic</td>
                    <td>3/28/26</td><td>3/29/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T03.4</td><td class="text-start">Session Handling</td>
                    <td>3/28/26</td><td>3/29/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T04 MODULE DEVELOPMENT --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T04</td>
                    <td class="text-start">MODULE DEVELOPMENT</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T04.1</td><td class="text-start">CPU Scheduling Module</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T04.2</td><td class="text-start">Memory Management Module</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T04.3</td><td class="text-start">Deadlock Simulation Module</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T05 SIMULATION FEATURES --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T05</td>
                    <td class="text-start">SIMULATION FEATURES</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T05.1</td><td class="text-start">Input Forms (All Modules)</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T05.2</td><td class="text-start">Algorithm Processing Logic</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T05.3</td><td class="text-start">Output Visualization</td>
                    <td>3/28/26</td><td>3/30/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-end"></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T06 UI/UX DESIGN --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T06</td>
                    <td class="text-start">UI/UX DESIGN (HTML/CSS)</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T06.1</td><td class="text-start">Dashboard Design</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T06.2</td><td class="text-start">Module Pages Styling</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T06.3</td><td class="text-start">Responsive Design</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T07 TESTING & FINALIZATION --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T07</td>
                    <td class="text-start">TESTING &amp; FINALIZATION</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T07.1</td><td class="text-start">System Testing</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T07.2</td><td class="text-start">Bug Fixing</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T07.3</td><td class="text-start">Final Deployment</td>
                    <td>3/28/26</td><td>4/6/26</td>
                    <td></td><td></td><td class="gantt-start"></td><td class="gantt-progress"></td>
                    <td class="gantt-end"></td><td></td><td></td><td></td><td></td>
                </tr>

                <%-- T08 POLISH & UX REFINEMENTS --%>
                <tr class="gantt-parent fw-bold">
                    <td class="text-start">T08</td>
                    <td class="text-start">POLISH &amp; UX REFINEMENTS</td>
                    <td></td><td></td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td></td><td></td><td></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T08.1</td><td class="text-start">Help System (? Popups Across All Pages)</td>
                    <td>4/7/26</td><td>4/26/26</td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td class="gantt-start"></td><td class="gantt-progress"></td><td class="gantt-end"></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T08.2</td><td class="text-start">Theme &amp; Styling Fixes (Dark Mode, Cache-Busting)</td>
                    <td>4/7/26</td><td>4/26/26</td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td class="gantt-start"></td><td class="gantt-progress"></td><td class="gantt-end"></td><td></td>
                </tr>
                <tr>
                    <td class="text-start">T08.3</td><td class="text-start">Stability Fixes (ViewState Handler, Null-Ref, Empty States)</td>
                    <td>4/7/26</td><td>4/26/26</td>
                    <td></td><td></td><td></td><td></td>
                    <td></td><td class="gantt-start"></td><td class="gantt-progress"></td><td class="gantt-end"></td><td></td>
                </tr>

            </tbody>
        </table>
    </div>

</asp:Content>
