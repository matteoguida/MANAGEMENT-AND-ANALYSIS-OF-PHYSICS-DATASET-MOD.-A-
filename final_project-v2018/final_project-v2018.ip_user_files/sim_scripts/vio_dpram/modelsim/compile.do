vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl/verilog" "+incdir+../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/hdl" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/nicola/Vivado/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../final_project-v2018.srcs/sources_1/ip/vio_dpram/sim/vio_dpram.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

