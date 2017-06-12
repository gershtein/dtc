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
ExecStep $xv_path/bin/xsim tb_topmergetest_behav -key {Behavioral:sim_1:Functional:tb_topmergetest} -tclbatch tb_topmergetest.tcl -log simulate.log
