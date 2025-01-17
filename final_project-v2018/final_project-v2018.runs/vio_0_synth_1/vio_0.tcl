# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config  -ruleid {1}  -id {Project 1-467}  -string {{CRITICAL WARNING: [Project 1-467] UCF constraints are not supported in Vivado (gcu_v2_fw_v0.ucf). Please convert these constraints to XDC and add then add the converted XDC constraints file to the project.}}  -suppress 
set_param project.vivado.isBlockSynthRun true
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.cache/wt [current_project]
set_property parent.project_path /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/stefano/Documents/Corso_VHDL/Laboratori/Lab10_11_12/final_project/final_project.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0.xci
set_property used_in_implementation false [get_files -all /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0.xdc]
set_property used_in_implementation false [get_files -all /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top vio_0 -part xc7a35tcsg324-1 -mode out_of_context

rename_ref -prefix_all vio_0_

# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef vio_0.dcp
create_report "vio_0_synth_1_synth_report_utilization_0" "report_utilization -file vio_0_utilization_synth.rpt -pb vio_0_utilization_synth.pb"

if { [catch {
  file copy -force /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.runs/vio_0_synth_1/vio_0.dcp /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if {[file isdir /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.ip_user_files/ip/vio_0]} {
  catch { 
    file copy -force /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_stub.v /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.ip_user_files/ip/vio_0
  }
}

if {[file isdir /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.ip_user_files/ip/vio_0]} {
  catch { 
    file copy -force /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.srcs/sources_1/ip/vio_0/vio_0_stub.vhdl /home/nicola/Vivado/vivado_projects/Lab10_final_project/firmware/final_project.ip_user_files/ip/vio_0
  }
}
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
