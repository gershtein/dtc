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
ExecStep $xv_path/bin/xelab -wto 59ba45ff796e433daca97a71eb22de8a -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_LEDPLAY_behav xil_defaultlib.tb_LEDPLAY xil_defaultlib.glbl -log elaborate.log
