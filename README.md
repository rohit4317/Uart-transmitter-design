# UART Transmitter using Verilog HDL

## Overview
A simple 8-N-1 UART transmitter. It sends one start bit (0), eight data bits (least-significant bit first), and one stop bit (1).

## Parameters
- `CLKS_PER_BIT`: number of clock cycles per transmitted bit. Set this according to the system clock and desired baud rate.

## Files
- `rtl/uart_tx.v` — synthesizable transmitter RTL
- `tb/tb_uart_tx.v` — testbench

## Run simulation
```bash
iverilog -g2012 -o uart_sim rtl/uart_tx.v tb/tb_uart_tx.v
vvp uart_sim
```

## Concepts demonstrated
Finite-state machines, counters, serial communication, baud timing and handshake signals.

This repository implements the transmitter only; a receiver and loopback test can be added as a future extension.
