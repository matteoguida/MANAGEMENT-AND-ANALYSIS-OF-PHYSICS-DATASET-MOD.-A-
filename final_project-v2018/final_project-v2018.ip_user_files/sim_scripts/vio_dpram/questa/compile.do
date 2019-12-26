vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/sim/vio_dpram.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

