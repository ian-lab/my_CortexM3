`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2021/04/16 11:21:03 
// Module Name: vip
// Target Devices: artix 7
// Tool Versions: vivado 2019.2
// Description: 图像处理模块
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vip(
    //module clock
    input           clk            ,   // 时钟信号
    input           rst_n          ,   // 复位信号（低有效）

    //图像处理前的数据接口
    input           pre_frame_vsync,
    input           pre_frame_hsync,
    input           pre_frame_de   ,
    input    [15:0] pre_rgb        ,
    input    [10:0] xpos           ,
    input    [10:0] ypos           ,

    //图像处理后的数据接口
    output          post_frame_vsync,  // 场同步信号
    output          post_frame_hsync,  // 行同步信号
    output          post_frame_de   ,  // 数据输入使能
    output   [15:0] post_rgb           // RGB565颜色数据
    );
    
wire ycbcr_frame_vsync; 
wire ycbcr_frame_hsync;
wire ycbcr_frame_de   ;
   
wire [ 7:0] img_y;
wire [ 7:0] img_bin;

assign post_rgb = {img_bin[7:3],img_bin[7:2],img_bin[7:3]};

rgb2ycbcr u_rgb2ycbcr(
	.clk              ( clk              ),
    .rst_n            ( rst_n            ),

    .pre_frame_vsync  ( pre_frame_vsync  ),
    .pre_frame_hsync  ( pre_frame_hsync  ),
    .pre_frame_de     ( pre_frame_de     ),
    .img_red          ( pre_rgb[15:11]   ),
    .img_green        ( pre_rgb[10: 5]   ),
    .img_blue         ( pre_rgb[ 4: 0]   ),

    .post_frame_vsync ( ycbcr_frame_vsync ),
    .post_frame_hsync ( ycbcr_frame_hsync ),
    .post_frame_de    ( ycbcr_frame_de    ),
    .img_y            ( img_y            ),
    .img_cb           ( ),
    .img_cr           ( )
);

ycbcr2bin u_ycbcr2bin(
    .clk              ( clk                ),
    .rst_n            ( rst_n              ),
    .pre_frame_vsync  ( ycbcr_frame_vsync  ),
    .pre_frame_hsync  ( ycbcr_frame_hsync  ),
    .pre_frame_de     ( ycbcr_frame_de     ),
    .img_y            ( img_y            ),
    .post_frame_vsync ( post_frame_vsync ),
    .post_frame_hsync ( post_frame_hsync ),
    .post_frame_de    ( post_frame_de    ),
    .img_bin          ( img_bin          )
);
    
endmodule
