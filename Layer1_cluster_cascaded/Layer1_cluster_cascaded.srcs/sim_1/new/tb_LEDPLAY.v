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
        
        reg [4:0] PHIBIN;
        
        LEDPLAY U(
        
            .PHIBIN(PHIBIN),
    
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
        
//        wire clk_test;
        
//        IBUFGDS #(
//           .DIFF_TERM    ("TRUE"),
//           .IBUF_LOW_PWR ("FALSE")
//         ) diff_clk_200 (
//           .I    (clk_p  ),
//           .IB   (clk_n  ),
//           .O    (clk_test )  
//         );
        integer infile;
        integer outfile;
        integer i1;
        integer i2;
        initial begin
            infile = $fopen("/home/gerstein/Xlinix/Vivado/2014.3.1/Layer1_cluster_cascaded/phibin.dat","r");
            i1 = $fscanf(infile,"%d",PHIBIN);
            outfile = $fopen("/home/gerstein/Xlinix/Vivado/2014.3.1/Layer1_cluster_cascaded/Layer1_out.dat","w");
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
            
              for(i2=0; i2<32; i2 = i2+1)begin
                      if(U.UL1.zzz[0].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[0].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[1].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[1].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[2].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[2].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[3].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[3].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[4].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[4].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[5].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[5].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[6].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[6].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[7].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[7].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[8].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[8].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[9].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[9].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[10].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[10].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[11].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[11].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[12].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[12].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[13].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[13].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[14].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[14].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[15].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[15].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[16].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[16].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[17].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[17].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[18].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[18].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[19].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[19].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[20].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[20].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[21].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[21].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[22].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[22].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[23].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[23].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[24].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[24].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[25].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[25].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[26].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[26].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[27].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[27].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[28].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[28].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[29].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[29].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[30].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[30].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[31].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[31].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[32].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[32].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[33].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[33].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[34].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[34].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[35].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[35].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[36].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[36].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[37].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[37].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[38].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[38].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[39].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[39].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[40].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[40].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[41].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[41].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[42].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[42].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[43].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[43].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[44].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[44].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[45].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[45].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[46].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[46].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[47].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[47].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[48].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[48].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[49].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[49].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[50].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[50].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[51].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[51].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[52].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[52].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[53].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[53].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[54].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[45].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[55].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[55].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[56].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[56].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[57].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[57].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[58].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[58].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[59].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[59].UZ.fj.jet_mem.BRAM[i2]);

                      if(U.UL1.zzz[60].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[60].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[61].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[61].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[62].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[62].UZ.fj.jet_mem.BRAM[i2]);
                      if(U.UL1.zzz[63].UZ.fj.jet_mem.BRAM[i2] != 0)
$fdisplay(outfile, "%h", U.UL1.zzz[63].UZ.fj.jet_mem.BRAM[i2]);

              end
            $fclose(outfile);
            
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
            
            #200 sw_east = 1;
            #10  sw_east = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_east = 1;
            #10  sw_east = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_east = 1;
            #10  sw_east = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_north = 1;
            #10  sw_north = 0;
            #200 sw_east = 1;
            #10  sw_east = 0;
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
