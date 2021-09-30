/*-
 * Copyright (c) 2021 Alexandre Joannou
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory (Department of Computer Science and
 * Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
 * DARPA SSITH research programme.
 *
 * @BERI_LICENSE_HEADER_START@
 *
 * Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  BERI licenses this
 * file to you under the BERI Hardware-Software License, Version 1.0 (the
 * "License"); you may not use this file except in compliance with the
 * License.  You may obtain a copy of the License at:
 *
 *   http://www.beri-open-systems.org/legal/license-1-0.txt
 *
 * Unless required by applicable law or agreed to in writing, Work distributed
 * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * @BERI_LICENSE_HEADER_END@
 */

package DE10Pro_bsv_shell;

import AXI4 :: *;
import AXI4Lite :: *;
import AXI4_AXI4Lite_Bridges :: *;

import Vector :: *;

/////////////////////////////////////
// "non sig in-bluespec" interface //
////////////////////////////////////////////////////////////////////////////////

interface DE10Pro_bsv_shell #(
// Light-weight HPS to FPGA AXI port parameters
  numeric type t_h2f_lw_addr
, numeric type t_h2f_lw_data
, numeric type t_h2f_lw_awuser
, numeric type t_h2f_lw_wuser
, numeric type t_h2f_lw_buser
, numeric type t_h2f_lw_aruser
, numeric type t_h2f_lw_ruser
// HPS to FPGA AXI port parameters
, numeric type t_h2f_id
, numeric type t_h2f_addr
, numeric type t_h2f_data
, numeric type t_h2f_awuser
, numeric type t_h2f_wuser
, numeric type t_h2f_buser
, numeric type t_h2f_aruser
, numeric type t_h2f_ruser
// FPGA to HPS AXI port parameters
, numeric type t_f2h_id
, numeric type t_f2h_addr
, numeric type t_f2h_data
, numeric type t_f2h_awuser
, numeric type t_f2h_wuser
, numeric type t_f2h_buser
, numeric type t_f2h_aruser
, numeric type t_f2h_ruser
// DDRB AXI port parameters
, numeric type t_ddrb_id
, numeric type t_ddrb_addr
, numeric type t_ddrb_data
, numeric type t_ddrb_awuser
, numeric type t_ddrb_wuser
, numeric type t_ddrb_buser
, numeric type t_ddrb_aruser
, numeric type t_ddrb_ruser
// DDRC AXI port parameters
, numeric type t_ddrc_id
, numeric type t_ddrc_addr
, numeric type t_ddrc_data
, numeric type t_ddrc_awuser
, numeric type t_ddrc_wuser
, numeric type t_ddrc_buser
, numeric type t_ddrc_aruser
, numeric type t_ddrc_ruser
// DDRD AXI port parameters
, numeric type t_ddrd_id
, numeric type t_ddrd_addr
, numeric type t_ddrd_data
, numeric type t_ddrd_awuser
, numeric type t_ddrd_wuser
, numeric type t_ddrd_buser
, numeric type t_ddrd_aruser
, numeric type t_ddrd_ruser
);
  // Light-weight HPS to FPGA AXI port
  // ---------------------------------
  interface AXI4Lite_Slave #( t_h2f_lw_addr
                            , t_h2f_lw_data
                            , t_h2f_lw_awuser
                            , t_h2f_lw_wuser
                            , t_h2f_lw_buser
                            , t_h2f_lw_aruser
                            , t_h2f_lw_ruser ) axls_h2f_lw;
  // HPS to FPGA AXI port
  // --------------------
  interface AXI4_Slave #( t_h2f_id
                        , t_h2f_addr
                        , t_h2f_data
                        , t_h2f_awuser
                        , t_h2f_wuser
                        , t_h2f_buser
                        , t_h2f_aruser
                        , t_h2f_ruser ) axs_h2f;
  // FPGA to HPS AXI port
  // --------------------
  interface AXI4_Master #( t_f2h_id
                         , t_f2h_addr
                         , t_f2h_data
                         , t_f2h_awuser
                         , t_f2h_wuser
                         , t_f2h_buser
                         , t_f2h_aruser
                         , t_f2h_ruser ) axm_f2h;
  // DDRB AXI port
  // -------------
  interface AXI4_Master #( t_ddrb_id
                         , t_ddrb_addr
                         , t_ddrb_data
                         , t_ddrb_awuser
                         , t_ddrb_wuser
                         , t_ddrb_buser
                         , t_ddrb_aruser
                         , t_ddrb_ruser ) axm_ddrb;
  // DDRC AXI port
  // -------------
  interface AXI4_Master #( t_ddrc_id
                         , t_ddrc_addr
                         , t_ddrc_data
                         , t_ddrc_awuser
                         , t_ddrc_wuser
                         , t_ddrc_buser
                         , t_ddrc_aruser
                         , t_ddrc_ruser ) axm_ddrc;
  // DDRD AXI port
  // -------------
  interface AXI4_Master #( t_ddrd_id
                         , t_ddrd_addr
                         , t_ddrd_data
                         , t_ddrd_awuser
                         , t_ddrd_wuser
                         , t_ddrd_buser
                         , t_ddrd_aruser
                         , t_ddrd_ruser ) axm_ddrd;
  // Interrupt sender interface
  // --------------------------
  interface Vector #(32, ReadOnly #(Bool)) ins_irq0;
endinterface

////////////////////////////////
// Replicated "sig" interface //
////////////////////////////////////////////////////////////////////////////////

interface DE10Pro_bsv_shell_Sig #(
// Light-weight HPS to FPGA AXI port parameters
  numeric type t_h2f_lw_addr
, numeric type t_h2f_lw_data
, numeric type t_h2f_lw_awuser
, numeric type t_h2f_lw_wuser
, numeric type t_h2f_lw_buser
, numeric type t_h2f_lw_aruser
, numeric type t_h2f_lw_ruser
// HPS to FPGA AXI port parameters
, numeric type t_h2f_id
, numeric type t_h2f_addr
, numeric type t_h2f_data
, numeric type t_h2f_awuser
, numeric type t_h2f_wuser
, numeric type t_h2f_buser
, numeric type t_h2f_aruser
, numeric type t_h2f_ruser
// FPGA to HPS AXI port parameters
, numeric type t_f2h_id
, numeric type t_f2h_addr
, numeric type t_f2h_data
, numeric type t_f2h_awuser
, numeric type t_f2h_wuser
, numeric type t_f2h_buser
, numeric type t_f2h_aruser
, numeric type t_f2h_ruser
// DDRB AXI port parameters
, numeric type t_ddrb_id
, numeric type t_ddrb_addr
, numeric type t_ddrb_data
, numeric type t_ddrb_awuser
, numeric type t_ddrb_wuser
, numeric type t_ddrb_buser
, numeric type t_ddrb_aruser
, numeric type t_ddrb_ruser
// DDRC AXI port parameters
, numeric type t_ddrc_id
, numeric type t_ddrc_addr
, numeric type t_ddrc_data
, numeric type t_ddrc_awuser
, numeric type t_ddrc_wuser
, numeric type t_ddrc_buser
, numeric type t_ddrc_aruser
, numeric type t_ddrc_ruser
// DDRD AXI port parameters
, numeric type t_ddrd_id
, numeric type t_ddrd_addr
, numeric type t_ddrd_data
, numeric type t_ddrd_awuser
, numeric type t_ddrd_wuser
, numeric type t_ddrd_buser
, numeric type t_ddrd_aruser
, numeric type t_ddrd_ruser
);
  // Light-weight HPS to FPGA AXI port
  // ---------------------------------
  interface AXI4Lite_Slave_Sig #( t_h2f_lw_addr
                                , t_h2f_lw_data
                                , t_h2f_lw_awuser
                                , t_h2f_lw_wuser
                                , t_h2f_lw_buser
                                , t_h2f_lw_aruser
                                , t_h2f_lw_ruser ) axls_h2f_lw;
  // HPS to FPGA AXI port
  // --------------------
  interface AXI4_Slave_Sig #( t_h2f_id
                            , t_h2f_addr
                            , t_h2f_data
                            , t_h2f_awuser
                            , t_h2f_wuser
                            , t_h2f_buser
                            , t_h2f_aruser
                            , t_h2f_ruser ) axs_h2f;
  // FPGA to HPS AXI port
  // --------------------
  interface AXI4_Master_Sig #( t_f2h_id
                             , t_f2h_addr
                             , t_f2h_data
                             , t_f2h_awuser
                             , t_f2h_wuser
                             , t_f2h_buser
                             , t_f2h_aruser
                             , t_f2h_ruser ) axm_f2h;
  // DDRB AXI port
  // -------------
  interface AXI4_Master_Sig #( t_ddrb_id
                             , t_ddrb_addr
                             , t_ddrb_data
                             , t_ddrb_awuser
                             , t_ddrb_wuser
                             , t_ddrb_buser
                             , t_ddrb_aruser
                             , t_ddrb_ruser ) axm_ddrb;
  // DDRC AXI port
  // -------------
  interface AXI4_Master_Sig #( t_ddrc_id
                             , t_ddrc_addr
                             , t_ddrc_data
                             , t_ddrc_awuser
                             , t_ddrc_wuser
                             , t_ddrc_buser
                             , t_ddrc_aruser
                             , t_ddrc_ruser ) axm_ddrc;
  // DDRD AXI port
  // -------------
  interface AXI4_Master_Sig #( t_ddrd_id
                             , t_ddrd_addr
                             , t_ddrd_data
                             , t_ddrd_awuser
                             , t_ddrd_wuser
                             , t_ddrd_buser
                             , t_ddrd_aruser
                             , t_ddrd_ruser ) axm_ddrd;
  // Interrupt sender interface
  // --------------------------
  (* always_ready, always_enabled *)
  //interface Vector #(32, ReadOnly #(Bool)) ins_irq0;
  interface Bit #(32) ins_irq0;
endinterface

////////////////////////////////
// convert "non-sig" to "sig" //
////////////////////////////////////////////////////////////////////////////////

module toDE10Pro_bsv_shell_Sig #(
  DE10Pro_bsv_shell #( // Light-weight HPS to FPGA AXI port parameters
                       t_h2f_lw_addr
                     , t_h2f_lw_data
                     , t_h2f_lw_awuser
                     , t_h2f_lw_wuser
                     , t_h2f_lw_buser
                     , t_h2f_lw_aruser
                     , t_h2f_lw_ruser
                     // HPS to FPGA AXI port parameters
                     , t_h2f_id
                     , t_h2f_addr
                     , t_h2f_data
                     , t_h2f_awuser
                     , t_h2f_wuser
                     , t_h2f_buser
                     , t_h2f_aruser
                     , t_h2f_ruser
                     // FPGA to HPS AXI port parameters
                     , t_f2h_id
                     , t_f2h_addr
                     , t_f2h_data
                     , t_f2h_awuser
                     , t_f2h_wuser
                     , t_f2h_buser
                     , t_f2h_aruser
                     , t_f2h_ruser
                     // DDRB AXI port parameters
                     , t_ddrb_id
                     , t_ddrb_addr
                     , t_ddrb_data
                     , t_ddrb_awuser
                     , t_ddrb_wuser
                     , t_ddrb_buser
                     , t_ddrb_aruser
                     , t_ddrb_ruser
                     // DDRC AXI port parameters
                     , t_ddrc_id
                     , t_ddrc_addr
                     , t_ddrc_data
                     , t_ddrc_awuser
                     , t_ddrc_wuser
                     , t_ddrc_buser
                     , t_ddrc_aruser
                     , t_ddrc_ruser
                     // DDRD AXI port parameters
                     , t_ddrd_id
                     , t_ddrd_addr
                     , t_ddrd_data
                     , t_ddrd_awuser
                     , t_ddrd_wuser
                     , t_ddrd_buser
                     , t_ddrd_aruser
                     , t_ddrd_ruser ) ifc)
  (DE10Pro_bsv_shell_Sig #( // Light-weight HPS to FPGA AXI port parameters
                            t_h2f_lw_addr
                          , t_h2f_lw_data
                          , t_h2f_lw_awuser
                          , t_h2f_lw_wuser
                          , t_h2f_lw_buser
                          , t_h2f_lw_aruser
                          , t_h2f_lw_ruser
                          // HPS to FPGA AXI port parameters
                          , t_h2f_id
                          , t_h2f_addr
                          , t_h2f_data
                          , t_h2f_awuser
                          , t_h2f_wuser
                          , t_h2f_buser
                          , t_h2f_aruser
                          , t_h2f_ruser
                          // FPGA to HPS AXI port parameters
                          , t_f2h_id
                          , t_f2h_addr
                          , t_f2h_data
                          , t_f2h_awuser
                          , t_f2h_wuser
                          , t_f2h_buser
                          , t_f2h_aruser
                          , t_f2h_ruser
                          // DDRB AXI port parameters
                          , t_ddrb_id
                          , t_ddrb_addr
                          , t_ddrb_data
                          , t_ddrb_awuser
                          , t_ddrb_wuser
                          , t_ddrb_buser
                          , t_ddrb_aruser
                          , t_ddrb_ruser
                          // DDRC AXI port parameters
                          , t_ddrc_id
                          , t_ddrc_addr
                          , t_ddrc_data
                          , t_ddrc_awuser
                          , t_ddrc_wuser
                          , t_ddrc_buser
                          , t_ddrc_aruser
                          , t_ddrc_ruser
                          // DDRD AXI port parameters
                          , t_ddrd_id
                          , t_ddrd_addr
                          , t_ddrd_data
                          , t_ddrd_awuser
                          , t_ddrd_wuser
                          , t_ddrd_buser
                          , t_ddrd_aruser
                          , t_ddrd_ruser ));
  let axls_h2f_lw_sig <- toAXI4Lite_Slave_Sig (ifc.axls_h2f_lw);
  let axs_h2f_sig <- toAXI4_Slave_Sig (ifc.axs_h2f);
  let axm_f2h_sig <- toAXI4_Master_Sig (ifc.axm_f2h);
  let axm_ddrb_sig <- toAXI4_Master_Sig (ifc.axm_ddrb);
  let axm_ddrc_sig <- toAXI4_Master_Sig (ifc.axm_ddrc);
  let axm_ddrd_sig <- toAXI4_Master_Sig (ifc.axm_ddrd);
  interface axls_h2f_lw = axls_h2f_lw_sig;
  interface axs_h2f = axs_h2f_sig;
  interface axm_f2h = axm_f2h_sig;
  interface axm_ddrb = axm_ddrb_sig;
  interface axm_ddrc = axm_ddrc_sig;
  interface axm_ddrd = axm_ddrd_sig;
  interface ins_irq0 = pack (map (readReadOnly, ifc.ins_irq0));
endmodule

// Concrete parameters definitions
// -------------------------------

// HPS AXI bridges parameters

`define H2F_LW_ADDR   21 // from 20 (1MB) to 21 (2MB)
`define H2F_LW_DATA   32
`define H2F_LW_AWUSER  0
`define H2F_LW_WUSER   0
`define H2F_LW_BUSER   0
`define H2F_LW_ARUSER  0
`define H2F_LW_RUSER   0

`define H2F_ID       4
`define H2F_ADDR    32 // from 20 (1MB) to 32 (4GB)
`define H2F_DATA   128 // 32, 64 or 128
`define H2F_AWUSER   0
`define H2F_WUSER    0
`define H2F_BUSER    0
`define H2F_ARUSER   0
`define H2F_RUSER    0

`define F2H_ID       4
`define F2H_ADDR    32 // from 20 (1MB) to 40 (1TB)
`define F2H_DATA   128
`define F2H_AWUSER   0
`define F2H_WUSER    0
`define F2H_BUSER    0
`define F2H_ARUSER   0
`define F2H_RUSER    0

// DDR AXI ports parameters

`define DRAM_ID       4
`define DRAM_ADDR    32
`define DRAM_DATA   128
`define DRAM_AWUSER   0
`define DRAM_WUSER    0
`define DRAM_BUSER    0
`define DRAM_ARUSER   0
`define DRAM_RUSER    0

typedef DE10Pro_bsv_shell #( `H2F_LW_ADDR
                           , `H2F_LW_DATA
                           , `H2F_LW_AWUSER
                           , `H2F_LW_WUSER
                           , `H2F_LW_BUSER
                           , `H2F_LW_ARUSER
                           , `H2F_LW_RUSER
                           , `H2F_ID
                           , `H2F_ADDR
                           , `H2F_DATA
                           , `H2F_AWUSER
                           , `H2F_WUSER
                           , `H2F_BUSER
                           , `H2F_ARUSER
                           , `H2F_RUSER
                           , `F2H_ID
                           , `F2H_ADDR
                           , `F2H_DATA
                           , `F2H_AWUSER
                           , `F2H_WUSER
                           , `F2H_BUSER
                           , `F2H_ARUSER
                           , `F2H_RUSER
                           , `DRAM_ID
                           , `DRAM_ADDR
                           , `DRAM_DATA
                           , `DRAM_AWUSER
                           , `DRAM_WUSER
                           , `DRAM_BUSER
                           , `DRAM_ARUSER
                           , `DRAM_RUSER
                           , `DRAM_ID
                           , `DRAM_ADDR
                           , `DRAM_DATA
                           , `DRAM_AWUSER
                           , `DRAM_WUSER
                           , `DRAM_BUSER
                           , `DRAM_ARUSER
                           , `DRAM_RUSER
                           , `DRAM_ID
                           , `DRAM_ADDR
                           , `DRAM_DATA
                           , `DRAM_AWUSER
                           , `DRAM_WUSER
                           , `DRAM_BUSER
                           , `DRAM_ARUSER
                           , `DRAM_RUSER ) ConcreteDE10Pro_bsv_shell;

typedef DE10Pro_bsv_shell_Sig #( `H2F_LW_ADDR
                               , `H2F_LW_DATA
                               , `H2F_LW_AWUSER
                               , `H2F_LW_WUSER
                               , `H2F_LW_BUSER
                               , `H2F_LW_ARUSER
                               , `H2F_LW_RUSER
                               , `H2F_ID
                               , `H2F_ADDR
                               , `H2F_DATA
                               , `H2F_AWUSER
                               , `H2F_WUSER
                               , `H2F_BUSER
                               , `H2F_ARUSER
                               , `H2F_RUSER
                               , `F2H_ID
                               , `F2H_ADDR
                               , `F2H_DATA
                               , `F2H_AWUSER
                               , `F2H_WUSER
                               , `F2H_BUSER
                               , `F2H_ARUSER
                               , `F2H_RUSER
                               , `DRAM_ID
                               , `DRAM_ADDR
                               , `DRAM_DATA
                               , `DRAM_AWUSER
                               , `DRAM_WUSER
                               , `DRAM_BUSER
                               , `DRAM_ARUSER
                               , `DRAM_RUSER
                               , `DRAM_ID
                               , `DRAM_ADDR
                               , `DRAM_DATA
                               , `DRAM_AWUSER
                               , `DRAM_WUSER
                               , `DRAM_BUSER
                               , `DRAM_ARUSER
                               , `DRAM_RUSER
                               , `DRAM_ID
                               , `DRAM_ADDR
                               , `DRAM_DATA
                               , `DRAM_AWUSER
                               , `DRAM_WUSER
                               , `DRAM_BUSER
                               , `DRAM_ARUSER
                               , `DRAM_RUSER ) ConcreteDE10Pro_bsv_shell_Sig;

// trivial examples
// ----------------

module mkDummyDE10Pro_bsv_shell_Sig (ConcreteDE10Pro_bsv_shell_Sig);
  interface axls_h2f_lw = culDeSac;
  interface axs_h2f = culDeSac;
  interface axm_f2h = culDeSac;
  interface axm_ddrb = culDeSac;
  interface axm_ddrc = culDeSac;
  interface axm_ddrd = culDeSac;
  interface ins_irq0 = 0;
endmodule

module mkPassThroughToDRAMDE10Pro_bsv_shell (ConcreteDE10Pro_bsv_shell);
  let ddrShim <- mkAXI4ShimFF;
  let ddrbShim <- mkAXI4ShimFF;
  let ddrcShim <- mkAXI4ShimFF;
  let ddrdShim <- mkAXI4ShimFF;
  function someRoute (addr);
    let route = replicate (False);
    case (addr[20:19])
      2'b00: route[0] = True;
      2'b01: route[1] = True;
      default: route[2] = True;
    endcase
    return route;
  endfunction
  mkAXI4Bus ( someRoute
            , cons (ddrShim.master, nil)
            , cons ( ddrbShim.slave
                   , cons ( ddrcShim.slave
                          , cons ( ddrdShim.slave
                                 , nil ))));

  AXI4_Slave #( 0
              , `H2F_LW_ADDR
              , `H2F_LW_DATA
              , `H2F_LW_AWUSER
              , `H2F_LW_WUSER
              , `H2F_LW_BUSER
              , `H2F_LW_ARUSER
              , `H2F_LW_RUSER )
    alwaysDeadBeef <- mkPerpetualValueAXI4Slave ('hdeadbeef);
  interface axls_h2f_lw = fromAXI4ToAXI4Lite_Slave (alwaysDeadBeef);
  interface axs_h2f = ddrShim.slave;
  interface axm_f2h = culDeSac;
  interface axm_ddrb = ddrbShim.master;
  interface axm_ddrc = ddrcShim.master;
  interface axm_ddrd = ddrdShim.master;
  interface ins_irq0 = replicate (interface ReadOnly;
                                    method _read = False;
                                  endinterface);
endmodule

module mkPassThroughToDRAMDE10Pro_bsv_shell_Sig (ConcreteDE10Pro_bsv_shell_Sig);
  let noSig <- mkPassThroughToDRAMDE10Pro_bsv_shell;
  let sig <- toDE10Pro_bsv_shell_Sig (noSig);
  return sig;
endmodule

endpackage
