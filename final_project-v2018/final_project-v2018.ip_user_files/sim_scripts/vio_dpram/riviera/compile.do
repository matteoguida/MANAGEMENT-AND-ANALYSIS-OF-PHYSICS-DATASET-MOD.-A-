vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/sim/vio_dpram.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

