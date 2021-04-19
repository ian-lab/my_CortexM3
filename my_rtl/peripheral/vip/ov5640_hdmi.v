//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           ov5640_hdmi
// Last modified Date:  2020/05/04 9:19:08
// Last Version:        V1.0
// Descriptions:        OV5640摄像头HDMI显示
//                      
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/05/04 9:19:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ov5640_hdmi(    
    input                 sys_clk      ,  //系统时钟
    input                 sys_rst_n    ,  //系统复位，低电平有效

    input   [7:0]         threshold    ,  // 二值化阈值
    input   [1:0]         disp_choice  ,  // 选择显示哪种视频 00 原始图像 01 灰度图 10 二值化图
    //摄像头接口                       
    input                 cam_pclk     ,  //cmos 数据像素时钟
    input                 cam_vsync    ,  //cmos 场同步信号
    input                 cam_href     ,  //cmos 行同步信号
    input   [7:0]         cam_data     ,  //cmos 数据
    output                cam_rst_n    ,  //cmos 复位信号，低电平有效
    output                cam_pwdn     ,  //电源休眠模式选择 0：正常模式 1：电源休眠模式
    output                cam_scl      ,  //cmos SCCB_SCL线
    inout                 cam_sda      ,  //cmos SCCB_SDA线       
    // DDR3                            
    inout   [31:0]        ddr3_dq      ,  //DDR3 数据
    inout   [3:0]         ddr3_dqs_n   ,  //DDR3 dqs负
    inout   [3:0]         ddr3_dqs_p   ,  //DDR3 dqs正  
    output  [13:0]        ddr3_addr    ,  //DDR3 地址   
    output  [2:0]         ddr3_ba      ,  //DDR3 banck 选择
    output                ddr3_ras_n   ,  //DDR3 行选择
    output                ddr3_cas_n   ,  //DDR3 列选择
    output                ddr3_we_n    ,  //DDR3 读写选择
    output                ddr3_reset_n ,  //DDR3 复位
    output  [0:0]         ddr3_ck_p    ,  //DDR3 时钟正
    output  [0:0]         ddr3_ck_n    ,  //DDR3 时钟负
    output  [0:0]         ddr3_cke     ,  //DDR3 时钟使能
    output  [0:0]         ddr3_cs_n    ,  //DDR3 片选
    output  [3:0]         ddr3_dm      ,  //DDR3_dm
    output  [0:0]         ddr3_odt     ,  //DDR3_odt									                            
    //hdmi接口                           
    output                tmds_clk_p   ,  // TMDS 时钟通道
    output                tmds_clk_n   ,
    output  [2:0]         tmds_data_p  ,  // TMDS 数据通道
    output  [2:0]         tmds_data_n  
    );     

parameter  H_CMOS_DISP = 11'd640;                  //CMOS分辨率--行	                                
parameter  V_CMOS_DISP = 11'd480;                  //CMOS分辨率--列
parameter  TOTAL_H_PIXEL = H_CMOS_DISP + 12'd1216; //CMOS分辨率--行
parameter  TOTAL_V_PIXEL = V_CMOS_DISP + 12'd504;    										   
							   
//wire define                          
wire         clk_50m             ;  //50mhz时钟,提供给lcd驱动时钟
wire         locked              ;  //时钟锁定信号
wire         rst_n               ;  //全局复位 								            
wire         cam_init_done       ;  //摄像头初始化完成						    
wire         wr_en               ;  //DDR3控制器模块写使能
wire  [15:0] wr_data             ;  //DDR3控制器模块写数据
wire         rdata_req           ;  //DDR3控制器模块读使能
wire  [15:0] rd_data             ;  //DDR3控制器模块读数据
wire         cmos_frame_valid    ;  //数据有效使能信号
wire         init_calib_complete ;  //DDR3初始化完成init_calib_complete
wire         sys_init_done       ;  //系统初始化完成(DDR初始化+摄像头初始化)
wire         clk_200m            ;  //ddr3参考时钟
wire         cmos_frame_vsync    ;  //输出帧有效场同步信号
wire         cmos_frame_href     ;  //输出帧有效行同步信号 
wire  [15:0] cmos_frame_data     ;  //输出数据
wire  [12:0] h_disp              ;  //LCD屏水平分辨率
wire  [12:0] v_disp              ;  //LCD屏垂直分辨率     
wire  [27:0] ddr3_addr_max       ;  //存入DDR3的最大读写地址 
wire  [10:0] pixel_xpos_w        ;
wire  [10:0] pixel_ypos_w        ;
wire         post_frame_vsync    ;
wire         post_frame_hsync    ;
wire         post_frame_de       ; 
wire  [15:0] post_rgb            ;
wire         ycbcr_frame_vsync   ;
wire         ycbcr_frame_hsync   ;
wire         ycbcr_frame_de      ;
wire  [15:0] img_gray            ;
parameter x_disp = 100;               // 显示区域左上角x坐标
parameter y_disp = 100;               // 显示区域左上角y坐标
parameter width_disp = H_CMOS_DISP;   // 显示区域宽度
parameter height_disp = V_CMOS_DISP;  // 显示区域高度
wire [10:0] pixel_xpos;               // 像素点横坐标
wire [10:0] pixel_ypos;               // 像素点纵坐标
wire [15:0] ddr_rd_data;              // 读ddr数据
wire        ddr_rdata_req;            // ddr读数据请求
wire        ddr_wr_load;              // 写ddr数据源更新
wire [15:0] ddr_wr_data;              // 写ddr数据
wire        ddr_wr_valid;             // ddr写数据请求
//*****************************************************
//**                    main code
//*****************************************************

//待时钟锁定后产生复位结束信号
assign  rst_n = sys_rst_n & locked;

//系统初始化完成：DDR3初始化完成
assign  sys_init_done = init_calib_complete;

//存入DDR3的最大读写地址 
assign  ddr3_addr_max =  V_CMOS_DISP*H_CMOS_DISP; 

// 选择视频源存入ddr中并显示
assign ddr_wr_valid = (disp_choice == 2'b00) ? cmos_frame_valid : 
                     ((disp_choice == 2'b01) ? ycbcr_frame_de : post_frame_de);
assign ddr_wr_data  = (disp_choice == 2'b00) ? cmos_frame_data : 
                     ((disp_choice == 2'b01) ? img_gray : post_rgb);
assign ddr_wr_load  = (disp_choice == 2'b00) ? cmos_frame_vsync : 
                     ((disp_choice == 2'b01) ? ycbcr_frame_vsync : post_frame_vsync);
// 在规定区域显示图像
assign rd_data = ddr_rdata_en ? ddr_rd_data : 16'b0;
assign ddr_rdata_req = (pixel_xpos >= x_disp - 1 & pixel_xpos < x_disp + width_disp - 1)
                     & (pixel_ypos >= y_disp     & pixel_ypos < y_disp + height_disp) ? 1'b1 : 1'b0;
assign ddr_rdata_en  = (pixel_xpos >= x_disp     & pixel_xpos < x_disp + width_disp)
                     & (pixel_ypos >= y_disp     & pixel_ypos < y_disp + height_disp) ? 1'b1 : 1'b0;

 //ov5640 驱动
ov5640_dri u_ov5640_dri(
    .clk               ( clk_50m ),
    .rst_n             ( rst_n   ),
 
    .cam_pclk          ( cam_pclk  ),
    .cam_vsync         ( cam_vsync ),
    .cam_href          ( cam_href  ),
    .cam_data          ( cam_data  ),
    .cam_rst_n         ( cam_rst_n ),
    .cam_pwdn          ( cam_pwdn  ),
    .cam_scl           ( cam_scl   ),
    .cam_sda           ( cam_sda   ),
     
    .capture_start     ( init_calib_complete ),
    .cmos_h_pixel      ( H_CMOS_DISP         ),
    .cmos_v_pixel      ( V_CMOS_DISP         ),
    .total_h_pixel     ( TOTAL_H_PIXEL       ),
    .total_v_pixel     ( TOTAL_V_PIXEL       ),
    .cmos_frame_vsync  ( cmos_frame_vsync    ),
    .cmos_frame_href   ( cmos_frame_href     ),
    .cmos_frame_valid  ( cmos_frame_valid    ),
    .cmos_frame_data   ( cmos_frame_data     )
    ); 
    
// 图像处理
vip u_vip(
    .clk              ( cam_pclk         ),
    .rst_n            ( rst_n            ),

    .threshold        ( threshold        ),
    .pre_frame_vsync  ( cmos_frame_vsync ),
    .pre_frame_hsync  ( cmos_frame_href  ),
    .pre_frame_de     ( cmos_frame_valid ),
    .pre_rgb          ( cmos_frame_data  ),
    
    .xpos             ( pixel_xpos_w     ),
    .ypos             ( pixel_ypos_w     ),

    .ycbcr_frame_vsync ( ycbcr_frame_vsync ),
    .ycbcr_frame_hsync ( ycbcr_frame_hsync ),
    .ycbcr_frame_de    ( ycbcr_frame_de    ),
    .img_gray          ( img_gray          ),

    .post_frame_vsync ( post_frame_vsync ),
    .post_frame_hsync (  ),
    .post_frame_de    ( post_frame_de    ),
    .post_rgb         ( post_rgb         )
);

ddr3_top u_ddr3_top (
    .clk_200m            (clk_200m),                  //系统时钟
    .sys_rst_n           (rst_n),                     //复位,低有效
    .sys_init_done       (sys_init_done),             //系统初始化完成
    .init_calib_complete (init_calib_complete),       //ddr3初始化完成信号    
    //ddr3接口信号       
    .app_addr_rd_min     (28'd0),                     //读DDR3的起始地址
    .app_addr_rd_max     (ddr3_addr_max[27:1]),       //读DDR3的结束地址
    .rd_bust_len         (H_CMOS_DISP[10:4]),         //从DDR3中读数据时的突发长度
    .app_addr_wr_min     (28'd0),                     //写DDR3的起始地址
    .app_addr_wr_max     (ddr3_addr_max[27:1]),       //写DDR3的结束地址
    .wr_bust_len         (H_CMOS_DISP[10:4]),         //从DDR3中写数据时的突发长度   
    // DDR3 IO接口              
    .ddr3_dq             (ddr3_dq),                   //DDR3 数据
    .ddr3_dqs_n          (ddr3_dqs_n),                //DDR3 dqs负
    .ddr3_dqs_p          (ddr3_dqs_p),                //DDR3 dqs正  
    .ddr3_addr           (ddr3_addr),                 //DDR3 地址   
    .ddr3_ba             (ddr3_ba),                   //DDR3 banck 选择
    .ddr3_ras_n          (ddr3_ras_n),                //DDR3 行选择
    .ddr3_cas_n          (ddr3_cas_n),                //DDR3 列选择
    .ddr3_we_n           (ddr3_we_n),                 //DDR3 读写选择
    .ddr3_reset_n        (ddr3_reset_n),              //DDR3 复位
    .ddr3_ck_p           (ddr3_ck_p),                 //DDR3 时钟正
    .ddr3_ck_n           (ddr3_ck_n),                 //DDR3 时钟负  
    .ddr3_cke            (ddr3_cke),                  //DDR3 时钟使能
    .ddr3_cs_n           (ddr3_cs_n),                 //DDR3 片选
    .ddr3_dm             (ddr3_dm),                   //DDR3_dm
    .ddr3_odt            (ddr3_odt),                  //DDR3_odt
    //用户                                            
    .ddr3_read_valid     (1'b1),                      //DDR3 读使能
    .ddr3_pingpang_en    (1'b1),                      //DDR3 乒乓操作使能
    .wr_clk              (cam_pclk),                  //写时钟
    .wr_load             (ddr_wr_load),          //输入源更新信号   
	.datain_valid        (ddr_wr_valid),             //数据有效使能信号
    .datain              (ddr_wr_data),                  //有效数据 
    
    .rd_clk              (pixel_clk),                 //读时钟 
    .rd_load             (rd_vsync),                  //输出源更新信号    
    .dataout             (ddr_rd_data),               //rfifo输出数据
    .rdata_req           (ddr_rdata_req)              //请求数据输入   
     );                    

 clk_wiz_0 u_clk_wiz_0
   (
    // Clock out ports
    .clk_out1              (clk_200m),     
    .clk_out2              (clk_50m),
    .clk_out3              (pixel_clk_5x),
    .clk_out4              (pixel_clk),
    // Status and control signals
    .reset                 (1'b0), 
    .locked                (locked),       
   // Clock in ports
    .clk_in1               (sys_clk)
    );     
 
//HDMI驱动显示模块    
hdmi_top u_hdmi_top(
    .pixel_clk            ( pixel_clk             ),
    .pixel_clk_5x         ( pixel_clk_5x          ),    
    .sys_rst_n            ( sys_init_done & rst_n ),
    //hdmi接口                    
    .tmds_clk_p           ( tmds_clk_p   ),   // TMDS 时钟通道
    .tmds_clk_n           ( tmds_clk_n   ),
    .tmds_data_p          ( tmds_data_p  ),   // TMDS 数据通道
    .tmds_data_n          ( tmds_data_n  ),
    //用户接口  
    .video_vs             ( rd_vsync   ),   // HDMI场信号  
    .h_disp               ( h_disp     ),   // HDMI屏水平分辨率
    .v_disp               ( v_disp     ),   // HDMI屏垂直分辨率   
    .pixel_xpos           ( pixel_xpos ),   // 返回像素x坐标
    .pixel_ypos           ( pixel_ypos ),   // 返回像素y坐标
    .data_in              ( rd_data    ),   // 数据输入 
    .data_req             ( rdata_req  )    // 请求数据输入   
);   

endmodule