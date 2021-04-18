`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2021/04/16 11:48:55
// Module Name: rgb2ycbcr
// Tool Versions: vivado 2019.2
// Description: rgb565 to ycbcr
// Revision: v1.0
// 输入为RGB565格式，输出YCbCr
//////////////////////////////////////////////////////////////////////////////////


module rgb2ycbcr(
        //module clock
    input               clk             ,   // 模块驱动时钟
    input               rst_n           ,   // 复位信号

    //图像处理前的数据接口
    input               pre_frame_vsync ,   // vsync信号
    input               pre_frame_hsync ,   // hsync信号
    input               pre_frame_de    ,   // data enable信号
    input       [4:0]   img_red         ,   // 输入图像数据R
    input       [5:0]   img_green       ,   // 输入图像数据G
    input       [4:0]   img_blue        ,   // 输入图像数据B

    //图像处理后的数据接口
    output              post_frame_vsync,   // vsync信号
    output              post_frame_hsync,   // hsync信号
    output              post_frame_de   ,   // data enable信号
    output      [7:0]   img_y           ,   // 输出图像Y数据
    output      [7:0]   img_cb          ,   // 输出图像Cb数据
    output      [7:0]   img_cr              // 输出图像Cr数据
    );
// RGB888
wire [ 7:0]   rgb888_r;
wire [ 7:0]   rgb888_g;
wire [ 7:0]   rgb888_b;
// 乘法计算结果
reg  [15:0]   rgb_r_m0, rgb_r_m1, rgb_r_m2; 
reg  [15:0]   rgb_g_m0, rgb_g_m1, rgb_g_m2; 
reg  [15:0]   rgb_b_m0, rgb_b_m1, rgb_b_m2; 
// 加法计算结果
reg  [15:0]   img_y0 ;
reg  [15:0]   img_cb0;
reg  [15:0]   img_cr0;
// 移位计算结果
reg  [ 7:0]   img_y1 ;
reg  [ 7:0]   img_cb1;
reg  [ 7:0]   img_cr1;
// 控制信号寄存器 延迟3拍
reg  [ 2:0]   pre_frame_vsync_d;
reg  [ 2:0]   pre_frame_hsync_d;
reg  [ 2:0]   pre_frame_de_d   ;


// rgb565 to rgb888
assign rgb888_r = {img_red  , img_red[4:2]  };
assign rgb888_g = {img_green, img_green[5:4]};
assign rgb888_b = {img_blue , img_blue[4:2] };

// rgb888 to YCbCr
// 采用三级流水线计算结果
// 乘法->加法->移位
/********************************************************
            RGB888 to YCbCr
 Y  = 0.299R +0.587G + 0.114B
 Cb = 0.568(B-Y) + 128 = -0.172R-0.339G + 0.511B + 128
 CR = 0.713(R-Y) + 128 = 0.511R-0.428G -0.083B + 128
-->
 Y  = (77 *R + 150*G + 29 *B)>>8
 Cb = (-43*R - 85 *G + 128*B)>>8 + 128
 Cr = (128*R - 107*G - 21 *B)>>8 + 128
-->
 Y  = (77 *R + 150*G + 29 *B        )>>8
 Cb = (-43*R - 85 *G + 128*B + 32768)>>8
 Cr = (128*R - 107*G - 21 *B + 32768)>>8
*********************************************************/
// 计算公式中乘法结果
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rgb_r_m0 <= 16'd0;
        rgb_r_m1 <= 16'd0;
        rgb_r_m2 <= 16'd0;
        rgb_g_m0 <= 16'd0;
        rgb_g_m1 <= 16'd0;
        rgb_g_m2 <= 16'd0;
        rgb_b_m0 <= 16'd0;
        rgb_b_m1 <= 16'd0;
        rgb_b_m2 <= 16'd0;
    end 
    else begin
        rgb_r_m0 <= rgb888_r *  8'd77;
        rgb_r_m1 <= rgb888_r *  8'd43;
        rgb_r_m2 <= rgb888_r << 3'd7;  // 左移7位，相当于乘128
        rgb_g_m0 <= rgb888_g *  8'd150;
        rgb_g_m1 <= rgb888_g *  8'd85;
        rgb_g_m2 <= rgb888_g *  8'd107;
        rgb_b_m0 <= rgb888_b *  8'd29;
        rgb_b_m1 <= rgb888_b << 3'd7;
        rgb_b_m2 <= rgb888_b *  8'd21; 
    end
end
// 计算公式中加法结果
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        img_y0  <= 16'd0;
        img_cb0 <= 16'd0;
        img_cr0 <= 16'd0;
    end
    else begin
        img_y0  <= rgb_r_m0 + rgb_g_m0 + rgb_b_m0;
        img_cb0 <= rgb_b_m1 - rgb_r_m1 - rgb_g_m1 + 16'd32768;
        img_cr0 <= rgb_r_m2 - rgb_g_m2 - rgb_b_m2 + 16'd32768; 
    end
end
// 计算公式中最终移位结果
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        img_y1  <= 8'd0;
        img_cb1 <= 8'd0;
        img_cr1 <= 8'd0;
    end
    else begin
        img_y1  <= img_y0 [15:8];
        img_cb1 <= img_cb0[15:8];
        img_cr1 <= img_cr0[15:8];
    end
end

// 将控制信号延时3拍 同步数据信号和控制信号
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pre_frame_vsync_d <= 3'b0;
        pre_frame_hsync_d <= 3'b0;
        pre_frame_de_d    <= 3'b0;
    end 
    else begin
        pre_frame_vsync_d <= {pre_frame_vsync_d[1:0], pre_frame_vsync};
        pre_frame_hsync_d <= {pre_frame_hsync_d[1:0], pre_frame_hsync};
        pre_frame_de_d    <= {pre_frame_de_d[1:0]   , pre_frame_de   };
    end 
end

// 同步输出数据接口信号
assign post_frame_vsync = pre_frame_vsync_d[2];
assign post_frame_hsync = pre_frame_hsync_d[2];
assign post_frame_de    = pre_frame_de_d[2]   ;
assign img_y            = post_frame_hsync ? img_y1 : 8'd0;
assign img_cb           = post_frame_hsync ? img_cb1: 8'd0;
assign img_cr           = post_frame_hsync ? img_cr1: 8'd0;

endmodule
