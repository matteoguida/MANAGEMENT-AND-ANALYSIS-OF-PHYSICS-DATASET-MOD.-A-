vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../final_project.srcs/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../final_project.srcs/sources_1/ip/vio_0/hdl" "+incdir+../../../../final_project.srcs/sources_1/ip/vio_0/hdl/verilog" "+incdir+../../../../final_project.srcs/sources_1/ip/vio_0/hdl" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../final_project.srcs/sources_1/ip/vio_0/sim/vio_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

