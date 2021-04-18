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
//------------------------------------------------------------------------------
//  Abstract             : The Output Arbitration is normally used to determine
//                         which of the input stages will be given access to
//                         the shared slave. However, for this output port, only
//                         one sparse connection is declared and arbitration
//                         is simplified to a 'grant when requested' function.
//
//  Notes               : The bus matrix has sparse connectivity and the
//                         burst arbiter scheme has been overridden for this
//                         instance only.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module L1_AHBArbiterM1 (

    // Common AHB signals
    HCLK ,
    HRESETn,

    // Input port request signals
    req_port2,

    HREADYM,
    HSELM,
    HTRANSM,
    HBURSTM,
    HMASTLOCKM,

    // Arbiter outputs
    addr_in_port,
    no_port

    );


// -----------------------------------------------------------------------------
// Input and Output declarations
// -----------------------------------------------------------------------------

    // Common AHB signals
    input        HCLK;         // AHB system clock
    input        HRESETn;      // AHB system reset

    input        req_port2;     // Port 2 request signal

    input        HREADYM;      // Transfer done
    input        HSELM;        // Slave select line
    input  [1:0] HTRANSM;      // Transfer type
    input  [2:0] HBURSTM;      // Burst type
    input        HMASTLOCKM;   // Locked transfer

    output [1:0] addr_in_port;   // Port address input
    output       no_port;       // No port selected signal


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
    wire       HCLK;           // AHB system clock
    wire       HRESETn;        // AHB system reset
    wire       req_port2;       // Port 2 request signal
    wire       HREADYM;        // Transfer done
    wire       HSELM;          // Slave select line
    wire [1:0] HTRANSM;        // Transfer type
    wire       HMASTLOCKM;     // Locked transfer
    wire [1:0] addr_in_port;     // Port address input
    reg        no_port;         // No port selected signal


// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
    wire [1:0] addr_in_port_next; // D-input of addr_in_port
    reg  [1:0] iaddr_in_port;    // Internal version of addr_in_port
    wire       no_port_next;     // D-input of no_port
    wire       request;        // Slave port request


// -----------------------------------------------------------------------------
// Beginning of main code
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Port Selection
//------------------------------------------------------------------------------
// The single output 'arbitration' function looks at the request to use the
//  output port and grants it appropriately. The input port will remain granted
//  if it is performing IDLE transfers to the selected slave. If this is not
//  the case then the no_port signal will be asserted which indicates that the
//  input port should be deselected.

  assign request = req_port2 | ( (iaddr_in_port == 2'b10) & HSELM &
                                (HTRANSM != 2'b00) );

  assign no_port_next     = ! ( HMASTLOCKM | request | HSELM );
  assign addr_in_port_next = ( request & !HMASTLOCKM ) ? 2'b10 : iaddr_in_port;

  // Sequential process
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_addr_in_port_reg
    if (~HRESETn)
      begin
        no_port      <= 1'b1;
        iaddr_in_port <= {2{1'b0}};
      end
    else
      if (HREADYM)
        begin
          no_port      <= no_port_next;
          iaddr_in_port <= addr_in_port_next;
        end
  end // block: p_addr_in_port_reg

  // Drive output with internal version
  assign addr_in_port = iaddr_in_port;


endmodule

// --================================= End ===================================--
