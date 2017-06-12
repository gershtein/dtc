`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2015 02:43:30 PM
// Design Name: 
// Module Name: pe_channel_used
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


module pe_channel_used(
      input clk,
      input init,         //new event
      input hold,         //do not start while hold is high
      input have_data,    //1 -> channel has data
      input sel,          //sel -> channel is selected 
      
      output  have_unused_data, // 1-> channel has unread data
      output  valid             // channel output is valid
    );
    
    reg used=1'b0;
    wire active = sel & ~init & ~hold;
    always @(posedge clk) begin
       if(init)
         used <=have_data;
       else if(active)
         used <= 1'b0;
    end
    
    assign  have_unused_data = used;
    assign  valid = used & active;
    
endmodule
