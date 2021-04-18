`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/22 15:37:06
// Design Name: 
// Module Name: img2hdmi
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


module img2hdmi(
    input video_clk,        // 像素时钟
	input video_clk_5x,     // 5倍像素时钟
    input rst,              // 复位

    input [7:0] img_r,      // r     
    input [7:0] img_g,      // g
    input [7:0] img_b,      // b

    output reg region_0_active,   // 显示区域有效，输入像素
	output reg region_1_active,   // 显示区域有效，输入像素
    output vs,                  // 场同步，新的一帧图像

    //HDMI输出信号
    output hdmi_oen,            //                  
    output TMDS_clk_n,          //
    output TMDS_clk_p,          //
    output [2:0]TMDS_data_n,    //    
    output [2:0]TMDS_data_p     //

);

// 图片大小
parameter H_img_0 = 12'd256;  // 高度 
parameter W_img_0 = 12'd256;  // 宽度 

parameter H_img_1 = 12'd256;  // 高度 
parameter W_img_1 = 12'd256;  // 宽度 

// 图片左上角坐标
parameter x_img_0 = 0;        // 图片左上角位置 x 坐标
parameter y_img_0 = 0;        // 图片左上角位置 y 坐标

parameter x_img_1 = 0;        // 图片左上角位置 x 坐标
parameter y_img_1 = 0;        // 图片左上角位置 y 坐标

/*********1280x720@60P视频时序参数定义******************************************/
localparam H_ACTIVE = 16'd1280;     //行有效长度（像素时钟周期个数）
localparam H_FP     = 16'd110;      //行同步前肩长度
localparam H_SYNC   = 16'd40;      	//行同步长度
localparam H_BP     = 16'd220;      //行同步后肩长度
localparam V_ACTIVE = 16'd720;      //场有效长度（行的个数）
localparam V_FP     = 16'd5;        //场同步前肩长度
localparam V_SYNC   = 16'd5;        //场同步长度
localparam V_BP     = 16'd20;       //场同步后肩长度

/*********1920x1080@60P视频时序参数定义******************************************/
//localparam H_ACTIVE = 16'd1920;	//行有效长度（像素时钟周期个数）
//localparam H_FP 	  = 16'd88;		//行同步前肩长度
//localparam H_SYNC   = 16'd44;		//行同步长度
//localparam H_BP     = 16'd148; 	//行同步后肩长度
//localparam V_ACTIVE = 16'd1080;	//场有效长度（行的个数）
//localparam V_FP 	  = 16'd4;		//场同步前肩长度
//localparam V_SYNC   = 16'd5;		//场同步长度
//localparam V_BP	  = 16'd36;		//场同步后肩长度

localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;//行总长度
localparam V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;//场总长度

reg hs_reg;		//定义一个寄存器,用于行同步
reg vs_reg;		//定义一个寄存器,用户场同步
reg hs_reg_d0;	//hs_reg一个时钟的延迟
              	//所有以_d0、d1、d2等为后缀的均为某个寄存器的延迟
reg vs_reg_d0;	//vs_reg一个时钟的延迟

reg [11:0]  h_cnt;              //用于行的计数器
reg [11:0]  v_cnt;              //用于场（帧）的计数器
reg [11:0]  active_x;           //有效图像的的坐标x
reg [11:0]  active_y;           //有效图像的坐标y
reg [7:0]   rgb_r_reg;          //像素数据r分量
reg [7:0]   rgb_g_reg;          //像素数据g分量
reg [7:0]   rgb_b_reg;          //像素数据b分量
reg         h_active;           //行图像有效
reg         v_active;           //场图像有效
wire        video_active;       //一帧内图像的有效区域h_active & v_active
reg         video_active_d0;

wire [7:0] rgb_r;
wire [7:0] rgb_g;
wire [7:0] rgb_b;

assign hs = hs_reg_d0;
assign vs = vs_reg_d0;
assign video_active = h_active & v_active;
assign de = video_active_d0;
assign rgb_r = rgb_r_reg;
assign rgb_g = rgb_g_reg;
assign rgb_b = rgb_b_reg;

// 寄存器延时
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		begin
			hs_reg_d0 <= 1'b0;
			vs_reg_d0 <= 1'b0;
			video_active_d0 <= 1'b0;
		end
	else
		begin
			hs_reg_d0 <= hs_reg;
			vs_reg_d0 <= vs_reg;
			video_active_d0 <= video_active;
		end
end

// 行计数器
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		h_cnt <= 12'd0;
	else if(h_cnt == H_TOTAL - 1)//行计数器到最大值清零
		h_cnt <= 12'd0;
	else
		h_cnt <= h_cnt + 12'd1;
end

// x 坐标计算
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		active_x <= 12'd0;
	else if(h_cnt >= H_FP + H_SYNC + H_BP - 1)//计算图像的x坐标
		active_x <= h_cnt - (H_FP[11:0] + H_SYNC[11:0] + H_BP[11:0] - 12'd1);
	else
		active_x <= active_x;
end

// 列计数器/场计数器
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		v_cnt <= 12'd0;
	else if(h_cnt == H_FP  - 1)//在行数计算器为H_FP - 1的时候场计数器+1或清零
		if(v_cnt == V_TOTAL - 1)//场计数器到最大值了，清零
			v_cnt <= 12'd0;
		else
			v_cnt <= v_cnt + 12'd1;//没到最大值，+1
	else
		v_cnt <= v_cnt;
end

// y 坐标计算
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		active_y <= 12'd0;
	else if(v_cnt >= V_FP + V_SYNC + V_BP - 1)//计算图像的y坐标
		active_y <= v_cnt - (V_FP[11:0] + V_SYNC[11:0] + V_BP[11:0] - 12'd1);
	else
		active_y <= active_y;
end

// 行同步
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		hs_reg <= 1'b0;
	else if(h_cnt == H_FP - 1)//行同步开始了...
		hs_reg <= 1'b1;
	else if(h_cnt == H_FP + H_SYNC - 1)//行同步这时候要结束了
		hs_reg <= 1'b0;
	else
		hs_reg <= hs_reg;
end

// 行有效区域
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		h_active <= 1'b0;
	else if(h_cnt == H_FP + H_SYNC + H_BP - 1)
		h_active <= 1'b1;
	else if(h_cnt == H_TOTAL - 1)
		h_active <= 1'b0;
	else
		h_active <= h_active;
end

// 场同步
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		vs_reg <= 1'd0;
	else if((v_cnt == V_FP - 1) && (h_cnt == H_FP - 1))
		vs_reg <= 1'b1;
	else if((v_cnt == V_FP + V_SYNC - 1) && (h_cnt == H_FP - 1))
		vs_reg <= 1'b0;	
	else
		vs_reg <= vs_reg;
end

// 列有效区域
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		v_active <= 1'd0;
	else if((v_cnt == V_FP + V_SYNC + V_BP - 1) && (h_cnt == H_FP - 1))
		v_active <= 1'b1;
	else if((v_cnt == V_TOTAL - 1) && (h_cnt == H_FP - 1))
		v_active <= 1'b0;	
	else
		v_active <= v_active;
end

// 显示有效区域计算
reg region_0_active_d0;
reg region_1_active_d0;

// 显示0区域有效
always@(posedge video_clk)
begin
	if(active_y >= y_img_0 && active_y <= y_img_0 + H_img_0 - 12'd1 && active_x >= x_img_0 && active_x  <= x_img_0 + W_img_0 - 12'd1)
		region_0_active <= 1'b1;
	else
		region_0_active <= 1'b0;
    region_0_active_d0 <= region_0_active;
end

// 显示区域 1 有效
always@(posedge video_clk)
begin
	if(active_y >= y_img_1 && active_y <= y_img_1 + H_img_1 - 12'd1 && active_x >= x_img_1 && active_x  <= x_img_1 + W_img_1 - 12'd1)
		region_1_active <= 1'b1;
	else
		region_1_active <= 1'b0;
    region_1_active_d0 <= region_1_active;
end

// 像素赋值
always@(posedge video_clk or posedge rst)
begin
	if(rst)
		begin
			rgb_r_reg <= 8'h00;
			rgb_g_reg <= 8'h00;
			rgb_b_reg <= 8'h00;
		end
	else if(video_active)
		if(region_0_active_d0)begin	
			rgb_r_reg <= img_r;
			rgb_g_reg <= img_g;
			rgb_b_reg <= img_b;
		end
		else if(region_1_active_d0)begin
			rgb_r_reg <= img_r;
			rgb_g_reg <= img_g;
			rgb_b_reg <= img_b;
		end
		else
			begin
				rgb_r_reg <= 8'h00;
				rgb_g_reg <= 8'h00;
				rgb_b_reg <= 8'h00;
			end			
	else
		begin
			rgb_r_reg <= 8'h00;
			rgb_g_reg <= 8'h00;
			rgb_b_reg <= 8'h00;
		end
end

// hdmi显示ip
rgb2dvi_0 rgb2dvi_m0 (
	// DVI 1.0 TMDS video interface
	.TMDS_Clk_p(TMDS_clk_p),
	.TMDS_Clk_n(TMDS_clk_n),
	.TMDS_Data_p(TMDS_data_p),
	.TMDS_Data_n(TMDS_data_n),
	.oen(hdmi_oen),
	//Auxiliary signals 
	.aRst_n(1'b1), //-asynchronous reset; must be reset when Refvideo_clk is not within spec
	
	// Video in
	.vid_pData({rgb_r,rgb_g,rgb_b}),
	.vid_pVDE(de),
	.vid_pHSync(hs),
	.vid_pVSync(vs),
	
	.PixelClk(video_clk),
	.SerialClk(video_clk_5x)// 5x Pixelvideo_clk
); 
  
endmodule