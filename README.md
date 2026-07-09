# AMBA APB Functional Verification Environment 🚀

An advanced, Object-Oriented SystemVerilog testbench for verifying an AMBA Advanced Peripheral Bus (APB) Slave RAM module. This project demonstrates industry-standard verification techniques, including constrained random generation, modular OOP architecture, and functional coverage tracking using Cadence Xcelium.

## 📌 Project Overview
This repository contains a complete verification environment built from scratch without utilizing UVM macros. It relies on pure SystemVerilog mechanics (Classes, Mailboxes, Interfaces, and Events) to stimulate, monitor, and verify an APB memory peripheral. 

### Key Features:
* **Object-Oriented Architecture:** Complete separation of Generator, Driver, Monitor, Scoreboard, and Coverage components.
* **Dual-Mailbox Broadcasting:** Custom plumbing to allow simultaneous transaction broadcasting to the Scoreboard and Coverage collectors.
* **Constrained Randomization:** Intelligent transaction generation focusing on boundary conditions and valid/invalid memory spaces.
* **Native Coverage Extraction:** Bypasses proprietary coverage GUIs by utilizing SystemVerilog's built-in `.get_inst_coverage()` method to print mathematical coverage statistics directly to the simulation console.

---

## 📂 Directory Structure

```text
├── rtl/
│   └── design.sv             # AMBA APB Slave RAM RTL Design
├── tb/
│   ├── apb_if.sv             # APB Interface with Clocking Blocks
│   ├── apb_pkg.sv            # Compilation Package
│   ├── transaction.svh       # Stimulus blueprint & constraints
│   ├── generator.svh         # Constrained random stimulus generator
│   ├── driver.svh            # Pin-level protocol driver
│   ├── monitor.svh           # Bus observer and transaction broadcaster
│   ├── scoreboard.svh        # Reference model and data checking
│   ├── apb_coverage.svh      # Functional coverage metrics & printing
│   ├── environment.svh       # Top-level component instantiation
│   └── testbench.sv          # Top module and clock generation
└── README.md
```

---

## 🛠️ Tools & Technologies
* **Language:** SystemVerilog (IEEE 1800-2012)
* **Simulator:** Cadence Xcelium
* **Waveform Viewer:** EPWave / GTKWave (.vcd dump)

---

## 🚀 How to Run (Cadence Xcelium Flow)

### 1. Web-Based Execution (EDA Playground)
This environment is optimized for quick execution using Cadence Xcelium on EDA Playground.
1. Ensure the simulator is set to **Cadence Xcelium**.
2. Add the following to the **Compile Options** to enable the coverage engine:
   `-coverage all`
3. Execute the run. The custom coverage class will automatically calculate and print the total functional coverage percentage to the console log at the end of the simulation.

### 2. Linux Terminal Execution
To run this in a standard Linux terminal using Cadence `xrun`, execute the following single-step compilation and simulation command:
```bash
xrun -sv design.sv tb/apb_pkg.sv tb/testbench.sv -coverage all
```

---

## 📊 Coverage Model Definition
The custom `slave_ram_cov_grp` covergroup guarantees 100% functional coverage by tracking:
* **Write vs. Read Operations:** Ensures both single and back-to-back operations are tested.
* **Segmented Memory Map:** Validates stimulus across `lower_half` [0x00:0x1FC] and `upper_half` [0x200:0x3FC] addresses using hexadecimal boundaries.
* **Protocol Violations:** Verifies the `PSLVERR` (Slave Error) signal correctly asserts during out-of-bounds memory accesses [> 0x400].
