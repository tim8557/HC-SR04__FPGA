//Top level module
module hc_sr04
(
input clk,
input rst,
output reg trigger, //signal to make the module start
input dur,          //echo pulse from module  
output [7:0] seg0,
output [7:0] seg1,
output [7:0] seg2,
output [7:0] seg3,
output [7:0] seg4,
output [7:0] seg5
);

parameter CNT_MAX = 32'd49_999_999; 
reg reg_1;
reg reg_2;
reg [19:0] cm;
reg [31:0] cnt;
wire falling;
reg [17:0] dur_data;
reg [17:0] dur_cnt;
wire rising;

wire [3:0] unit; 
wire [3:0] ten;
wire [3:0] hun;
wire [3:0] thou;
wire [3:0] ten_thou;
wire [3:0] hun_thou;
wire dur_sync;

//cnt
//start the trigger signal every second.
always@(posedge clk or posedge rst)
if (rst)
cnt <= 32'd0;
else if (cnt == CNT_MAX)
cnt <= 32'd0;
else 
cnt <= cnt + 1'b1;


//trigger signal;
//the duration time of trigger signal is 11 microsecond.
always@(posedge clk or posedge rst)
if (rst)
trigger <= 1'b0;
else if (cnt >= 32'd10 && cnt <= 32'd559)
trigger <= 1'b1;
else 
trigger <= 1'b0;

//dur_cnt
always@(posedge clk or posedge rst)
if (rst)
dur_cnt <= 18'd0;
else if (falling == 1'b1)
dur_cnt <= 18'd0;
else if (dur_sync == 1'b1)
dur_cnt <= dur_cnt + 1'b1;

//reg_1
always@(posedge clk or posedge rst)
if (rst)
reg_1 <= 1'b0;
else 
reg_1 <= dur_sync;

//reg_2;
always@(posedge clk or posedge rst)
if (rst)
reg_2 <= 1'b0;
else 
reg_2 <= reg_1;

//falling and falling edge
//the falling and rising edge of echo pulse
assign falling = ((reg_1 == 1'b0) && (reg_2 == 1'b1))?1'b1:1'b0;
assign rising  = ((reg_1 == 1'b1) && (reg_2 == 1'b0))?1'b1:1'b0;

//dur_data
always@(posedge clk or posedge rst)
if (rst)
dur_data <= 18'd0;
else if (falling == 1'b1)
dur_data <= dur_cnt;

//cm
always@(posedge clk or posedge rst)
if (rst)
cm = 20'd0;
else 
cm = (dur_data*20'd1)/20'd261;

bcd_8421 b0(
.clk(clk), 
.rst(rst),
.data(cm),
.unit(unit), 
.ten(ten), 
.hun(hun), 
.thou(thou), 
.ten_thou(ten_thou), 
.hun_thou(hun_thou)
);

seven_seg s0(
.en(1'b1),
.in(unit), 
.seg(seg0));
				 
				 
seven_seg_dot s1(
.en(1'b1),
.in(ten), 
.seg(seg1));

seven_seg s2(
.en(1'b1),
.in(hun), 
.seg(seg2));

seven_seg s3(
.en(1'b1),
.in(thou), 
.seg(seg3));

seven_seg s4(
.en(1'b1),
.in(ten_thou), 
.seg(seg4));

seven_seg s5(
.en(1'b1),
.in(hun_thou), 
.seg(seg5));

sync sync0(
.in(dur), 
.rst(rst), 
.clk(clk), 
.out(dur_sync));

endmodule