# Management-and-Analysis-of-Physics-Dataset-MOD.-A-
FPGA Project Using Vivado
## General Information
[**FPGA Serial Number**](https://www.amazon.com/Digilent-Arty-A7-Development-Hobbyists/dp/B017BOBNEO): xc7a35tcsg324-1

###  Project Description 
The aim of this project is to create a particular FPGA architecture that do various operations. 
The core components are:
1. The **SPI master**, that has to read the first 2 addresses in the flash memory, concatenate them and write them
in the first address of the DPRAM.

2. **Square wave generator** (implemented in the square wave.vhd) has to produce a square wave given the values
of its period and duty cycle. The values of the two states are fixed and equal to −1024 and +1024. These
signed values are represented in std logic vector variables to be compatible with the other components. From
this generator 1024 samples are picked and written in the DPRAM.

3. **Finite Input Response filter** has to read the addresses in the DPRAM written by the square generator,
apply to them the fir filter and write the result back into the DPRAM.

4. **Multiplexer** that has the task of regulating access to the DPRAM
from the square wave generator and the fir filter, since they both have to access to the same addresses of
memory.
