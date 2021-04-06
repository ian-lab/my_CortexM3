//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2010-2013 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-10 15:27:13 +0100 (Wed, 10 Apr 2013) $
//
//      Revision            : $Revision: 243506 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-00rel0
//
// ----------------------------------------------------------------------------
//  Abstract : FPGA BlockRam/OnChip SRAM
// ----------------------------------------------------------------------------
// The read operation is pipelined. Write operation is not pipelined.

module cmsdk_fpga_sram #(
// --------------------------------------------------------------------------
// Parameters
// --------------------------------------------------------------------------
  parameter AW = 16
 )
 (
  // Inputs
  input  wire          CLK,
  input  wire [AW-1:0] ADDR,
  input  wire [31:0]   WDATA,
  input  wire [3:0]    WREN,
  input  wire          CS,

  // Outputs
  output wire [31:0]   RDATA
  );

// -----------------------------------------------------------------------------
// Constant Declarations
// -----------------------------------------------------------------------------
localparam AWT = ((1<<(AW-0))-1);

  // Memory Array
  reg     [31:0]  BRAM [AWT:0];


    initial begin
      $readmemh("C:/Users/84308/Desktop/my_CortexM3/Keil/image.hex",BRAM);
    end
  
  // Internal signals
  reg     [AW-1:0]  addr_q1;
  wire    [3:0]     write_enable;
  reg               cs_reg;
  wire    [31:0]    read_data;

  assign write_enable[3:0] = WREN[3:0] & {4{CS}};

  always @ (posedge CLK)
    begin
    cs_reg <= CS;
    end

  // Infer Block RAM - syntax is very specific.
  always@(posedge CLK) begin
    if(write_enable[0]) BRAM[ADDR][7:0] <= WDATA[7:0];
  end
  always@(posedge CLK) begin
    if(write_enable[1]) BRAM[ADDR][15:8] <= WDATA[15:8];
  end
  always@(posedge CLK) begin
    if(write_enable[2]) BRAM[ADDR][23:16] <= WDATA[23:16];
  end
  always@(posedge CLK) begin
    if(write_enable[3]) BRAM[ADDR][31:24] <= WDATA[31:24];
  end

  always @ (posedge CLK)
    begin
      addr_q1 <= ADDR[AW-1:0];
    end

  assign read_data  = BRAM[addr_q1];


  assign RDATA      = (cs_reg) ? read_data : {32{1'b0}};

endmodule
