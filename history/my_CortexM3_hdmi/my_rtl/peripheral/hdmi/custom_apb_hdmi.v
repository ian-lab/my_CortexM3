module custom_apb_hdmi #(
    parameter memory_depth = 784
)
(
    input               PCLK,    
    input               PRESETN,  
    //APB
    input               PSEL,
    input  [11 : 2]     PADDR,
    input               PENABLE,
    input               PWRITE,
    input  [31:0]       PWDATA,

    output [31:0]       PRDATA,
    output              PREDAY,
    output              PSELVER,
    //HDMI
    output              hdmi_oen,        
    output              TMDS_clk_n,      
    output              TMDS_clk_p,      
    output [2:0]        TMDS_data_n,
    output [2:0]        TMDS_data_p
    
);
localparam RAM_DEPTH  = 784;
localparam RAM_WIDTH  = 8;
localparam ADDR_WIDTH = 10;
// HDMI  显示相关参数及信号
parameter H_img_0 = 28;
parameter W_img_0 = 28;
parameter H_img_1 = 28;
parameter W_img_1 = 28;

parameter x_img_0 = 100;
parameter y_img_0 = 100;
parameter x_img_1 = 400;
parameter y_img_1 = 100;

wire video_clk;
wire video_clk_5x;

wire region_0_active;
wire region_1_active;
wire vs;

wire [7:0] img_r_hdmi;
wire [7:0] img_g_hdmi;
wire [7:0] img_b_hdmi;

// 读取数据到HDMI显示相关信号
reg  [ADDR_WIDTH - 1:0] rd_addr_img_rgb_ram = 0;
wire [ RAM_WIDTH - 1:0] rd_data_img_rgb_ram;


assign PREDAY = 1'b1;
assign PSELVER = 1'b0;

(*rom_style="block"*) reg [7:0] memory [memory_depth - 1 : 0];

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
        
    end else if(wr_en_reg) begin
        memory[{PADDR[11:2], 2'b00}] <= PWDATA[ 7: 0];
        memory[{PADDR[11:2], 2'b01}] <= PWDATA[15: 8];
        memory[{PADDR[11:2], 2'b10}] <= PWDATA[23:16];
        memory[{PADDR[11:2], 2'b11}] <= PWDATA[31:24];
    end
end

wire read_en = PSEL & (~PWRITE);
assign PRDATA = read_en ? { memory[{PADDR[11:2], 2'b11}], memory[{PADDR[11:2], 2'b10}],
                            memory[{PADDR[11:2], 2'b01}], memory[{PADDR[11:2], 2'b00}] } : {32{1'b0}};


//----------------------------------------------------------
// HDMI显示
//----------------------------------------------------------
always @(posedge video_clk) begin
    if(region_0_active)
        rd_addr_img_rgb_ram <= rd_addr_img_rgb_ram + 1'b1;
    else
        rd_addr_img_rgb_ram <= rd_addr_img_rgb_ram;
    if(vs)
        rd_addr_img_rgb_ram <= 16'b0;
end

assign rd_data_img_rgb_ram = memory[rd_addr_img_rgb_ram];

// hdmi显示
assign img_r_hdmi = region_0_active ? rd_data_img_rgb_ram : (region_1_active ? 8'hff : 8'b0);
assign img_g_hdmi = region_0_active ? rd_data_img_rgb_ram : (region_1_active ? 8'hff : 8'b0);
assign img_b_hdmi = region_0_active ? rd_data_img_rgb_ram : (region_1_active ? 8'hff : 8'b0);

img2hdmi #(
  .H_img_0  (H_img_0  ),
  .W_img_0  (W_img_0  ),
  .H_img_1  (H_img_1  ),
  .W_img_1  (W_img_1  ),
  .x_img_0  (x_img_0  ),
  .y_img_0  (y_img_0  ),
  .x_img_1  (x_img_1  ),
  .y_img_1  (y_img_1  )
)
u_img2hdmi(
  .video_clk       ( video_clk       ),
  .video_clk_5x    ( video_clk_5x    ),
  .rst             ( 1'b0            ),
 
  .img_r           ( img_r_hdmi      ),
  .img_g           ( img_g_hdmi      ),
  .img_b           ( img_b_hdmi      ),
 
  .region_0_active ( region_0_active ),
  .region_1_active ( region_1_active ),
  .vs              ( vs              ),
 
  .hdmi_oen        ( hdmi_oen        ),
  .TMDS_clk_n      ( TMDS_clk_n      ),
  .TMDS_clk_p      ( TMDS_clk_p      ),
  .TMDS_data_n     ( TMDS_data_n     ),
  .TMDS_data_p     ( TMDS_data_p     )
);


video_clk instance_name(
  .clk_in1(PCLK),

  .clk_out1(video_clk),    
  .clk_out2(video_clk_5x), 
  
  .reset(1'b0), 
  .locked()        
);      

endmodule