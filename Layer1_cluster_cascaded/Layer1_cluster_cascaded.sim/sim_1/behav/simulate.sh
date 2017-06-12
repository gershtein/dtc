#!/bin/sh -f
xv_path="/home/gerstein/Xlinix/Vivado/2014.3.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim tb_LEDPLAY_behav -key {Behavioral:sim_1:Functional:tb_LEDPLAY} -tclbatch tb_LEDPLAY.tcl -log simulate.log
