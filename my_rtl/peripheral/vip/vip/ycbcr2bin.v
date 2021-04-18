`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ycbcr2bin
// Target Devices: artix 7
// Tool Versions: vivado 2019.2
// Description: ycbcr to bin 
//////////////////////////////////////////////////////////////////////////////////

module ycbcr2bin(
    input               clk             ,   // 模块驱动时钟
    input               rst_n           ,   // 复位信号

    //图像处理前的数据接口
    input               pre_frame_vsync ,   // vsync信号
    input               pre_frame_hsync ,   // hsync信号
    input               pre_frame_de    ,   // data enable信号
    input       [7:0]   img_y         ,   // 输入图像Y数据

    //图像处理后的数据接口
    output              post_frame_vsync,   // vsync信号
    output              post_frame_hsync,   // hsync信号
    output              post_frame_de   ,   // data enable信号
    output reg  [7:0]   img_bin             // 输出二值化图像

    );

reg pre_frame_vsync_reg;
reg pre_frame_hsync_reg;
reg pre_frame_de_reg;

assign post_frame_vsync = pre_frame_vsync_reg;
assign post_frame_hsync = pre_frame_hsync_reg;
assign post_frame_de    = pre_frame_de_reg;

// 二值化
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        img_bin <= 8'd0;
    end 
    else begin
        img_bin <= (img_y > 125) ? 8'd255 : 8'd0;
    end
end
// 控制信号 打一拍
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pre_frame_vsync_reg <= 1'b0;        
        pre_frame_hsync_reg <= 1'b0;
        pre_frame_de_reg <= 1'b0;
    end 
    else begin
        pre_frame_vsync_reg <= pre_frame_vsync; 
        pre_frame_hsync_reg <= pre_frame_hsync;
        pre_frame_de_reg <= pre_frame_de;
    end
end

endmodule
