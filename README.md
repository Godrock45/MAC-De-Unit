# MAC-De-Unit
Pipelined Multiply-Accumulate (MAC) Unit 
# Pipelined Multiply–Accumulate (MAC) Module

## Overview

`mac_pipe` is a parameterizable **pipelined Multiply–Accumulate (MAC)** unit written in SystemVerilog.
It is designed for digital signal processing (DSP), machine learning accelerators, and general hardware arithmetic pipelines.

The module performs the operation:

```
y = acc_in + (a × b)
```

To increase throughput and timing performance, the computation is divided into **three pipeline stages**:

1. **Input Register Stage**
2. **Multiplication Stage**
3. **Accumulation Stage**

After the pipeline is filled, the module can produce **one result per clock cycle** when `in_valid` remains asserted.

---

## Features

* Parameterizable operand widths
* Optional **signed or unsigned multiplication**
* 3-stage pipeline for improved timing
* Valid signal propagation through pipeline
* Synchronous reset
* Designed for synthesis on FPGA or ASIC targets

---

## Parameters

| Parameter | Description                               |
| --------- | ----------------------------------------- |
| `A_W`     | Width of input `a`                        |
| `B_W`     | Width of input `b`                        |
| `ACC_W`   | Width of accumulator and output           |
| `SIGNED`  | Enables signed arithmetic when set to `1` |

Example:

```systemverilog
mac_pipe #(
  .A_W(8),
  .B_W(8),
  .ACC_W(24),
  .SIGNED(0)
) mac_inst (...);
```

---

## Interface

### Inputs

| Signal     | Description                |
| ---------- | -------------------------- |
| `clk`      | Clock signal               |
| `rst`      | Synchronous reset          |
| `in_valid` | Indicates valid input data |
| `a`        | Multiplicand input         |
| `b`        | Multiplier input           |
| `acc_in`   | Accumulator input value    |

### Outputs

| Signal      | Description                  |
| ----------- | ---------------------------- |
| `out_valid` | Output validity indicator    |
| `y`         | Result of `acc_in + (a × b)` |

---

## Pipeline Architecture

### Stage 1 — Input Register

Inputs `a`, `b`, and `acc_in` are registered when `in_valid` is asserted.

### Stage 2 — Multiply

The operands are multiplied to produce the intermediate product.
Signed or unsigned multiplication is selected using the `SIGNED` parameter.

### Stage 3 — Accumulate

The multiplication result is added to the delayed accumulator input.

---

## Latency

The pipeline introduces a **3-cycle latency**:

```
Cycle 1 → Input registered
Cycle 2 → Multiplication
Cycle 3 → Accumulation
```

Once the pipeline is filled, the module can sustain **one MAC result per cycle**.

---

## Example Use Cases

* FIR filters
* DSP pipelines
* Neural network accelerators
* Matrix multiplication engines
* Hardware signal processing blocks

---

## Possible Extensions

* Saturating arithmetic
* Configurable pipeline depth
* Ready/valid handshake support
* SIMD vector MAC units
* Integration into systolic arrays

---

## Author

Akshat Singh
Computer Engineering – Digital Design / Hardware Systems
