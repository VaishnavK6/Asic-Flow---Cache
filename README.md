# ASIC Implementation of 4-Way Set-Associative Cache Memory

This project implements a synthesizable 4-way set-associative cache memory using Verilog, integrated with the OpenLane ASIC design flow for synthesis and physical design using the Sky130HD PDK.

## 📁 Project Structure

  ─ cache_memory.v # Core cache logic: tag comparison, data array, valid bit tracking
  ─ fifo_replacement.v # FIFO-based replacement policy for the cache
  ─ cache_top.v # Top-level module connecting all components
  ─ cache_tb.v # Testbench for simulating the cache behavior
  ─ config.mk # OpenLane configuration file (clock, utilization, etc.)
  ─ Screenshot*.png # Snapshots from synthesis, layout, or simulation

## ⚙️ Features

- 4-way Set-Associative Cache
- FIFO Replacement Strategy
- Tag Comparison, Hit/Miss Detection
- Synthesizable Verilog
- OpenLane Integration (Yosys, Floorplan, Placement, CTS, Routing, DRC/LVS)

## 🧪 Simulation

Run `cache_tb.v` in any Verilog simulator (e.g., ModelSim, Icarus Verilog, Vivado) to validate hit/miss behavior.

## 🛠️ ASIC Flow (OpenLane)

Make sure the repo is placed inside your OpenLane design directory:

openlane/
  ─ designs/
  ─ cache_top/
  ─ config.mk
  ─ src/
  ─ cache_top.v
  ─ cache_memory.v
  ─ fifo_replacement.v

Then launch OpenLane and run:

```bash
./flow.tcl -design cache_top

