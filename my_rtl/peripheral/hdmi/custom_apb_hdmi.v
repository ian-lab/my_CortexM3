

module custom_apb_hdmi(
    input                 PCLK,    
    input                 PRESETN,  
    //APB
    input                 PSEL,
    input      [11 : 2]   PADDR,
    input                 PENABLE,
    input                 PWRITE,
    input      [31:0]     PWDATA,

    output     [31:0]     PRDATA,
    output                PREDAY,
    output                PSELVER,
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

assign PREDAY = 1'b1;
assign PSELVER = 1'b0;

reg [7:0] threshold;  // 二值化阈值
reg [1:0] disp_choice; // 选择显示哪种视频 00 原始图像 01 灰度图 10 二值化图


wire write_en = PSEL & PWRITE & (~PENABLE);
reg wr_en_reg;

always@(posedge PCLK or negedge PRESETN) begin
  if(~PRESETN) 
    wr_en_reg <= 1'b0;
  else if(write_en) 
    wr_en_reg <= 1'b1;
  else 
    wr_en_reg <= 1'b0;
end

always @(posedge PCLK or negedge PRESETN) begin
    if(~PRESETN) begin
        threshold = 8'd68;
    end 
    else if(wr_en_reg & (PADDR[11:2] == 10'd00)) begin
        threshold = PWDATA[7:0];
    end
    else 
        threshold = threshold;
end

always @(posedge PCLK or negedge PRESETN) begin
    if(~PRESETN) begin
        disp_choice = 2'd00;
    end 
    else if(wr_en_reg & (PADDR[11:2] == 10'd01)) begin
        disp_choice = PWDATA[1:0];
    end
    else 
        disp_choice = disp_choice;
end

ov5640_hdmi u_ov5640_hdmi(
  .sys_clk      ( PCLK         ),
  .sys_rst_n    ( PRESETN      ),

  .disp_choice  ( disp_choice  ),
  .threshold    ( threshold    ),

  .cam_pclk     ( cam_pclk     ),
  .cam_vsync    ( cam_vsync    ),
  .cam_href     ( cam_href     ),
  .cam_data     ( cam_data     ),
  .cam_rst_n    ( cam_rst_n    ),
  .cam_pwdn     ( cam_pwdn     ),
  .cam_scl      ( cam_scl      ),
  .cam_sda      ( cam_sda      ),
 
  .ddr3_dq      ( ddr3_dq      ),
  .ddr3_dqs_n   ( ddr3_dqs_n   ),
  .ddr3_dqs_p   ( ddr3_dqs_p   ),
  .ddr3_addr    ( ddr3_addr    ),
  .ddr3_ba      ( ddr3_ba      ),
  .ddr3_ras_n   ( ddr3_ras_n   ),
  .ddr3_cas_n   ( ddr3_cas_n   ),
  .ddr3_we_n    ( ddr3_we_n    ),
  .ddr3_reset_n ( ddr3_reset_n ),
  .ddr3_ck_p    ( ddr3_ck_p    ),
  .ddr3_ck_n    ( ddr3_ck_n    ),
  .ddr3_cke     ( ddr3_cke     ),
  .ddr3_cs_n    ( ddr3_cs_n    ),
  .ddr3_dm      ( ddr3_dm      ),
  .ddr3_odt     ( ddr3_odt     ),

  .tmds_clk_p   ( tmds_clk_p   ),
  .tmds_clk_n   ( tmds_clk_n   ),
  .tmds_data_p  ( tmds_data_p  ),
  .tmds_data_n  ( tmds_data_n  )
);



// reg [7:0] memory [memory_depth - 1 : 0];

// wire write_en = PSEL & PWRITE & (~PENABLE);
// reg wr_en_reg;

// always@(posedge PCLK or negedge PRESETN) begin
//   if(~PRESETN) 
//     wr_en_reg <= 1'b0;
//   else if(write_en) 
//     wr_en_reg <= 1'b1;
//   else 
//     wr_en_reg <= 1'b0;
// end

// always @(posedge PCLK or negedge PRESETN) begin
//     if(~PRESETN) begin
        
//     end else if(wr_en_reg) begin
//         memory[{PADDR[11:2], 2'b00}] <= PWDATA[ 7: 0];
//         memory[{PADDR[11:2], 2'b01}] <= PWDATA[15: 8];
//         memory[{PADDR[11:2], 2'b10}] <= PWDATA[23:16];
//         memory[{PADDR[11:2], 2'b11}] <= PWDATA[31:24];
//     end
// end

// wire read_en = PSEL & (~PWRITE);
// assign PRDATA = read_en ? { memory[{PADDR[11:2], 2'b11}], memory[{PADDR[11:2], 2'b10}],
//                             memory[{PADDR[11:2], 2'b01}], memory[{PADDR[11:2], 2'b00}] } : {32{1'b0}};

endmodule