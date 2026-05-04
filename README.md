# APB Slave Verification (SystemVerilog)

## Objective

This project implements a SystemVerilog testbench to verify an APB slave design.
The focus is on checking basic functionality like read/write operations, reset behavior, and error handling.


## Testbench Architecture

The verification environment is implemented using a class-based approach.

```text
Driver → APB Interface → DUT → Scoreboard
```

* **Driver**: Generates APB-compliant write/read transactions
* **DUT**: APB slave with internal memory (0–63 address range)
* **Scoreboard**: Maintains expected memory model and checks read data

---

## Verification Strategy

Directed testing is used to validate specific APB behaviors:

* Apply write transaction → store expected data
* Apply read transaction → capture DUT response
* Compare DUT output with expected memory model
* Report PASS/FAIL

---

## Test Cases Implemented

1. **Reset Test**

   * Verify `prdata = 0`, `pready = 0`, `pslverr = 0` after reset

2. **Valid Write-Read**

   * Write data to a valid address
   * Read same address and compare

3. **Multiple Address Access**

   * Verify independent storage across different addresses

4. **Overwrite Test**

   * Write twice to same address
   * Ensure latest data is returned

5. **Invalid Address (PSLVERR)**

   * Access address > 63
   * Expect `pslverr = 1`

---

## Results

All test cases passed.

```text
RESET TEST PASSED
READ MATCH | Addr=0x10 | Expected=0xa5 | Actual=0xa5
PSLVERR TEST PASSED | Invalid address detected
FINAL RESULT: APB VERIFICATION PASSED
```

---

## Tools

* SystemVerilog
* ModelSim Intel FPGA Edition

---

## Simulation

```tcl
cd simulation
do run.do
```
