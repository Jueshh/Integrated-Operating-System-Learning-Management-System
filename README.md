# Integrated Operating System Learning Management System (OS-LMS)

A web-based educational platform that lets students simulate three core
operating system topics in one place: **CPU scheduling**, **memory management**,
and **deadlock detection** (Banker's Algorithm).

Built with ASP.NET WebForms on .NET Framework 4.7.2. All algorithm logic runs
server-side in C#; the front end is plain HTML + Bootstrap 5 with a custom dark
theme. No JavaScript or jQuery is used in the application.

---

## Features

- **CPU Scheduling Simulator** — FCFS, SJF, Round Robin, Priority. Renders a
  Gantt chart and per-process Turnaround / Waiting metrics.
- **Memory Management Simulator** — First Fit, Best Fit, Worst Fit, and Paging.
  Shows the memory map and allocation results with internal fragmentation.
- **Deadlock Detection** — Banker's Algorithm with Need matrix, safe-sequence
  table, and friendly error messages for invalid input.
- **User Accounts** — registration, login, and saved simulation history per
  user. Passwords are hashed with PBKDF2.
- **Help System** — every module page has a `?` button that opens a CSS-only
  modal popup explaining the inputs, algorithms, and outputs.
- **Project Gantt Chart** — built-in `Pages/GanttChart.aspx` showing project
  phases T01 through T08.

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| Language | C# 7.3 |
| Framework | .NET Framework 4.7.2 |
| Web Framework | ASP.NET WebForms |
| Front-end | Bootstrap 5.2.3 + custom dark theme |
| Data Access | ADO.NET (parameterised SQL only) |
| Database | SQL Server LocalDB (`MSSQLLocalDB`) |
| Authentication | Forms Authentication + Session state |
| Password Hashing | PBKDF2 via `System.Web.Helpers.Crypto` |
| Build | MSBuild via Visual Studio 2022 |

---

## Documentation

All project documentation lives in the [`Documentation/`](Documentation/) folder.

| File | Description |
|------|-------------|
| [`Documentation/SystemDocumentation.docx`](Documentation/SystemDocumentation.docx) | Full system documentation: architecture, modules, database, auth, file structure, glossary |
| [`Documentation/UseCaseDiagram.docx`](Documentation/UseCaseDiagram.docx) | Use Case Diagram with actors and use cases |
| [`Documentation/UseCaseDiagram.png`](Documentation/UseCaseDiagram.png) | Use Case Diagram (image) |
| [`Documentation/ERD.docx`](Documentation/ERD.docx) | Entity Relationship Diagram with crow's foot notation |
| [`Documentation/ERD.png`](Documentation/ERD.png) | Entity Relationship Diagram (image) |
| [`Documentation/Use case & ERD.docx`](Documentation/Use%20case%20%26%20ERD.docx) | Combined use case + ERD reference |
| [`Documentation/GanttChart.xlsx`](Documentation/GanttChart.xlsx) | Project timeline as a styled spreadsheet (T01 through T08) |

### Generator scripts

Python scripts that regenerate the docs from source:

- [`Documentation/generate_system_doc.py`](Documentation/generate_system_doc.py)
- [`Documentation/generate_usecase.py`](Documentation/generate_usecase.py)
- [`Documentation/generate_erd.py`](Documentation/generate_erd.py)
- [`Documentation/generate_gantt_xlsx.py`](Documentation/generate_gantt_xlsx.py)

Run with `python <script>.py` (requires `python-docx`, `openpyxl`,
and `matplotlib`).

---

## Project Structure

```
IOSMSystem/
├── Pages/
│   ├── Login.aspx                 # Login (no master)
│   ├── Register.aspx              # Account creation (no master)
│   ├── Dashboard.aspx             # Stats + recent simulations
│   ├── CpuScheduling.aspx         # CPU scheduling simulator
│   ├── MemoryManagement.aspx      # Memory allocation simulator
│   ├── Deadlock.aspx              # Banker's Algorithm
│   └── GanttChart.aspx            # Project timeline reference
├── Models/
│   ├── CpuAlgorithms.cs           # FCFS, SJF, Round Robin, Priority
│   ├── MemoryAlgorithms.cs        # First / Best / Worst Fit + Paging
│   ├── BankersAlgorithm.cs        # Safety check
│   ├── DataHelper.cs              # ADO.NET helper
│   ├── User.cs / Simulation.cs / Result.cs / ProcessInput.cs
├── Content/
│   ├── bootstrap.min.css
│   └── dark.css                   # Dark theme + help modal styles
├── Documentation/                 # All Word docs, diagrams, Gantt xlsx
├── AppMaster.master               # Shared layout (navbar, head)
├── Global.asax                    # App start + ViewState error handler
├── Web.config                     # Auth, machineKey, connection string
└── IOSMSystem.csproj
```

---

## Database Schema

Database name: `iolsms_db` (LocalDB).

| Table | Columns |
|-------|---------|
| `users` | `UserID` (PK), `Username`, `Password` (PBKDF2 hash) |
| `simulations` | `SimulationID` (PK), `UserID` (FK), `ModuleType` (1=CPU, 2=Memory, 3=Deadlock) |
| `results` | `ResultID` (PK), `SimulationID` (FK), `DataOutput` (VARCHAR 255) |

The schema is created automatically by `DataHelper.InitializeDatabase()` on
first run.

---

## Getting Started

### Prerequisites

- Visual Studio 2022 (Professional or Community) with the **.NET desktop
  development** workload
- **SQL Server LocalDB** (installed by default with Visual Studio)
- Windows 10 or 11

### Run locally

1. Clone the repository.
2. Open `IOSMSystem.sln` in Visual Studio 2022.
3. Build the solution (Ctrl + Shift + B).
4. Press F5 to run with IIS Express; the browser opens at
   `https://localhost:44347/Pages/Login.aspx` (or the port shown in the
   output).
5. Click **Register** to create an account, then log in.

The first run creates `iolsms_db` automatically in LocalDB.

---

## Modules

### CPU Scheduling

Inputs: list of processes (PID, Arrival, Burst, Priority) + algorithm choice.
Output: Gantt chart, per-process Start / Finish / Turnaround / Waiting,
Average TAT, Average WT.

### Memory Management

Inputs: free block sizes + process sizes + strategy. For Paging: total memory
+ page size + process sizes. Output: memory map + per-process allocation
table including internal fragmentation.

### Deadlock Detection (Banker's Algorithm)

Inputs: number of processes, number of resource types, total resources,
Allocation matrix, Max matrix. Output: SAFE / UNSAFE verdict, safe sequence,
Need matrix, step-by-step Work-before / Work-after table.

---

## Security

- Passwords hashed with PBKDF2 (`System.Web.Helpers.Crypto`).
- All SQL queries are parameterised; no string concatenation.
- Forms Authentication restricts access; only `Login.aspx`, `Register.aspx`,
  and `Default.aspx` are anonymous.
- Fixed `<machineKey>` in `Web.config` keeps ViewState valid across
  application restarts.
- `Global.asax` `Application_Error` catches stale ViewState exceptions and
  redirects to a fresh page instead of showing a stack trace.

---

## Known Limitations

- Single-server LocalDB; no production database scaling.
- All scheduling algorithms are non-preemptive (Round Robin uses time slicing
  only, no priority preemption).
- Saved simulation output is a 255-character serialised summary, not the full
  result tree.
- No client-side validation; everything is server-side.

---

## Authors

**Group 7** — Integrated Operating System Learning Management System
