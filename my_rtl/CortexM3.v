module CortexM3 #(
    parameter                   SimPresent = 0
)   (
    input       wire            CLK50m,
    input       wire            RSTn,

    // SWD
   inout       wire            SWDIO,
   input       wire            SWCLK,

    // UART
    output      wire            TXD,
    input       wire            RXD,

    //LED
    output      wire [3:0]      ledNumOut,

    //BUTTON
    input                       KEY
);

//------------------------------------------------------------------------------
// GLOBAL BUF
//------------------------------------------------------------------------------

wire            clk;
wire            swck;

// generate 
//         if(SimPresent) begin : SimClock

                assign swck = SWCLK;
                assign clk  = CLK50m;
        
//         end else begin : SynClock

//                 BUFG sw_clk(
//                         .I                   (SWCLK),
//                         .O                   (swck)
//                 );

//                 BUFG sys_clk(
//                         .I                   (CLK50m),
//                         .O                   (clk)
//                 );                
//         end    
// endgenerate         


//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------
wire            SWDO;
wire            SWDOEN;
wire            SWDI;

// generate
//     if(SimPresent) begin : SimIOBuf

        assign SWDI = SWDIO;
        assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//     end else begin : SynIOBuf

//         IOBUF SWIOBUF(
//             .I   (SWDO),
//             .T   (SWDOEN),
//             .O   (SWDI),
//             .IO  (SWDIO)
//         );

//     end
// endgenerate

//------------------------------------------------------------------------------
// RESET
//------------------------------------------------------------------------------

wire            SYSRESETREQ;
reg             cpuresetn;

always @(posedge clk or negedge RSTn)begin
    if (~RSTn) 
        cpuresetn <= 1'b0;
    else if (SYSRESETREQ) 
        cpuresetn <= 1'b0;
    else 
        cpuresetn <= 1'b1;
end

wire        SLEEPing;

//------------------------------------------------------------------------------
// DEBUG CONFIG
//------------------------------------------------------------------------------

wire            CDBGPWRUPREQ;
reg             CDBGPWRUPACK;

always @(posedge clk or negedge RSTn)begin
    if (~RSTn) 
        CDBGPWRUPACK <= 1'b0;
    else 
        CDBGPWRUPACK <= CDBGPWRUPREQ;
end

//------------------------------------------------------------------------------
// INTERRUPT 
//------------------------------------------------------------------------------

wire    [239:0] IRQ;


//------------------------------------------------------------------------------
// CORE BUS
//------------------------------------------------------------------------------

// CPU I-Code 
wire    [31:0]  HADDRI;
wire    [1:0]   HTRANSI;
wire    [2:0]   HSIZEI;
wire    [2:0]   HBURSTI;
wire    [3:0]   HPROTI;
wire    [31:0]  HRDATAI;
wire            HREADYI;
wire    [1:0]   HRESPI;

// CPU D-Code 
wire    [31:0]  HADDRD;
wire    [1:0]   HTRANSD;
wire    [2:0]   HSIZED;
wire    [2:0]   HBURSTD;
wire    [3:0]   HPROTD;
wire    [31:0]  HWDATAD;
wire            HWRITED;
wire    [31:0]  HRDATAD;
wire            HREADYD;
wire    [1:0]   HRESPD;
wire    [1:0]   HMASTERD;

// CPU System bus 
wire    [31:0]  HADDRS;
wire    [1:0]   HTRANSS;
wire            HWRITES;
wire    [2:0]   HSIZES;
wire    [31:0]  HWDATAS;
wire    [2:0]   HBURSTS;
wire    [3:0]   HPROTS;
wire            HREADYS;
wire    [31:0]  HRDATAS;
wire    [1:0]   HRESPS;
wire    [1:0]   HMASTERS;
wire            HMASTERLOCKS;


//------------------------------------------------------------------------------
// Cortex-M3 processor 
//------------------------------------------------------------------------------

cortexm3ds_logic ulogic(
    // PMU
    .ISOLATEn                           (1'b1),
    .RETAINn                            (1'b1),

    // RESETS
    .PORESETn                           (RSTn),
    .SYSRESETn                          (cpuresetn),
    .SYSRESETREQ                        (SYSRESETREQ),
    .RSTBYPASS                          (1'b0),
    .CGBYPASS                           (1'b0),
    .SE                                 (1'b0),

    // CLOCKS
    .FCLK                               (clk),
    .HCLK                               (clk),
    .TRACECLKIN                         (1'b0),

    // SYSTICK
    // .STCLK                              (1'b0),
    // .STCALIB                            (26'b0),
    // .AUXFAULT                           (32'b0),
    .STCLK                              (1'b1),                                   
    .STCALIB                            ({1'b1, 1'b0, 24'h003D08F}),// [23:0] -> 10ms需要的脉冲数
    .AUXFAULT                           (32'b0),   

    // CONFIG - SYSTEM
    .BIGEND                             (1'b0),
    .DNOTITRANS                         (1'b1),
    
    // SWJDAP
    .nTRST                              (1'b1),
    .SWDITMS                            (SWDI),
    .SWCLKTCK                           (swck),
    .TDI                                (1'b0),
    .CDBGPWRUPACK                       (CDBGPWRUPACK),
    .CDBGPWRUPREQ                       (CDBGPWRUPREQ),
    .SWDO                               (SWDO),
    .SWDOEN                             (SWDOEN),

    // IRQS
    .INTISR                             (IRQ),
    .INTNMI                             (1'b0),
    
    // I-CODE BUS
    .HREADYI                            (HREADYI),
    .HRDATAI                            (HRDATAI),
    .HRESPI                             (HRESPI),
    .IFLUSH                             (1'b0),
    .HADDRI                             (HADDRI),
    .HTRANSI                            (HTRANSI),
    .HSIZEI                             (HSIZEI),
    .HBURSTI                            (HBURSTI),
    .HPROTI                             (HPROTI),

    // D-CODE BUS
    .HREADYD                            (HREADYD),
    .HRDATAD                            (HRDATAD),
    .HRESPD                             (HRESPD),
    .EXRESPD                            (1'b0),
    .HADDRD                             (HADDRD),
    .HTRANSD                            (HTRANSD),
    .HSIZED                             (HSIZED),
    .HBURSTD                            (HBURSTD),
    .HPROTD                             (HPROTD),
    .HWDATAD                            (HWDATAD),
    .HWRITED                            (HWRITED),
    .HMASTERD                           (HMASTERD),

    // SYSTEM BUS
    .HREADYS                            (HREADYS),
    .HRDATAS                            (HRDATAS),
    .HRESPS                             (HRESPS),
    .EXRESPS                            (1'b0),
    .HADDRS                             (HADDRS),
    .HTRANSS                            (HTRANSS),
    .HSIZES                             (HSIZES),
    .HBURSTS                            (HBURSTS),
    .HPROTS                             (HPROTS),
    .HWDATAS                            (HWDATAS),
    .HWRITES                            (HWRITES),
    .HMASTERS                           (HMASTERS),
    .HMASTLOCKS                         (HMASTERLOCKS),

    // SLEEP
    .RXEV                               (1'b0),
    .SLEEPHOLDREQn                      (1'b1),
    .SLEEPING                           (SLEEPing),
    
    // EXTERNAL DEBUG REQUEST
    .EDBGRQ                             (1'b0),
    .DBGRESTART                         (1'b0),
    
    // DAP HMASTER OVERRIDE
    .FIXMASTERTYPE                      (1'b0),

    // WIC
    .WICENREQ                           (1'b0),

    // TIMESTAMP INTERFACE
    .TSVALUEB                           (48'b0),

    // CONFIG - DEBUG
    .DBGEN                              (1'b1),
    .NIDEN                              (1'b1),
    .MPUDISABLE                         (1'b0)
);
//------------------------------------------------------------------------------
// AHB L1 总线矩阵
// s0:Dbus s1:Ibus s2:sysbus 
// m0:ITCM m1:DTCM m2:APB_Bridge
// s0 -> m0
// s1 -> m0
// s2 -> m1 m2
//------------------------------------------------------------------------------

// M0 ITCM 端口
wire        HSEL_ITCM;
wire [1:0]  HTRANS_ITCM;
wire [2:0]  HSIZE_ITCM;
wire        HWRITE_ITCM;
wire [31:0] HADDR_ITCM;
wire [31:0] HWDATA_ITCM;
wire        HREADYOUT_ITCM;
wire [1:0]  HRESP_ITCM;
wire [31:0] HRDATA_ITCM; 
wire [2:0]  HBURST_ITCM;
wire [1:0]  HMASTER_ITCM;
wire [3:0]  HPROT_ITCM;
wire        HMASTLOCK_ITCM;
wire        HREADY_ITCM; 

wire [13:0] ITCMADDR;
wire [31:0] ITCMRDATA,ITCMWDATA;
wire [3:0]  ITCMWRITE;
wire        ITCMCS;

// M1 DTCM 端口
wire        HSEL_DTCM;
wire [1:0]  HTRANS_DTCM;
wire [2:0]  HSIZE_DTCM;
wire        HWRITE_DTCM;
wire [31:0] HADDR_DTCM;
wire [31:0] HWDATA_DTCM;
wire        HREADYOUT_DTCM;
wire [1:0]  HRESP_DTCM;
wire [31:0] HRDATA_DTCM;
wire [2:0]  HBURST_DTCM;
wire [1:0]  HMASTER_DTCM;
wire [3:0]  HPROT_DTCM;
wire        HMASTLOCK_DTCM;
wire        HREADY_DTCM; 

wire [13:0] DTCMADDR;
wire [31:0] DTCMRDATA,DTCMWDATA;
wire [3:0]  DTCMWRITE;
wire        DTCMCS;

// M2 APB Bridge 端口
wire        HSEL_apb_bridge;
wire        HREADY_apb_bridge;
wire [1:0]  HTRANS_apb_bridge;
wire [2:0]  HSIZE_apb_bridge;
wire [3:0]  HPROT_apb_bridge;
wire        HWRITE_apb_bridge;
wire [31:0] HADDR_apb_bridge;
wire [31:0] HWDATA_apb_bridge;
wire        HREADYOUT_apb_bridge;
wire [1:0]  HRESP_apb_bridge;
wire [31:0] HRDATA_apb_bridge;
wire [2:0]  HBURST_apb_bridge;
wire [1:0]  HMASTER_apb_bridge;
wire        HMASTLOCK_apb_bridge;

wire [15:0] PADDR;    
wire        PENABLE;  
wire        PWRITE;   
wire [3:0]  PSTRB;    
wire [2:0]  PPROT;    
wire [31:0] PWDATA;   
wire        PSEL;     
wire        APBACTIVE;                  
wire [31:0] PRDATA;   
wire        PREADY;  
wire        PSLVERR;


//------------------------------------------------------------------------------
// AHB总线矩阵
//------------------------------------------------------------------------------
L1_AHBMatrix u_L1_AHBMatrix(
    .HCLK        ( clk       ),
    .HRESETn     ( cpuresetn ),
 
    .REMAP       ( 4'b0      ),
 
    .HSELS1      ( 1'b1      ),
    .HADDRS1     ( HADDRI    ),
    .HTRANSS1    ( HTRANSI   ),
    .HWRITES1    ( 1'b0      ),
    .HSIZES1     ( HSIZEI    ),
    .HBURSTS1    ( HBURSTI   ),
    .HPROTS1     ( HPROTI    ),
    .HMASTERS1   ( 4'b0      ),
    .HWDATAS1    ( 32'b0     ),
    .HMASTLOCKS1 ( 1'b0      ),
    .HREADYS1    ( HREADYI   ),
    .HRDATAS1    ( HRDATAI   ),
    .HREADYOUTS1 ( HREADYI   ),
    .HRESPS1     ( HRESPI    ),
 
    .HSELS0      ( 1'b1            ),
    .HADDRS0     ( HADDRD          ),
    .HTRANSS0    ( HTRANSD         ),
    .HWRITES0    ( HWRITED         ),
    .HSIZES0     ( HSIZED          ),
    .HBURSTS0    ( HBURSTD         ),
    .HPROTS0     ( HPROTD          ),
    .HMASTERS0   ( {2'b0,HMASTERD} ),
    .HWDATAS0    ( HWDATAD         ),
    .HMASTLOCKS0 ( 1'b0            ),
    .HREADYS0    ( HREADYD         ),
    .HRDATAS0    ( HRDATAD         ),
    .HREADYOUTS0 ( HREADYD         ),
    .HRESPS0     ( HRESPD          ),
 
    .HSELS2      ( 1'b1            ),
    .HADDRS2     ( HADDRS          ),
    .HTRANSS2    ( HTRANSS         ),
    .HWRITES2    ( HWRITES         ),
    .HSIZES2     ( HSIZES          ),
    .HBURSTS2    ( HBURSTS         ),
    .HPROTS2     ( HPROTS          ),
    .HMASTERS2   ( {2'b0,HMASTERS} ),
    .HWDATAS2    ( HWDATAS         ),
    .HMASTLOCKS2 ( HMASTERLOCKS    ),
    .HREADYS2    ( HREADYS         ),
    .HREADYOUTS2 ( HREADYS         ),
    .HRDATAS2    ( HRDATAS         ),
    .HRESPS2     ( HRESPS          ),       
 
    .HRDATAM0    ( HRDATA_ITCM    ),
    .HREADYOUTM0 ( HREADYOUT_ITCM ),
    .HRESPM0     ( HRESP_ITCM     ),
    .HSELM0      ( HSEL_ITCM      ),
    .HADDRM0     ( HADDR_ITCM     ),
    .HTRANSM0    ( HTRANS_ITCM    ),
    .HWRITEM0    ( HWRITE_ITCM    ),
    .HSIZEM0     ( HSIZE_ITCM     ),
    .HBURSTM0    ( HBURST_ITCM    ),
    .HPROTM0     ( HPROT_ITCM     ),
    .HMASTERM0   ( HMASTER_ITCM   ),
    .HWDATAM0    ( HWDATA_ITCM    ),
    .HMASTLOCKM0 ( HMASTLOCK_ITCM ),
    .HREADYMUXM0 ( HREADY_ITCM    ),
 
    .HRDATAM1    ( HRDATA_DTCM    ),
    .HREADYOUTM1 ( HREADYOUT_DTCM ),
    .HRESPM1     ( HRESP_DTCM     ),
    .HSELM1      ( HSEL_DTCM      ),
    .HADDRM1     ( HADDR_DTCM     ),
    .HTRANSM1    ( HTRANS_DTCM    ),
    .HWRITEM1    ( HWRITE_DTCM    ),
    .HSIZEM1     ( HSIZE_DTCM     ),
    .HBURSTM1    ( HBURST_DTCM    ),
    .HPROTM1     ( HPROT_DTCM     ),
    .HMASTERM1   ( HMASTER_DTCM   ),
    .HWDATAM1    ( HWDATA_DTCM    ),
    .HMASTLOCKM1 ( HMASTLOCK_DTCM ),
    .HREADYMUXM1 ( HREADY_DTCM    ),
 
    .HRDATAM2    ( HRDATA_apb_bridge    ),
    .HREADYOUTM2 ( HREADYOUT_apb_bridge ),
    .HRESPM2     ( HRESP_apb_bridge     ),
    .HSELM2      ( HSEL_apb_bridge      ),
    .HADDRM2     ( HADDR_apb_bridge     ),
    .HTRANSM2    ( HTRANS_apb_bridge    ),
    .HWRITEM2    ( HWRITE_apb_bridge    ),
    .HSIZEM2     ( HSIZE_apb_bridge     ),
    .HBURSTM2    ( HBURST_apb_bridge    ),
    .HPROTM2     ( HPROT_apb_bridge     ),
    .HMASTERM2   ( HMASTER_apb_bridge   ),
    .HWDATAM2    ( HWDATA_apb_bridge    ),
    .HMASTLOCKM2 ( HMASTLOCK_apb_bridge ),
    .HREADYMUXM2 ( HREADY_apb_bridge    ),

    .SCANENABLE  ( 1'b0  ),
    .SCANINHCLK  ( 1'b0  ),
    .SCANOUTHCLK (       )
);
//------------------------------------------------------------------------------
// AHB ITCM
// AHB总线M0
//------------------------------------------------------------------------------
cmsdk_ahb_to_sram #(
    .AW  (16)
) AhbItcm (
    .HCLK        ( clk            ),
    .HRESETn     ( cpuresetn      ),
 
    .HSEL        ( HSEL_ITCM      ),
    .HREADY      ( HREADY_ITCM    ),
    .HTRANS      ( HTRANS_ITCM    ),
    .HSIZE       ( HSIZE_ITCM     ),
    .HWRITE      ( HWRITE_ITCM    ),
    .HADDR       ( HADDR_ITCM     ),
    .HWDATA      ( HWDATA_ITCM    ),
    .HREADYOUT   ( HREADYOUT_ITCM ),
    .HRESP       ( HRESP_ITCM[0]  ),
    .HRDATA      ( HRDATA_ITCM    ),
 
    .SRAMRDATA   ( ITCMRDATA      ),
    .SRAMADDR    ( ITCMADDR       ),
    .SRAMWEN     ( ITCMWRITE      ),
    .SRAMWDATA   ( ITCMWDATA      ),
    .SRAMCS      ( ITCMCS         )   
);
assign  HRESP_ITCM[1] = 1'b0;

cmsdk_fpga_sram #(
    .AW  (14)
) ITCM (
    .CLK       ( clk       ),
    .ADDR      ( ITCMADDR  ),
    .WDATA     ( ITCMWDATA ),
    .WREN      ( ITCMWRITE ),
    .CS        ( ITCMCS    ),
    .RDATA     ( ITCMRDATA )
);

//------------------------------------------------------------------------------
// AHB DTCM
// AHB总线M1
//------------------------------------------------------------------------------
cmsdk_ahb_to_sram #(
    .AW   (16)
) AhbDtcm (
    .HCLK        ( clk            ),
    .HRESETn     ( cpuresetn      ),
 
    .HSEL        ( HSEL_DTCM      ),
    .HREADY      ( HREADY_DTCM    ),
    .HTRANS      ( HTRANS_DTCM    ),
    .HSIZE       ( HSIZE_DTCM     ),
    .HWRITE      ( HWRITE_DTCM    ),
    .HADDR       ( HADDR_DTCM     ),
    .HWDATA      ( HWDATA_DTCM    ),
    .HREADYOUT   ( HREADYOUT_DTCM ),
    .HRESP       ( HRESP_DTCM[0]  ),
    .HRDATA      ( HRDATA_DTCM    ),
 
    .SRAMRDATA   ( DTCMRDATA      ),
    .SRAMADDR    ( DTCMADDR       ),
    .SRAMWEN     ( DTCMWRITE      ),
    .SRAMWDATA   ( DTCMWDATA      ),
    .SRAMCS      ( DTCMCS         )
);
assign  HRESP_DTCM[1]    =   1'b0;

cmsdk_fpga_sram #(
    .AW       (14)
) DTCM    (
    .CLK         ( clk       ),
    .ADDR        ( DTCMADDR  ),
    .WDATA       ( DTCMWDATA ),
    .WREN        ( DTCMWRITE ),
    .CS          ( DTCMCS    ),
    .RDATA       ( DTCMRDATA )
);

//------------------------------------------------------------------------------
// AHB2APB Bridge
// AHB总线M2
//------------------------------------------------------------------------------
cmsdk_ahb_to_apb #(
    .ADDRWIDTH      (16),
    .REGISTER_RDATA (1),
    .REGISTER_WDATA (1)
) u_cmsdk_ahb_to_apb(
    .HCLK      ( clk         ),
    .HRESETn   ( cpuresetn   ),
    .PCLKEN    ( 1'b1        ),
 
    .HSEL      ( HSEL_apb_bridge      ),
    .HADDR     ( HADDR_apb_bridge     ),
    .HTRANS    ( HTRANS_apb_bridge    ),
    .HSIZE     ( HSIZE_apb_bridge     ),
    .HPROT     ( HPROT_apb_bridge     ),
    .HWRITE    ( HWRITE_apb_bridge    ),
    .HREADY    ( HREADY_apb_bridge    ),
    .HWDATA    ( HWDATA_apb_bridge    ),
    .HREADYOUT ( HREADYOUT_apb_bridge ),
    .HRDATA    ( HRDATA_apb_bridge    ),
    .HRESP     ( HRESP_apb_bridge[0]  ),
 
    .PADDR     ( PADDR     ),
    .PENABLE   ( PENABLE   ),
    .PWRITE    ( PWRITE    ),
    .PSTRB     ( PSTRB     ),
    .PPROT     ( PPROT     ),
    .PWDATA    ( PWDATA    ),
    .PSEL      ( PSEL      ),
    .APBACTIVE ( APBACTIVE ),
    .PRDATA    ( PRDATA    ),
    .PREADY    ( PREADY    ),
    .PSLVERR   ( PSLVERR   )
);
assign  HRESP_apb_bridge[1]    =   1'b0;

//------------------------------------------------------------------------------
// APB slave mux
//------------------------------------------------------------------------------
//apb uart 端口
wire            PSEL_APB_UART;
wire            PREADY_APB_UART;
wire    [31:0]  PRDATA_APB_UART;
wire            PSLVERR_APB_UART;
//apb led 端口
wire            PSEL_APB_LED;
wire            PREADY_APB_LED;
wire    [31:0]  PRDATA_APB_LED;
wire            PSLVERR_APB_LED;
//apb button 端口
wire            PSEL_APB_BUTTON;
wire            PREADY_APB_BUTTON;
wire    [31:0]  PRDATA_APB_BUTTON;
wire            PSLVERR_APB_BUTTON;
//apb hdmi 端口
wire            PSEL_APB_HDMI;
wire            PREADY_APB_HDMI;
wire    [31:0]  PRDATA_APB_HDMI;
wire            PSLVERR_APB_HDMI;
cmsdk_apb_slave_mux #(
    .PORT0_ENABLE  (1), // UART
    .PORT1_ENABLE  (1), // LED
    .PORT2_ENABLE  (1), // BUTTON
    .PORT3_ENABLE  (1), // HDMI
    .PORT4_ENABLE  (0),
    .PORT5_ENABLE  (0),
    .PORT6_ENABLE  (0),
    .PORT7_ENABLE  (0),
    .PORT8_ENABLE  (0),
    .PORT9_ENABLE  (0),
    .PORT10_ENABLE (0),
    .PORT11_ENABLE (0),
    .PORT12_ENABLE (0),
    .PORT13_ENABLE (0),
    .PORT14_ENABLE (0),
    .PORT15_ENABLE (0)
) u_cmsdk_apb_slave_mux(
    .DECODE4BIT ( PADDR[15:12] ),
    .PSEL       ( PSEL         ),

    .PSEL0      ( PSEL_APB_UART    ),
    .PREADY0    ( PREADY_APB_UART  ),
    .PRDATA0    ( PRDATA_APB_UART  ),
    .PSLVERR0   ( PSLVERR_APB_UART ),
 
    .PSEL1      ( PSEL_APB_LED    ),
    .PREADY1    ( PREADY_APB_LED  ),
    .PRDATA1    ( PRDATA_APB_LED  ),
    .PSLVERR1   ( PSLVERR_APB_LED ),

    .PSEL2      ( PSEL_APB_BUTTON    ),
    .PREADY2    ( PREADY_APB_BUTTON  ),
    .PRDATA2    ( PRDATA_APB_BUTTON  ),
    .PSLVERR2   ( PSLVERR_APB_BUTTON ),

    .PSEL3      ( PSEL_APB_HDMI     ),
    .PREADY3    ( PREADY_APB_HDMI   ),
    .PRDATA3    ( PRDATA_APB_HDMI   ),
    .PSLVERR3   ( PSLVERR_APB_HDMI  ),

    .PSEL4      (       ),
    .PREADY4    (1'b0   ),
    .PRDATA4    (32'b0  ),
    .PSLVERR4   (1'b0   ),

    .PSEL5      (       ),
    .PREADY5    (1'b0   ),
    .PRDATA5    (32'b0  ),
    .PSLVERR5   (1'b0   ),

    .PSEL6      (       ),
    .PREADY6    (1'b0   ),
    .PRDATA6    (32'b0  ),
    .PSLVERR6   (1'b0   ),

    .PSEL7      (       ),
    .PREADY7    (1'b0   ),
    .PRDATA7    (32'b0  ),
    .PSLVERR7   (1'b0   ),

    .PSEL8      (       ),
    .PREADY8    (1'b0   ),
    .PRDATA8    (32'b0  ),
    .PSLVERR8   (1'b0   ),

    .PSEL9      (       ),
    .PREADY9    (1'b0   ),
    .PRDATA9    (32'b0  ),
    .PSLVERR9   (1'b0   ),

    .PSEL10     (      ),
    .PREADY10   (1'b0  ),
    .PRDATA10   (32'b0 ),
    .PSLVERR10  (1'b0  ),

    .PSEL11     (      ),
    .PREADY11   (1'b0  ),
    .PRDATA11   (32'b0 ),
    .PSLVERR11  (1'b0  ),

    .PSEL12     (      ),
    .PREADY12   (1'b0  ),
    .PRDATA12   (32'b0 ),
    .PSLVERR12  (1'b0  ),

    .PSEL13     (      ),
    .PREADY13   (1'b0  ),
    .PRDATA13   (32'b0 ),
    .PSLVERR13  (1'b0  ),

    .PSEL14     (      ),
    .PREADY14   (1'b0  ),
    .PRDATA14   (32'b0 ),
    .PSLVERR14  (1'b0  ),

    .PSEL15     (      ),
    .PREADY15   (1'b0  ),
    .PRDATA15   (32'b0 ),
    .PSLVERR15  (1'b0  ),
 
    .PREADY     ( PREADY  ),
    .PRDATA     ( PRDATA  ),
    .PSLVERR    ( PSLVERR )
);

//------------------------------------------------------------------------------
// APB UART
//------------------------------------------------------------------------------
wire            TXINT;
wire            RXINT;
wire            TXOVRINT;
wire            RXOVRINT;
wire            UARTINT;  

cmsdk_apb_uart #(
    
)u_cmsdk_apb_uart(
    .PCLK      ( clk              ),
    .PCLKG     ( clk              ),
    .PRESETn   ( cpuresetn        ),
    .PSEL      ( PSEL_APB_UART    ),
    .PADDR     ( PADDR[11:2]      ),
    .PENABLE   ( PENABLE          ),
    .PWRITE    ( PWRITE           ),
    .PWDATA    ( PWDATA           ),
    .ECOREVNUM ( 4'b0             ),
    .PRDATA    ( PRDATA_APB_UART  ),
    .PREADY    ( PREADY_APB_UART  ),
    .PSLVERR   ( PSLVERR_APB_UART ),
 
    .RXD       ( RXD       ),
    .TXD       ( TXD       ),
    .TXEN      ( TXEN      ),
    .BAUDTICK  ( BAUDTICK  ),
    .TXINT     ( TXINT     ),
    .RXINT     ( RXINT     ),
    .TXOVRINT  ( TXOVRINT  ),
    .RXOVRINT  ( RXOVRINT  ),
    .UARTINT   ( UARTINT   )
);

//------------------------------------------------------------------------------
// APB LED
//------------------------------------------------------------------------------
cmsdk_apb3_eg_slave_led #(
    .ADDRWIDTH (12 )
) u_cmsdk_apb3_eg_slave_led(
    .PCLK      ( clk             ),
    .PRESETn   ( cpuresetn       ),
    .PSEL      ( PSEL_APB_LED    ),
    .PADDR     ( PADDR[11:2]     ),
    .PENABLE   ( PENABLE         ),
    .PWRITE    ( PWRITE          ),
    .PWDATA    ( PWDATA          ),
    .ECOREVNUM ( 4'b0            ),
    .PRDATA    ( PRDATA_APB_LED  ),
    .PREADY    ( PREADY_APB_LED  ),
    .PSLVERR   ( PSLVERR_APB_LED ),

    .ledNumOut ( ledNumOut       )
);

//------------------------------------------------------------------------------
// APB BUTTON
//------------------------------------------------------------------------------
wire KEY_IRQ; 
custom_apb_button #(
    .ADDRWIDTH (12 )
) u_custom_apb_button(
    .pclk    ( clk                ),
    .presetn ( cpuresetn          ),
    .psel    ( PSEL_APB_BUTTON    ),
    .paddr   ( PADDR[11:2]        ),
    .penable ( PENABLE            ),
    .pwrite  ( PWRITE             ),
    .pwdata  ( PWDATA             ),
    .prdata  ( PRDATA_APB_BUTTON  ),
    .pready  ( PREADY_APB_BUTTON  ),
    .pslverr ( PSLVERR_APB_BUTTON ),

    .key     ( KEY                ),
    .KEY_IRQ ( KEY_IRQ            )
);
//------------------------------------------------------------------------------
// APB HDMI
//------------------------------------------------------------------------------
custom_apb_hdmi #(
    .memory_depth (784 )
)
u_custom_apb_hdmi(
    .PCLK    ( clk                ),
    .PRESETN ( cpuresetn          ),
    .PSEL    ( PSEL_APB_HDMI      ),
    .PADDR   ( PADDR[11:2]        ),
    .PENABLE ( PENABLE            ),
    .PWRITE  ( PWRITE             ),
    .PWDATA  ( PWDATA             ),
    .PRDATA  ( PRDATA_APB_HDMI    ),
    .PREDAY  ( PREADY_APB_HDMI    ),
    .PSELVER ( PSLVERR_APB_HDMI   )
);

//------------------------------------------------------------------------------
// INTERRUPT 
//------------------------------------------------------------------------------
assign  IRQ     =   {236'b0,KEY_IRQ,TXOVRINT|RXOVRINT,TXINT,RXINT};


endmodule