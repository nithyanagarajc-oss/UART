# UART Transmitter Using Verilog

## Overview

This project implements a **UART (Universal Asynchronous Receiver/Transmitter) Transmitter** using Verilog HDL.

The UART transmitter converts an 8-bit parallel data byte into a serial data stream using the standard UART frame format.

The design uses:

* 1 Start bit
* 8 Data bits
* 1 Stop bit
* No parity bit

The data is transmitted **LSB first**.

## UART Frame Format

```text
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop
  1     0      Data bits transmitted LSB first       1
```

## Block Diagram

```text
                  +-------------------+
 TX Data[7:0] --->|                   |
                  |    UART TX        |----> TX Serial
 TX Start ------->|    Controller     |
                  |                   |
 CLK ------------>|                   |
 RESET ---------->|                   |
                  +-------------------+
                           |
                           v
                       TX Busy
```

## Inputs

| Signal         | Description            |
| -------------- | ---------------------- |
| `clk`          | System clock           |
| `reset`        | Active-high reset      |
| `tx_start`     | Starts transmission    |
| `tx_data[7:0]` | 8-bit data to transmit |

## Outputs

| Signal    | Description                       |
| --------- | --------------------------------- |
| `tx`      | Serial UART output                |
| `tx_busy` | HIGH while transmission is active |

## UART Operation

When `tx_start` is asserted, the transmitter loads the 8-bit data and begins transmission.

The sequence is:

```text
IDLE
  ↓
START BIT
  ↓
DATA BITS
  ↓
STOP BIT
  ↓
IDLE
```

The UART line remains HIGH when idle.

## Example

For:

```text
tx_data = 8'h41
```

`8'h41` is ASCII character **A**.

Binary representation:

```text
0100 0001
```

UART sends the bits LSB first:

```text
1 0 0 0 0 0 1 0
```

Complete frame:

```text
0 1 0 0 0 0 1 0 1
^                 ^
Start             Stop
```

## Project Structure

```text
uart-project/
├── README.md
├── uart_tx.v
└── uart_tx_tb.v
```

## Simulation

The project can be simulated using:

* Icarus Verilog
* ModelSim
* QuestaSim
* Vivado

### Compile

```bash
iverilog -o uart_sim uart_tx.v uart_tx_tb.v
```

### Run

```bash
vvp uart_sim
```

## Expected Output

The testbench transmits two characters:

```text
'A' = 8'h41
'B' = 8'h42
```

For `A`, the expected UART frame is:

```text
Start  D0 D1 D2 D3 D4 D5 D6 D7  Stop
  0     1  0  0  0  0  1  0  1    1
```

For `B`:

```text
Start  D0 D1 D2 D3 D4 D5 D6 D7  Stop
  0     0  1  0  0  0  1  0  1    1
```

## Result

The UART transmitter successfully converts parallel 8-bit data into a serial UART data stream.

The simulation verifies the correct generation of the start bit, eight data bits, and stop bit.

## Applications

UART is commonly used for:

* Microcontroller communication
* FPGA-to-PC communication
* Serial debugging
* Embedded systems
* Sensor communication
* Device-to-device communication

## Future Improvements

This project can be extended to include:

* UART Receiver
* Complete UART TX/RX
* Configurable baud rate
* Parity bit
* FIFO buffer
* Error detection
* FPGA hardware implementation

## Conclusion

This project demonstrates a basic UART transmitter designed using Verilog HDL. The design provides a simple foundation for implementing serial communication in FPGA and digital systems.
