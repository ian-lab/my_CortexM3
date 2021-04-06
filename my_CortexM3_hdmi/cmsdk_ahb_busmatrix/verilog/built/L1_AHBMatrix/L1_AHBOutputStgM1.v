//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2001-2013-2021 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2012-10-15 18:01:36 +0100 (Mon, 15 Oct 2012) $
//
//      Revision            : $Revision: 225465 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-01rel0
//
//-----------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
//  Abstract             : The Output Stage is used to route the required input
//                         stage to the shared slave output. However, for this
//                         output port, only one sparse connection is declared
//                         and muxing is simplified.
//
//  Notes               : The bus matrix has sparse connectivity and the
//                         standard output stage has been overridden for this
//                         instance only.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module L1_AHBOutputStgM1 (

    // Common AHB signals
    HCLK,
    HRESETn,

    // Port 2 Signals
    sel_op2,
    addr_op2,
    trans_op2,
    write_op2,
    size_op2,
    burst_op2,
    prot_op2,
    master_op2,
    mastlock_op2,
    wdata_op2,
    held_tran_op2,

    // Slave read data and response
    HREADYOUTM,

    active_op2,

    // Slave addr_opess/Control Signals
    HSELM,
    HADDRM,
    HTRANSM,
    HWRITEM,
    HSIZEM,
    HBURSTM,
    HPROTM,
    HMASTERM,
    HMASTLOCKM,
    HREADYMUXM,
    HWDATAM

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input         HCLK;       // AHB system clock
    input         HRESETn;    // AHB system reset

    // Bus-switch input 2
    input         sel_op2;       // Port 2 HSEL signal
    input [31:0]  addr_op2;      // Port 2 HADDR signal
    input  [1:0]  trans_op2;     // Port 2 HTRANS signal
    input         write_op2;     // Port 2 HWRITE signal
    input  [2:0]  size_op2;      // Port 2 HSIZE signal
    input  [2:0]  burst_op2;     // Port 2 HBURST signal
    input  [3:0]  prot_op2;      // Port 2 HPROT signal
    input  [3:0]  master_op2;    // Port 2 HMASTER signal
    input         mastlock_op2;  // Port 2 HMASTLOCK signal
    input [31:0]  wdata_op2;     // Port 2 HWDATA signal
    input         held_tran_op2;  // Port 2 held_tran_op signal

    input         HREADYOUTM; // HREADY feedback

    output        active_op2;    // Port 2 active_op signal

    // Slave addr_opess/Control Signals
    output        HSELM;      // Slave select line
    output [31:0] HADDRM;     // addr_opess
    output  [1:0] HTRANSM;    // trans_opfer type
    output        HWRITEM;    // trans_opfer direction
    output  [2:0] HSIZEM;     // trans_opfer size
    output  [2:0] HBURSTM;    // burst_op type
    output  [3:0] HPROTM;     // prot_opection control
    output  [3:0] HMASTERM;   // master_op ID
    output        HMASTLOCKM; // Locked transfer
    output        HREADYMUXM; // trans_opfer done
    output [31:0] HWDATAM;    // write_op data


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
    wire        HCLK;       // AHB system clock
    wire        HRESETn;    // AHB system reset

    // Bus-switch input 2
    wire        sel_op2;       // Port 2 HSEL signal
    wire [31:0] addr_op2;      // Port 2 HADDR signal
    wire  [1:0] trans_op2;     // Port 2 HTRANS signal
    wire        write_op2;     // Port 2 HWRITE signal
    wire  [2:0] size_op2;      // Port 2 HSIZE signal
    wire  [2:0] burst_op2;     // Port 2 HBURST signal
    wire  [3:0] prot_op2;      // Port 2 HPROT signal
    wire  [3:0] master_op2;    // Port 2 HMASTER signal
    wire        mastlock_op2;  // Port 2 HMASTLOCK signal
    wire [31:0] wdata_op2;     // Port 2 HWDATA signal
    wire        held_tran_op2;  // Port 2 held_tran_op signal
    wire        active_op2;    // Port 2 active_op signal

    // Slave addr_opess/Control Signals
    wire        HSELM;      // Slave select line
    wire [31:0] HADDRM;     // addr_opess
    wire  [1:0] HTRANSM;    // trans_opfer type
    wire        HWRITEM;    // trans_opfer direction
    wire  [2:0] HSIZEM;     // trans_opfer size
    wire  [2:0] HBURSTM;    // burst_op type
    wire  [3:0] HPROTM;     // prot_opection control
    wire  [3:0] HMASTERM;   // master_op ID
    wire        HMASTLOCKM; // Locked transfer
    wire        HREADYMUXM; // trans_opfer done
    wire [31:0] HWDATAM;    // write_op data
    wire        HREADYOUTM; // HREADY feedback


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
    wire        req_port2;     // Port 2 request signal

    wire  [1:0] addr_in_port;   // addr_opess input port
    reg   [1:0] data_in_port;   // Data input port
    wire        no_port;       // No port selected signal
    reg         slave_sel;     // Slave select signal

    reg         hsel_lock;     // Held HSELS during locked sequence
    wire        next_hsel_lock; // Pre-registered hsel_lock
    wire        hlock_arb;     // HMASTLOCK modified by HSEL for arbitration

    wire        i_hselm;       // Internal HSELM
    wire  [1:0] i_htransm;     // Internal HTRANSM
    wire  [2:0] i_hburstm;     // Internal HBURSTM
    wire        i_hreadymuxm;  // Internal HREADYMUXM
    wire        i_hmastlockm;  // Internal HMASTLOCKM


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Port sel_opection
// -----------------------------------------------------------------------------

  assign req_port2 = held_tran_op2 & sel_op2;

  // Dummy arbiter instance for granting requests to this output stage
  L1_AHBArbiterM1 u_output_arb (

    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    .req_port2   (req_port2),

    .HREADYM    (i_hreadymuxm),
    .HSELM      (i_hselm),
    .HTRANSM    (i_htransm),
    .HBURSTM    (i_hburstm),
    .HMASTLOCKM (hlock_arb),

    .addr_in_port (addr_in_port),
    .no_port     (no_port)

    );


  // active_op signal combinatorial decode
  assign active_op2 = (addr_in_port == 2'b10) & !no_port;

  // addr_opess/control output decode
  assign i_hselm     = (addr_in_port == 2'b10) & sel_op2 & !no_port;
  assign HADDRM      = ( (addr_in_port == 2'b10) & !no_port ) ? addr_op2 : {32{1'b0}};
  assign i_htransm   = ( (addr_in_port == 2'b10) & !no_port ) ? trans_op2 : 2'b00;
  assign HWRITEM     = (addr_in_port == 2'b10) & write_op2 & !no_port;
  assign HSIZEM      = ( (addr_in_port == 2'b10) & !no_port ) ? size_op2 : 3'b000;
  assign i_hburstm    = ( (addr_in_port == 2'b10) & !no_port ) ? burst_op2 : 3'b000;
  assign HPROTM      = ( (addr_in_port == 2'b10) & !no_port ) ? prot_op2  : {4{1'b0}};
  assign HMASTERM    = ( (addr_in_port == 2'b10) & !no_port ) ? master_op2 : 4'b0000;
  assign i_hmastlockm = (addr_in_port == 2'b10) & mastlock_op2 & !no_port;

  // hsel_lock provides support for AHB masters that address other
  // slave regions in the middle of a locked sequence (i.e. HSEL is
  // de-asserted during the locked sequence).  Unless HMASTLOCK is
  // held during these intermediate cycles, the OutputArb scheme will
  // lose track of the locked sequence and may allow another input
  // port to access the output port which should be locked
  assign next_hsel_lock = (i_hselm & i_htransm[1] & i_hmastlockm) ? 1'b1 :
                         (i_hmastlockm == 1'b0) ? 1'b0 :
                          hsel_lock;

  // Register hsel_lock
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_hsel_lock
      if (!HRESETn)
        hsel_lock <= 1'b0;
      else
        if (i_hreadymuxm)
          hsel_lock <= next_hsel_lock;
    end

  // Version of HMASTLOCK which is masked when not selected, unless a
  // locked sequence has already begun through this port
  assign hlock_arb = i_hmastlockm & (hsel_lock | i_hselm);

  assign HTRANSM    = i_htransm;
  assign HBURSTM    = i_hburstm;
  assign HSELM      = i_hselm;
  assign HMASTLOCKM = i_hmastlockm;

  // Dataport register
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_data_in_port_reg
      if (!HRESETn)
        data_in_port <= {2{1'b0}};
      else
        if (i_hreadymuxm)
          data_in_port <= addr_in_port;
    end

  // HWDATAM output decode
  assign HWDATAM = ( data_in_port == 2'b10 ) ? wdata_op2 : {32{1'b0}};


  // ---------------------------------------------------------------------------
  // HREADYMUXM generation
  // ---------------------------------------------------------------------------
  // The HREADY signal on the shared slave is generated directly from
  //  the shared slave HREADYOUTS if the slave is selected, otherwise
  //  it mirrors the HREADY signal of the appropriate input port
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_slave_sel_reg
      if (!HRESETn)
        slave_sel <= 1'b0;
      else
        if (i_hreadymuxm)
          slave_sel <= i_hselm;
    end

  // HREADYMUXM output selection
  assign i_hreadymuxm = (slave_sel) ? HREADYOUTM : 1'b1;

  // Drive output with internal version of the signal
  assign HREADYMUXM = i_hreadymuxm;


endmodule

// --================================= End ===================================--
