`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2016 09:12:32 PM
// Design Name: 
// Module Name: tb_LEDPLAY
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
    
module tb_LEDPLAY(
    
        );
        
        reg clk_p, clk_n;
        reg sw_north, sw_east, sw_south, sw_west, sw_center;
        reg dip_0, dip_1, dip_2;
        wire led_0, led_1, led_2, led_3, led_4, led_5, led_6,led_7;
        
        LEDPLAY U(
            .clk_p(clk_p),
            .clk_n(clk_n),
            .sw_north(sw_north),
            .sw_east(sw_east),
            .sw_south(sw_south),
            .sw_west(sw_west),
            .sw_center(sw_center),
            .dip_0(dip_0),
            .dip_1(dip_1),
            .dip_2(dip_2),
            .led_0(led_0),
            .led_1(led_1),
            .led_2(led_2),
            .led_3(led_3),
            .led_4(led_4),
            .led_5(led_5),
            .led_6(led_6),
            .led_7(led_7)
        );
        
        
        initial begin
            clk_p = 0;
            clk_n = 1;
            dip_0 = 0;
            dip_1 = 0;
            dip_2 = 0;
            sw_north = 0;
            sw_east  = 0;
            sw_south = 0;
            sw_west  = 0;
            sw_center = 0;
                      
            
            #203 sw_center = 1;
            #5 sw_center = 0;
            
            
            #1200 sw_west = 1;
            #30 sw_west = 0;
            
            #20 sw_south = 1;
            #30 sw_south = 0;
            
            
            #1200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
//            #100 $finish;
       
        end
        
        always begin
            #1 clk_p = ~clk_p; clk_n = ~clk_n;
        end
    
endmodule
