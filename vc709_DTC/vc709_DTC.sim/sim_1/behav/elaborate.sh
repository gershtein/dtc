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
ExecStep $xv_path/bin/xelab -wto 9de5942259824f898acce293968f5a82 -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_topmergetest_behav xil_defaultlib.tb_topmergetest xil_defaultlib.glbl -log elaborate.log
