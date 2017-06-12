#200 MHz system clock
create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports clk_p]

# derived clocks
# We convert the 200 MHz clock to something 
# representing the faster processing clock

#now: 240 MHz
create_clock -period 3.125 -name clk

set_property CONFIG_VOLTAGE 2.5 [current_design]
set_property CFGBVS VCCO [current_design]

set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_n]
set_property PACKAGE_PIN G18 [get_ports clk_n]


set_property IOSTANDARD LVCMOS18 [get_ports sw_north]
set_property PACKAGE_PIN AR40 [get_ports sw_north]
set_property IOSTANDARD LVCMOS18 [get_ports sw_east]
set_property PACKAGE_PIN AU38 [get_ports sw_east]
set_property IOSTANDARD LVCMOS18 [get_ports sw_south]
set_property PACKAGE_PIN AP40 [get_ports sw_south]
set_property IOSTANDARD LVCMOS18 [get_ports sw_west]
set_property PACKAGE_PIN AW40 [get_ports sw_west]
set_property IOSTANDARD LVCMOS18 [get_ports sw_center]
set_property PACKAGE_PIN AV39 [get_ports sw_center]

set_property IOSTANDARD LVCMOS18 [get_ports dip_0]
set_property PACKAGE_PIN AV30 [get_ports dip_0]
set_property IOSTANDARD LVCMOS18 [get_ports dip_1]
set_property PACKAGE_PIN AY33 [get_ports dip_1]
set_property IOSTANDARD LVCMOS18 [get_ports dip_2]
set_property PACKAGE_PIN BA31 [get_ports dip_2]

set_property IOSTANDARD LVCMOS18 [get_ports led_0]
set_property PACKAGE_PIN AM39 [get_ports led_0]
set_property IOSTANDARD LVCMOS18 [get_ports led_1]
set_property PACKAGE_PIN AN39 [get_ports led_1]
set_property IOSTANDARD LVCMOS18 [get_ports led_2]
set_property PACKAGE_PIN AR37 [get_ports led_2]
set_property IOSTANDARD LVCMOS18 [get_ports led_3]
set_property PACKAGE_PIN AT37 [get_ports led_3]
set_property IOSTANDARD LVCMOS18 [get_ports led_4]
set_property PACKAGE_PIN AR35 [get_ports led_4]
set_property IOSTANDARD LVCMOS18 [get_ports led_5]
set_property PACKAGE_PIN AP41 [get_ports led_5]
set_property IOSTANDARD LVCMOS18 [get_ports led_6]
set_property PACKAGE_PIN AP42 [get_ports led_6]
set_property IOSTANDARD LVCMOS18 [get_ports led_7]
set_property PACKAGE_PIN AU39 [get_ports led_7]


