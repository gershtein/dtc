`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2016 01:35:31 AM
// Design Name: 
// Module Name: unpack
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


module unpack(
    input clk320,
    input [31:0] Din,
    input start,
    input reset,
    output [17:0] stub, //21 bits for PS, 18 bits for 2S
                        // for 2S:  [17:15]- BX offset
                        //          [14:12]- Chip ID
                        //          [11: 4]- strip
                        //          [ 3: 0]- bend
    output valid,
    output [11:0] BX,
    output [1:0] F3,
    output [8:0] status
    );
    
  //the 8BX boxcar we get every 200 ns
  reg [255:0] BOXCAR;
    
  //state machine counter
  //counts to 8x8  
  reg [5:0] FRAME;
  always @(posedge clk320) begin
    if(start)
       FRAME <= 6'b000000;
    else
       FRAME <= FRAME + 1; 
  end
  reg [5:0] FRAME1; //trails FRAME by one 320MHz cycle
  always @(posedge clk320) begin
    if(start)
       FRAME1 <= 6'b000000;
    else
       FRAME1 <= FRAME; 
  end
    
  //counter of 200 ns / 8BX boxcars.
  //counts from 0 to 2 if TMUX=6
  reg [1:0] F3_reg;
  assign F3 = F3_reg;
  always @(posedge clk320) begin  //should it be just sensitive to start & reset?
    if(reset)
       F3_reg <= 2'b10;
    else
       if(start) begin
         if(F3_reg == 2)
            F3_reg <= 0;
         else
            F3_reg <= F3_reg + 1;
       end
  end  
  
  //filling the boxcar
  always @(posedge clk320) begin
     case(FRAME[5:3])  //BX number, 40 MHz
       0: BOXCAR[255:224] <= Din; //clock cycle 1
       1: BOXCAR[223:192] <= Din; //clock cycle 2
       2: BOXCAR[191:160] <= Din; //clock cycle 3
       3: BOXCAR[159:128] <= Din; //clock cycle 4
       4: BOXCAR[127: 96] <= Din; //clock cycle 5
       5: BOXCAR[ 95: 64] <= Din; //clock cycle 6
       6: BOXCAR[ 63: 32] <= Din; //clock cycle 7
       7: BOXCAR[ 31:  0] <= Din; //clock cycle 8
     endcase
  end  
    
  //wiring stub outputs: 2S version  
  reg  [17:0] stub_reg;
  assign stub = stub_reg;
  reg        valid_reg; 
  assign valid = valid_reg & (FRAME1[1:0]==2'b01);

  reg    [11:0] BX_reg;
  assign BX = BX_reg;
  reg [8:0] status_reg;
  assign status = status_reg;
  reg [3:0] Nstubs;
  always @(posedge clk320) begin
    case(FRAME1[5:2])  //half BX, 80 MHz
      4'b0000: begin
               status_reg <= BOXCAR[254:246];
               valid_reg  <=0;
          end
      4'b0001: begin
               BX_reg <= BOXCAR[245:234];
               Nstubs <= BOXCAR[233:230];
               valid_reg <=0;
          end     
      4'b0010: begin
               stub_reg  <= BOXCAR[229:212]; //stub 1        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end     
      4'b0011: begin
               stub_reg  <= BOXCAR[211:194]; //stub 2        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end              
      4'b0100: begin
               stub_reg  <= BOXCAR[193:176]; //stub3        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end     
      4'b0101: valid_reg <= 0;         
                                 
      4'b0110: begin
               stub_reg  <= BOXCAR[175:158]; //stub 4        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                
      4'b0111: begin
               stub_reg  <= BOXCAR[157:140]; //stub 5
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                 
      4'b1000: begin
               stub_reg  <= BOXCAR[139:122]; //stub 6         
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                           
      4'b1001: begin
               stub_reg  <= BOXCAR[121:104]; //stub 7        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                                    
      4'b1010: begin
               stub_reg  <= BOXCAR[103:86];  //stub 8        
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                                             
      4'b1011: begin
               stub_reg  <= BOXCAR[85:68];   //stub 9
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                                                      
      4'b1100: begin
               stub_reg  <= BOXCAR[67:50];   //stub 10
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                                                               
      4'b1101: begin
               stub_reg  <= BOXCAR[49:32];   //stub 11
               valid_reg <= ~(Nstubs==0);
               if( Nstubs != 0 && FRAME1[1:0]==2'b00) Nstubs <= Nstubs - 1;
          end                                                                                                        
      4'b1110: valid_reg <= 0;
                                                                                                                  
      4'b1111: begin
               stub_reg  <= BOXCAR[31:14];   //stub 12
               valid_reg <= ~(Nstubs==0);
               Nstubs <= 0;
          end
    endcase
  end
    
endmodule
