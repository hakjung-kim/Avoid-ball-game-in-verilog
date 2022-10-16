module top(
    input clk_100mhz,
    input rst,
    input [1:0] btn, 
    input [19:0] seed,
    inout [7:0] key_io,
    input [7:0] rand_num,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output vsync,
    output hsync
    );
wire clk;  
wire [9:0] x, y; 
wire [11:0] rgb;
wire video_on; 
wire [4:0] key_tmp, key, key_pulse;

/////////////////////////////////
clk_wiz_0 clk_inst (clk, rst, , clk_100mhz); 
keypad #(.CLK_KHZ(25175)) keypad_inst (clk, rst, key_io[7:4], key_io[3:0], key_tmp); 
debounce #(.SIZE(16), .BTN_WIDTH(5)) debounce_inst (clk, rst, key_tmp, key, key_pulse); 

assign red = (video_on==1)? {rgb[11:8]} : 0;  
assign green= (video_on==1)? {rgb[7:4]} : 0;
assign blue = (video_on==1)? {rgb[3:0]} : 0;


// drawing module
graph_mod graph_inst(clk, rst, x, y, key, key_pulse, rgb, seed, rand_num);

// sync module
sync_mod sync_inst (rst, clk, x, y, video_on, vsync, hsync); 

endmodule
