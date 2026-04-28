"""
Generates SystemDocumentation.docx for the OS-LMS project.
Plain ASCII symbols only - no em-dashes, en-dashes, or box-drawing characters.
"""

from docx import Document
from docx.shared import Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_ALIGN_VERTICAL
from docx.oxml.ns import qn
from docx.oxml import OxmlElement


def set_cell_shading(cell, hex_color):
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), hex_color)
    tc_pr.append(shd)


def add_heading(doc, text, level=1):
    h = doc.add_heading(text, level=level)
    for run in h.runs:
        run.font.color.rgb = RGBColor(0x1F, 0x3A, 0x68)
    return h


def add_para(doc, text, bold=False, size=11):
    p = doc.add_paragraph()
    run = p.add_run(text)
    run.font.size = Pt(size)
    run.bold = bold
    return p


def add_bullet(doc, text):
    return doc.add_paragraph(text, style="List Bullet")


def add_numbered(doc, text):
    return doc.add_paragraph(text, style="List Number")


def add_kv_table(doc, rows):
    """Two column key/value table."""
    tbl = doc.add_table(rows=len(rows), cols=2)
    tbl.style = "Light Grid Accent 1"
    for i, (k, v) in enumerate(rows):
        tbl.rows[i].cells[0].text = k
        tbl.rows[i].cells[1].text = v
        for run in tbl.rows[i].cells[0].paragraphs[0].runs:
            run.bold = True
    tbl.autofit = True
    return tbl


def add_table(doc, headers, rows):
    tbl = doc.add_table(rows=1 + len(rows), cols=len(headers))
    tbl.style = "Light Grid Accent 1"
    for j, h in enumerate(headers):
        cell = tbl.rows[0].cells[j]
        cell.text = h
        set_cell_shading(cell, "1F3A68")
        for p in cell.paragraphs:
            for r in p.runs:
                r.bold = True
                r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
    for i, row in enumerate(rows, start=1):
        for j, val in enumerate(row):
            tbl.rows[i].cells[j].text = str(val)
    return tbl


# ----- Build document -----------------------------------------------------

doc = Document()

# Page margins
for section in doc.sections:
    section.left_margin = Inches(1)
    section.right_margin = Inches(1)
    section.top_margin = Inches(0.9)
    section.bottom_margin = Inches(0.9)

# Title page
title = doc.add_paragraph()
title.alignment = WD_ALIGN_PARAGRAPH.CENTER
title_run = title.add_run("Integrated OS Learning Management System")
title_run.bold = True
title_run.font.size = Pt(22)
title_run.font.color.rgb = RGBColor(0x1F, 0x3A, 0x68)

subtitle = doc.add_paragraph()
subtitle.alignment = WD_ALIGN_PARAGRAPH.CENTER
sub_run = subtitle.add_run("System Documentation")
sub_run.font.size = Pt(14)
sub_run.italic = True

doc.add_paragraph()

meta = doc.add_paragraph()
meta.alignment = WD_ALIGN_PARAGRAPH.CENTER
meta.add_run("Group 7\n").bold = True
meta.add_run("Document version: 1.0\n")
meta.add_run("Last updated: April 2026")

doc.add_page_break()

# ----- 1. Project Overview -----
add_heading(doc, "1. Project Overview", 1)
add_para(
    doc,
    "The Integrated OS Learning Management System (OS-LMS) is a web-based educational tool "
    "that lets students simulate three core operating system topics: CPU scheduling, memory "
    "management, and deadlock detection. Each module accepts user-defined inputs, runs the "
    "selected algorithm, and displays a step-by-step result so students can see how the "
    "algorithm behaves before, during, and after execution.",
)
add_para(
    doc,
    "The system is built on ASP.NET WebForms with all algorithm logic running server-side "
    "in C#. There is no client-side JavaScript or jQuery; every interaction is a server "
    "postback. Output is rendered as plain HTML tables so it is easy to read and inspect.",
)

add_heading(doc, "1.1 Goals", 2)
add_bullet(doc, "Help students visualise how OS scheduling and memory algorithms work.")
add_bullet(doc, "Provide a single account-based platform that saves a history of past simulations.")
add_bullet(doc, "Keep the implementation simple and server-side so the code is easy to read for learning.")
add_bullet(doc, "Avoid framework-heavy front-end tooling; use plain Bootstrap and ASP.NET WebForms only.")

# ----- 2. Technology Stack -----
add_heading(doc, "2. Technology Stack", 1)
add_kv_table(doc, [
    ("Language", "C# 7.3"),
    ("Framework", ".NET Framework 4.7.2"),
    ("Web Framework", "ASP.NET WebForms"),
    ("Front-end", "Bootstrap 5.2.3 + custom dark theme CSS"),
    ("Data Access", "ADO.NET (System.Data.SqlClient)"),
    ("Database", "SQL Server LocalDB (MSSQLLocalDB)"),
    ("Authentication", "Forms Authentication + Session state"),
    ("Password Hashing", "PBKDF2 via System.Web.Helpers.Crypto"),
    ("Web Server", "IIS Express (development), port 5050"),
    ("Build", "MSBuild via Visual Studio 2022"),
])

# ----- 3. System Architecture -----
add_heading(doc, "3. System Architecture", 1)
add_para(
    doc,
    "The system follows a classic three-tier WebForms layout: presentation pages (.aspx), "
    "business and algorithm logic (Models/), and a relational database accessed through a "
    "single helper class.",
)

add_heading(doc, "3.1 Layers", 2)
add_kv_table(doc, [
    ("Presentation", "ASP.NET WebForms pages under Pages/, sharing AppMaster.master."),
    ("Algorithms", "Pure C# classes in Models/ (CpuAlgorithms, MemoryAlgorithms, BankersAlgorithm)."),
    ("Data Access", "Models/DataHelper.cs uses ADO.NET with parameterised SQL only."),
    ("Storage", "SQL Server LocalDB instance, database name iolsms_db."),
])

add_heading(doc, "3.2 Request Flow", 2)
add_numbered(doc, "User opens a page in the browser; ASP.NET runs Page_Init then Page_Load.")
add_numbered(doc, "Page renders HTML using Bootstrap and the dark theme; ViewState carries control state.")
add_numbered(doc, "User fills in input fields and clicks a button; the form posts back to the same page.")
add_numbered(doc, "Server restores ViewState, fires the button event, runs the algorithm, and rebinds output controls.")
add_numbered(doc, "If the user clicks Save, DataHelper writes a row to the simulations and results tables.")

# ----- 4. Modules -----
add_heading(doc, "4. Modules", 1)

add_heading(doc, "4.1 CPU Scheduling", 2)
add_para(doc, "Page: Pages/CpuScheduling.aspx", bold=True)
add_para(
    doc,
    "Lets the user enter a list of processes (PID, Arrival, Burst, Priority), pick an "
    "algorithm, and run a non-preemptive scheduling simulation. The result is a Gantt "
    "chart and a per-process metrics table.",
)
add_para(doc, "Algorithms supported:", bold=True)
add_bullet(doc, "FCFS - First Come First Served. Runs each process in arrival order.")
add_bullet(doc, "SJF - Shortest Job First. Among ready processes, runs the one with the smallest burst.")
add_bullet(doc, "Round Robin - Each ready process gets a fixed time quantum, then goes to the back of the queue.")
add_bullet(doc, "Priority - Among ready processes, runs the one with the lowest priority number.")
add_para(doc, "Outputs:", bold=True)
add_bullet(doc, "Gantt chart showing which process runs in each time slice.")
add_bullet(doc, "Per-process Start, Finish, Turnaround (Finish - Arrival), and Waiting (Turnaround - Burst).")
add_bullet(doc, "Average Turnaround and Average Waiting across all processes.")

add_heading(doc, "4.2 Memory Management", 2)
add_para(doc, "Page: Pages/MemoryManagement.aspx", bold=True)
add_para(
    doc,
    "Lets the user enter a set of memory blocks and a set of process sizes, then choose an "
    "allocation strategy. The result is a memory map showing which block holds which process "
    "plus a per-process allocation table including internal fragmentation.",
)
add_para(doc, "Strategies supported:", bold=True)
add_bullet(doc, "First Fit - place the process in the first free block that is big enough.")
add_bullet(doc, "Best Fit - place it in the smallest free block that fits.")
add_bullet(doc, "Worst Fit - place it in the largest free block.")
add_bullet(doc, "Paging - split memory into fixed-size frames and processes into equal-size pages; pages can land in any free frame.")
add_para(doc, "Outputs:", bold=True)
add_bullet(doc, "Memory map table (block number, size, allocated process or Free).")
add_bullet(doc, "Allocation results showing which block each process got, block size, and internal fragmentation.")

add_heading(doc, "4.3 Deadlock Detection (Banker's Algorithm)", 2)
add_para(doc, "Page: Pages/Deadlock.aspx", bold=True)
add_para(
    doc,
    "Lets the user define n processes and m resource types, fill in the Total Resources, "
    "Allocation matrix, and Max matrix, and run the Banker's Algorithm to determine whether "
    "the current state is safe.",
)
add_para(doc, "Algorithm steps:", bold=True)
add_numbered(doc, "Compute Need[i][j] = Max[i][j] - Allocation[i][j] for every process i and resource j.")
add_numbered(doc, "Compute Available[j] = Total[j] - sum over all i of Allocation[i][j].")
add_numbered(doc, "Repeatedly find a process whose Need <= Available; mark it finished and add its Allocation back to Available.")
add_numbered(doc, "If every process can be finished this way the state is SAFE; otherwise UNSAFE.")
add_para(doc, "Outputs:", bold=True)
add_bullet(doc, "SAFE / UNSAFE verdict with the safe sequence (if any).")
add_bullet(doc, "Need matrix.")
add_bullet(doc, "Step-by-step table showing Work before / Work after for each process that finishes.")
add_bullet(doc, "Friendly error message if the user enters Allocation values larger than Max, etc.")

# ----- 5. Database -----
add_heading(doc, "5. Database", 1)
add_para(doc, "Connection: (LocalDB)\\MSSQLLocalDB, database iolsms_db.")
add_para(doc, "Three tables; primary keys are explicit integers (no IDENTITY) calculated as MAX(id)+1.")

add_heading(doc, "5.1 users", 2)
add_table(doc, ["Column", "Type", "Notes"], [
    ("UserID", "INT, PK", "Generated server-side"),
    ("Username", "VARCHAR", "Unique account name"),
    ("Password", "VARCHAR", "PBKDF2 hash from Crypto.HashPassword"),
])

add_heading(doc, "5.2 simulations", 2)
add_table(doc, ["Column", "Type", "Notes"], [
    ("SimulationID", "INT, PK", "Generated server-side"),
    ("UserID", "INT, FK -> users.UserID", "Owner of the saved simulation"),
    ("ModuleType", "INT", "1 = CPU, 2 = Memory, 3 = Deadlock"),
])

add_heading(doc, "5.3 results", 2)
add_table(doc, ["Column", "Type", "Notes"], [
    ("ResultID", "INT, PK", "Generated server-side"),
    ("SimulationID", "INT, FK -> simulations.SimulationID", "Result is bound to a simulation"),
    ("DataOutput", "VARCHAR(255)", "Serialised summary of the simulation output"),
])

# ----- 6. Authentication & Security -----
add_heading(doc, "6. Authentication and Security", 1)
add_heading(doc, "6.1 Login Flow", 2)
add_numbered(doc, "User submits Username and Password on Pages/Login.aspx.")
add_numbered(doc, "Server fetches the user row and verifies the password using Crypto.VerifyHashedPassword.")
add_numbered(doc, "On success, FormsAuthentication.SetAuthCookie issues a cookie and Session[UserId] is set.")
add_numbered(doc, "User is redirected to Pages/Dashboard.aspx.")
add_heading(doc, "6.2 Authorisation", 2)
add_bullet(doc, "Web.config denies anonymous users globally; only Login.aspx, Register.aspx, and Default.aspx are unauthenticated.")
add_bullet(doc, "Every page checks User.Identity.IsAuthenticated in Page_Load and redirects to Login if not signed in.")
add_heading(doc, "6.3 Password Storage", 2)
add_bullet(doc, "Passwords are hashed with PBKDF2 (System.Web.Helpers.Crypto) before being stored.")
add_bullet(doc, "Verification uses constant-time hash comparison through the same library.")
add_bullet(doc, "Plaintext passwords are never logged or persisted.")
add_heading(doc, "6.4 ViewState Protection", 2)
add_bullet(doc, "A fixed machineKey in Web.config keeps ViewState valid across application restarts.")
add_bullet(doc, "Validation uses HMAC-SHA256, encryption uses AES.")
add_bullet(doc, "Application_Error in Global.asax catches stale ViewState exceptions and redirects to a fresh GET of the same page.")
add_heading(doc, "6.5 SQL Injection", 2)
add_bullet(doc, "All SQL queries in DataHelper.cs use parameterised SqlCommand with AddWithValue.")
add_bullet(doc, "No string concatenation of user input into SQL.")

# ----- 7. User Interface -----
add_heading(doc, "7. User Interface", 1)
add_para(
    doc,
    "The interface uses a fixed dark theme defined in Content/dark.css. The master page "
    "AppMaster.master provides a top navbar with links to Dashboard, CPU Scheduling, Memory "
    "Management, Deadlock, and Gantt Chart pages, plus a Logout button.",
)
add_heading(doc, "7.1 Help System", 2)
add_para(
    doc,
    "Each module page has a circular ? button next to the title. Clicking it opens a CSS-only "
    "modal popup (using the :target pseudo-class and URL fragments) that explains what the "
    "module does, what each input means, and how to interpret the results. No JavaScript is used.",
)
add_heading(doc, "7.2 Cache Busting", 2)
add_para(
    doc,
    "The dark.css link is generated by the master page code-behind with a query string equal "
    "to the file's last write time in ticks. Whenever the CSS changes, the URL changes, and "
    "browsers fetch the new file instead of serving a cached copy.",
)

# ----- 8. File Structure -----
add_heading(doc, "8. File Structure", 1)
files_table = add_table(doc, ["Path", "Purpose"], [
    ("Pages/Login.aspx", "Login page (no master)"),
    ("Pages/Register.aspx", "Account creation page (no master)"),
    ("Pages/Dashboard.aspx", "Stats overview and recent simulations"),
    ("Pages/CpuScheduling.aspx", "CPU scheduling simulator UI"),
    ("Pages/MemoryManagement.aspx", "Memory allocation simulator UI"),
    ("Pages/Deadlock.aspx", "Banker's Algorithm UI"),
    ("Pages/GanttChart.aspx", "Project timeline reference page"),
    ("AppMaster.master", "Shared layout: navbar, head, container body"),
    ("Models/CpuAlgorithms.cs", "FCFS, SJF, Round Robin, Priority"),
    ("Models/MemoryAlgorithms.cs", "First / Best / Worst Fit and Paging"),
    ("Models/BankersAlgorithm.cs", "Banker's safety check"),
    ("Models/DataHelper.cs", "ADO.NET helper for users, simulations, results"),
    ("Models/User.cs, Simulation.cs, Result.cs, ProcessInput.cs", "Plain data classes (some [Serializable])"),
    ("Content/dark.css", "Dark theme + help modal + Gantt styles"),
    ("Content/bootstrap.min.css", "Bootstrap 5 base styling"),
    ("Web.config", "Auth, machineKey, connection string"),
    ("Global.asax(.cs)", "Application_Start and Application_Error"),
])

# ----- 9. How to Run -----
add_heading(doc, "9. How to Run Locally", 1)
add_numbered(doc, "Open IOSMSystem.sln in Visual Studio 2022.")
add_numbered(doc, "Make sure SQL Server LocalDB is installed; the connection string targets (LocalDB)\\MSSQLLocalDB.")
add_numbered(doc, "Build the project (MSBuild generates bin/IOSMSystem.dll).")
add_numbered(doc, "Run with IIS Express on port 5050; the browser opens at /Pages/Login.aspx.")
add_numbered(doc, "Register a new account, log in, then pick a module from the navbar.")

# ----- 10. Known Limitations -----
add_heading(doc, "10. Known Limitations", 1)
add_bullet(doc, "Single-server LocalDB; no production database scaling.")
add_bullet(doc, "Forms Authentication cookie is HTTP only; no HTTPS enforcement in dev config.")
add_bullet(doc, "All scheduling algorithms are non-preemptive (Round Robin uses time slicing but no priority preemption).")
add_bullet(doc, "Saved simulation output is a 255-character serialised summary, not the full result tree.")
add_bullet(doc, "No client-side validation; everything is server-side, so feedback requires a postback.")

# ----- 11. Glossary -----
add_heading(doc, "11. Glossary", 1)
add_table(doc, ["Term", "Meaning"], [
    ("Arrival Time", "Time at which a process enters the ready queue."),
    ("Burst Time", "Total CPU time a process needs."),
    ("Turnaround Time", "Finish - Arrival; total time the process spent in the system."),
    ("Waiting Time", "Turnaround - Burst; time spent waiting, not running."),
    ("Quantum", "Fixed time slice given to each process under Round Robin."),
    ("Internal Fragmentation", "Wasted space inside an allocated block or page."),
    ("External Fragmentation", "Free memory split into pieces too small to satisfy any new request."),
    ("Page", "Fixed-size chunk of a process under paging."),
    ("Frame", "Fixed-size slot in physical memory under paging."),
    ("Allocation Matrix", "How many of each resource each process currently holds."),
    ("Max Matrix", "The maximum each process may ever request."),
    ("Need Matrix", "Max - Allocation; what each process still might need."),
    ("Safe State", "There exists an order in which every process can finish without deadlock."),
    ("Unsafe State", "No such order exists; deadlock may occur."),
    ("PBKDF2", "Password-Based Key Derivation Function 2; standard slow password hash."),
    ("ViewState", "Hidden form field that carries control state across postbacks."),
])

out = "E:\\IOSMSystem\\Documentation\\SystemDocumentation.docx"
doc.save(out)
print("Saved:", out)
