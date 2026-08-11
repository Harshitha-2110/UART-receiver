# UART-receiver
UART Receiver using Verilog

Description

A UART (Universal Asynchronous Receiver/Transmitter) receiver receives serial data and converts it into parallel data for digital processing.

 Features

- 8-bit data reception
- 1 start bit
- 1 stop bit
- No parity bit
- Parameterized clock frequency and baud rate
- "data_valid" signal indicates successful reception

 UART Frame

Idle | Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop | Idle
  1     0       8-bit data (LSB first)     1

 Files

- "uart_receiver.v" – UART receiver RTL design
- "uart_receiver_tb.v" – Verilog testbench for simulation
Working

1. The receiver waits for the start bit.
2. It detects the falling edge of the start bit.
3. The receiver samples the incoming serial data at the baud-rate interval.
4. Eight data bits are collected, LSB first.
5. The stop bit is checked.
6. The received byte is available on "data_out".
7. "data_valid" becomes HIGH for one clock cycle.

Simulation

The design can be simulated using Icarus Verilog, ModelSim, QuestaSim, or Vivado.

Using Icarus Verilog

iverilog -o uart_sim uart_receiver.v uart_receiver_tb.v
vvp uart_sim

To view the waveform:

gtkwave uart_receiver.vcd

Expected Result

The testbench transmits the byte "8'hA5" serially. The UART receiver reconstructs the byte and produces:

Received Data = A5
Data Valid = 1

Applications

- Serial communication
- FPGA projects
- Microcontroller communication
- Embedded systems
- Digital communication systems
Author: Harshitha 