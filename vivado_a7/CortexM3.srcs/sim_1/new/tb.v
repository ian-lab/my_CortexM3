`timescale 1ns/1ns     

module tb_CortexM3;    

// 1000ns-1Mhz, 100ns-10Mhz, 20ns-50Mhz
// CortexM3 Parameters
parameter PERIOD      = 20;
parameter SimPresent  = 0;

// CortexM3 Inputs
reg   CLK50m                               = 0 ;
reg   RSTn                                 = 0 ;
reg   SWCLK                                = 0 ;
reg   RXD                                  = 0 ;
reg   KEY                                  = 0 ;
reg   cam_pclk                             = 0 ;
reg   cam_vsync                            = 0 ;
reg   cam_href                             = 0 ;
reg   [7:0]  cam_data                      = 0 ;

// CortexM3 Outputs
wire  TXD                                  ;
wire  [3:0]  ledNumOut                     ;
wire  cam_rst_n                            ;
wire  cam_pwdn                             ;
wire  cam_scl                              ;
wire  [13:0]  ddr3_addr                    ;
wire  [2:0]  ddr3_ba                       ;
wire  ddr3_ras_n                           ;
wire  ddr3_cas_n                           ;
wire  ddr3_we_n                            ;
wire  ddr3_reset_n                         ;
wire  [0:0]  ddr3_ck_p                     ;
wire  [0:0]  ddr3_ck_n                     ;
wire  [0:0]  ddr3_cke                      ;
wire  [0:0]  ddr3_cs_n                     ;
wire  [3:0]  ddr3_dm                       ;
wire  [0:0]  ddr3_odt                      ;
wire  tmds_clk_p                           ;
wire  tmds_clk_n                           ;
wire  [2:0]  tmds_data_p                   ;
wire  [2:0]  tmds_data_n                   ;

// CortexM3 Bidirs
wire  SWDIO                                ;
wire  cam_sda                              ;
wire  [31:0]  ddr3_dq                      ;
wire  [3:0]  ddr3_dqs_n                    ;
wire  [3:0]  ddr3_dqs_p                    ;


initial
begin
    forever #(PERIOD/2)  CLK50m=~CLK50m;
end

initial
begin
    RSTn  =  1;
    #(PERIOD) RSTn  =  0;
    #(PERIOD) RSTn  =  1;

end

CortexM3 #(
    .SimPresent ( SimPresent ))
 u_CortexM3 (
    .CLK50m                  ( CLK50m               ),
    .RSTn                    ( RSTn                 ),
    .SWCLK                   ( SWCLK                ),
    .RXD                     ( RXD                  ),
    .KEY                     ( KEY                  ),
    .cam_pclk                ( cam_pclk             ),
    .cam_vsync               ( cam_vsync            ),
    .cam_href                ( cam_href             ),
    .cam_data                ( cam_data      [7:0]  ),

    .TXD                     ( TXD                  ),
    .ledNumOut               ( ledNumOut     [3:0]  ),
    .cam_rst_n               ( cam_rst_n            ),
    .cam_pwdn                ( cam_pwdn             ),
    .cam_scl                 ( cam_scl              ),
    .ddr3_addr               ( ddr3_addr     [13:0] ),
    .ddr3_ba                 ( ddr3_ba       [2:0]  ),
    .ddr3_ras_n              ( ddr3_ras_n           ),
    .ddr3_cas_n              ( ddr3_cas_n           ),
    .ddr3_we_n               ( ddr3_we_n            ),
    .ddr3_reset_n            ( ddr3_reset_n         ),
    .ddr3_ck_p               ( ddr3_ck_p     [0:0]  ),
    .ddr3_ck_n               ( ddr3_ck_n     [0:0]  ),
    .ddr3_cke                ( ddr3_cke      [0:0]  ),
    .ddr3_cs_n               ( ddr3_cs_n     [0:0]  ),
    .ddr3_dm                 ( ddr3_dm       [3:0]  ),
    .ddr3_odt                ( ddr3_odt      [0:0]  ),
    .tmds_clk_p              ( tmds_clk_p           ),
    .tmds_clk_n              ( tmds_clk_n           ),
    .tmds_data_p             ( tmds_data_p   [2:0]  ),
    .tmds_data_n             ( tmds_data_n   [2:0]  ),

    .SWDIO                   ( SWDIO                ),
    .cam_sda                 ( cam_sda              ),
    .ddr3_dq                 ( ddr3_dq       [31:0] ),
    .ddr3_dqs_n              ( ddr3_dqs_n    [3:0]  ),
    .ddr3_dqs_p              ( ddr3_dqs_p    [3:0]  )
);

initial
begin
    #(PERIOD * 100)
    $stop;
end

endmodule