proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  set_param gui.test TreeTableDev
  debug::add_scope template.lib 1
  open_checkpoint LEDPLAY_placed.dcp
  set_property webtalk.parent_dir /home/gerstein/Xlinix/Vivado/2014.3.1/Layer1_cluster_cascaded/Layer1_cluster_cascaded.cache/wt [current_project]
  route_design 
  write_checkpoint -force LEDPLAY_routed.dcp
  catch { report_drc -file LEDPLAY_drc_routed.rpt -pb LEDPLAY_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file LEDPLAY_timing_summary_routed.rpt -rpx LEDPLAY_timing_summary_routed.rpx }
  catch { report_power -file LEDPLAY_power_routed.rpt -pb LEDPLAY_power_summary_routed.pb }
  catch { report_route_status -file LEDPLAY_route_status.rpt -pb LEDPLAY_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

