/*-
 * Copyright (c) 2021-2023 Alexandre Joannou
 * All rights reserved.
 *
 * This material is based upon work supported by the DoD Information Analysis
 * Center Program Management Office (DoD IAC PMO), sponsored by the Defense
 * Technical Information Center (DTIC) under Contract No. FA807518D0004.  Any
 * opinions, findings and conclusions or recommendations expressed in this
 * material are those of the author(s) and do not necessarily reflect the views
 * of the Air Force Installation Contracting Agency (AFICA).
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

import BlueBasics :: *;
import BlueAXI4 :: *;
import BlueAvalon :: *;
import SourceSink :: *;
import AXI4_Avalon :: *;

import Vector :: *;

// helper interface for irqs //
///////////////////////////////

interface Irq;
  (* prefix = "" *)
  (* result = "irq" *)
  (* always_ready, always_enabled *)
  method Bool _read;
endinterface

instance Bits #(Irq, 1);
  function pack (irq) = pack (irq._read);
  function unpack (x) = interface Irq;
    method _read = (x == 1'h0) ? False : True;
  endinterface;
endinstance

Irq noIrq = interface Irq; method _read = False; endinterface;

// Macro helpers
`define DEF_TYPE_PARAMS \
// Light-weight HPS to FPGA AXI port parameters \
  numeric type t_h2f_lw_addr \
, numeric type t_h2f_lw_data \
, numeric type t_h2f_lw_awuser \
, numeric type t_h2f_lw_wuser \
, numeric type t_h2f_lw_buser \
, numeric type t_h2f_lw_aruser \
, numeric type t_h2f_lw_ruser \
// HPS to FPGA AXI port parameters \
, numeric type t_h2f_id \
, numeric type t_h2f_addr \
, numeric type t_h2f_data \
, numeric type t_h2f_awuser \
, numeric type t_h2f_wuser \
, numeric type t_h2f_buser \
, numeric type t_h2f_aruser \
, numeric type t_h2f_ruser \
// FPGA to HPS AXI port parameters \
, numeric type t_f2h_id \
, numeric type t_f2h_addr \
, numeric type t_f2h_data \
, numeric type t_f2h_awuser \
, numeric type t_f2h_wuser \
, numeric type t_f2h_buser \
, numeric type t_f2h_aruser \
, numeric type t_f2h_ruser \
// DDRB AXI port parameters \
, numeric type t_ddrb_id \
, numeric type t_ddrb_addr \
, numeric type t_ddrb_data \
, numeric type t_ddrb_awuser \
, numeric type t_ddrb_wuser \
, numeric type t_ddrb_buser \
, numeric type t_ddrb_aruser \
, numeric type t_ddrb_ruser \
// DDRC AXI port parameters \
, numeric type t_ddrc_id \
, numeric type t_ddrc_addr \
, numeric type t_ddrc_data \
, numeric type t_ddrc_awuser \
, numeric type t_ddrc_wuser \
, numeric type t_ddrc_buser \
, numeric type t_ddrc_aruser \
, numeric type t_ddrc_ruser \
// DDRD AXI port parameters \
, numeric type t_ddrd_id \
, numeric type t_ddrd_addr \
, numeric type t_ddrd_data \
, numeric type t_ddrd_awuser \
, numeric type t_ddrd_wuser \
, numeric type t_ddrd_buser \
, numeric type t_ddrd_aruser \
, numeric type t_ddrd_ruser \
// High Speed Links \
, type t_link_tx \
, type t_link_rx

`define TYPE_PARAMS \
  t_h2f_lw_addr \
, t_h2f_lw_data \
, t_h2f_lw_awuser \
, t_h2f_lw_wuser \
, t_h2f_lw_buser \
, t_h2f_lw_aruser \
, t_h2f_lw_ruser \
// HPS to FPGA AXI port parameters \
, t_h2f_id \
, t_h2f_addr \
, t_h2f_data \
, t_h2f_awuser \
, t_h2f_wuser \
, t_h2f_buser \
, t_h2f_aruser \
, t_h2f_ruser \
// FPGA to HPS AXI port parameters \
, t_f2h_id \
, t_f2h_addr \
, t_f2h_data \
, t_f2h_awuser \
, t_f2h_wuser \
, t_f2h_buser \
, t_f2h_aruser \
, t_f2h_ruser \
// DDRB AXI port parameters \
, t_ddrb_id \
, t_ddrb_addr \
, t_ddrb_data \
, t_ddrb_awuser \
, t_ddrb_wuser \
, t_ddrb_buser \
, t_ddrb_aruser \
, t_ddrb_ruser \
// DDRC AXI port parameters \
, t_ddrc_id \
, t_ddrc_addr \
, t_ddrc_data \
, t_ddrc_awuser \
, t_ddrc_wuser \
, t_ddrc_buser \
, t_ddrc_aruser \
, t_ddrc_ruser \
// DDRD AXI port parameters \
, t_ddrd_id \
, t_ddrd_addr \
, t_ddrd_data \
, t_ddrd_awuser \
, t_ddrd_wuser \
, t_ddrd_buser \
, t_ddrd_aruser \
, t_ddrd_ruser \
// High Speed Links parameters \
, t_link_tx \
, t_link_rx

/////////////////////////////////////
// "non sig in-bluespec" interface //
////////////////////////////////////////////////////////////////////////////////

interface DE10Pro_bsv_shell #(`DEF_TYPE_PARAMS);
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
  // High Speed Links
  // ----------------
  interface Source #(t_link_tx) tx_north;
  interface   Sink #(t_link_rx) rx_north;
  interface Source #(t_link_tx)  tx_east;
  interface   Sink #(t_link_rx)  rx_east;
  interface Source #(t_link_tx) tx_south;
  interface   Sink #(t_link_rx) rx_south;
  interface Source #(t_link_tx)  tx_west;
  interface   Sink #(t_link_rx)  rx_west;
  // Interrupt sender interface
  // --------------------------
  interface Vector #(32, Irq) irqs;
endinterface

////////////////////////////////
// Replicated "sig" interface //
////////////////////////////////////////////////////////////////////////////////

interface DE10Pro_bsv_shell_Sig #(`DEF_TYPE_PARAMS);
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
  // High Speed Links
  // ----------------
  (* prefix = "cis_tx_north" *)
  interface Source_Sig #(t_link_tx) tx_north;
  (* prefix = "cie_rx_north" *)
  interface   Sink_Sig #(t_link_rx) rx_north;
  (* prefix = "cis_tx_east" *)
  interface Source_Sig #(t_link_tx)  tx_east;
  (* prefix = "cie_rx_east" *)
  interface   Sink_Sig #(t_link_rx)  rx_east;
  (* prefix = "cis_tx_south" *)
  interface Source_Sig #(t_link_tx) tx_south;
  (* prefix = "cie_rx_south" *)
  interface   Sink_Sig #(t_link_rx) rx_south;
  (* prefix = "cis_tx_west" *)
  interface Source_Sig #(t_link_tx)  tx_west;
  (* prefix = "cie_rx_west" *)
  interface   Sink_Sig #(t_link_rx)  rx_west;
  // Interrupt sender interface
  // --------------------------
  (* result = "ins_irqs" *)
  (* always_ready, always_enabled *)
  method Bit #(32) irqs;
endinterface

//////////////////////////////////////////////////////
// Replicated "sig" interface with Avalon DDR prots //
////////////////////////////////////////////////////////////////////////////////

interface DE10Pro_bsv_shell_Sig_Avalon #(`DEF_TYPE_PARAMS);
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
  // DDRB Avalon port
  // ----------------
  interface AvalonMasterIfc #(
    TSub #(t_ddrb_addr, TLog #(TDiv #(t_ddrb_data, 8)))
  , t_ddrb_data ) avm_ddrb;
  // DDRC Avalon port
  // ----------------
  interface AvalonMasterIfc #(
    TSub #(t_ddrc_addr, TLog #(TDiv #(t_ddrc_data, 8)))
  , t_ddrc_data ) avm_ddrc;
  // DDRD Avalon port
  // ----------------
  interface AvalonMasterIfc #(
    TSub #(t_ddrd_addr, TLog #(TDiv #(t_ddrd_data, 8)))
  , t_ddrd_data ) avm_ddrd;
  // High Speed Links
  // ----------------
  (* prefix = "cis_tx_north" *)
  interface Source_Sig #(t_link_tx) tx_north;
  (* prefix = "cie_rx_north" *)
  interface   Sink_Sig #(t_link_rx) rx_north;
  (* prefix = "cis_tx_east" *)
  interface Source_Sig #(t_link_tx)  tx_east;
  (* prefix = "cie_rx_east" *)
  interface   Sink_Sig #(t_link_rx)  rx_east;
  (* prefix = "cis_tx_south" *)
  interface Source_Sig #(t_link_tx) tx_south;
  (* prefix = "cie_rx_south" *)
  interface   Sink_Sig #(t_link_rx) rx_south;
  (* prefix = "cis_tx_west" *)
  interface Source_Sig #(t_link_tx)  tx_west;
  (* prefix = "cie_rx_west" *)
  interface   Sink_Sig #(t_link_rx)  rx_west;
  // Interrupt sender interface
  // --------------------------
  (* result = "ins_irqs" *)
  (* always_ready, always_enabled *)
  method Bit #(32) irqs;
endinterface

////////////////////////////////
// convert "non-sig" to "sig" //
////////////////////////////////////////////////////////////////////////////////

module toDE10Pro_bsv_shell_Sig #(DE10Pro_bsv_shell #(`TYPE_PARAMS) ifc)
                                (DE10Pro_bsv_shell_Sig #(`TYPE_PARAMS))
  provisos (Bits #(t_link_tx, _tx_sz), Bits #(t_link_rx, _rx_sz));
  let axls_h2f_lw_sig <- toAXI4Lite_Slave_Sig (ifc.axls_h2f_lw);
  let axs_h2f_sig     <-         toAXI4_Slave_Sig (ifc.axs_h2f);
  let axm_f2h_sig     <-        toAXI4_Master_Sig (ifc.axm_f2h);
  let axm_ddrb_sig    <-       toAXI4_Master_Sig (ifc.axm_ddrb);
  let axm_ddrc_sig    <-       toAXI4_Master_Sig (ifc.axm_ddrc);
  let axm_ddrd_sig    <-       toAXI4_Master_Sig (ifc.axm_ddrd);
  let tx_north_sig    <-            toSource_Sig (ifc.tx_north);
  let rx_north_sig    <-              toSink_Sig (ifc.rx_north);
  let tx_east_sig     <-             toSource_Sig (ifc.tx_east);
  let rx_east_sig     <-               toSink_Sig (ifc.rx_east);
  let tx_south_sig    <-            toSource_Sig (ifc.tx_south);
  let rx_south_sig    <-              toSink_Sig (ifc.rx_south);
  let tx_west_sig     <-             toSource_Sig (ifc.tx_west);
  let rx_west_sig     <-               toSink_Sig (ifc.rx_west);
  interface axls_h2f_lw = axls_h2f_lw_sig;
  interface     axs_h2f =     axs_h2f_sig;
  interface     axm_f2h =     axm_f2h_sig;
  interface    axm_ddrb =    axm_ddrb_sig;
  interface    axm_ddrc =    axm_ddrc_sig;
  interface    axm_ddrd =    axm_ddrd_sig;
  interface    tx_north =    tx_north_sig;
  interface    rx_north =    rx_north_sig;
  interface     tx_east =     tx_east_sig;
  interface     rx_east =     rx_east_sig;
  interface    tx_south =    tx_south_sig;
  interface    rx_south =    rx_south_sig;
  interface     tx_west =     tx_west_sig;
  interface     rx_west =     rx_west_sig;
  method irqs = pack (ifc.irqs);
endmodule

module toDE10Pro_bsv_shell_Sig_Avalon #(DE10Pro_bsv_shell #(`TYPE_PARAMS) ifc)
  (DE10Pro_bsv_shell_Sig_Avalon #(`TYPE_PARAMS))
  provisos ( Bits #(t_link_tx, _tx_sz)
           , Bits #(t_link_rx, _rx_sz)
           , Add #(_a, SizeOf #(AXI4_Len), t_ddrb_addr)
           , Add #(_b, SizeOf #(AXI4_Len), t_ddrc_addr)
           , Add #(_c, SizeOf #(AXI4_Len), t_ddrd_addr) );
  let axls_h2f_lw_sig <- toAXI4Lite_Slave_Sig (ifc.axls_h2f_lw);
  let axs_h2f_sig     <-         toAXI4_Slave_Sig (ifc.axs_h2f);
  let axm_f2h_sig     <-        toAXI4_Master_Sig (ifc.axm_f2h);
  let avm_ddrb_sig    <- mkAXI4Manager_to_AvalonHost (ifc.axm_ddrb);
  let avm_ddrc_sig    <- mkAXI4Manager_to_AvalonHost (ifc.axm_ddrc);
  let avm_ddrd_sig    <- mkAXI4Manager_to_AvalonHost (ifc.axm_ddrd);
  let tx_north_sig    <-            toSource_Sig (ifc.tx_north);
  let rx_north_sig    <-              toSink_Sig (ifc.rx_north);
  let tx_east_sig     <-             toSource_Sig (ifc.tx_east);
  let rx_east_sig     <-               toSink_Sig (ifc.rx_east);
  let tx_south_sig    <-            toSource_Sig (ifc.tx_south);
  let rx_south_sig    <-              toSink_Sig (ifc.rx_south);
  let tx_west_sig     <-             toSource_Sig (ifc.tx_west);
  let rx_west_sig     <-               toSink_Sig (ifc.rx_west);
  interface axls_h2f_lw = axls_h2f_lw_sig;
  interface     axs_h2f =     axs_h2f_sig;
  interface     axm_f2h =     axm_f2h_sig;
  interface    avm_ddrb =    avm_ddrb_sig;
  interface    avm_ddrc =    avm_ddrc_sig;
  interface    avm_ddrd =    avm_ddrd_sig;
  interface    tx_north =    tx_north_sig;
  interface    rx_north =    rx_north_sig;
  interface     tx_east =     tx_east_sig;
  interface     rx_east =     rx_east_sig;
  interface    tx_south =    tx_south_sig;
  interface    rx_south =    rx_south_sig;
  interface     tx_west =     tx_west_sig;
  interface     rx_west =     rx_west_sig;
  method irqs = pack (ifc.irqs);
endmodule

//////////////
// examples //
////////////////////////////////////////////////////////////////////////////////

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
`define F2H_ADDR    38 // from 20 (1MB) to 40 (1TB)
`define F2H_DATA   128
`define F2H_AWUSER   0
`define F2H_WUSER    0
`define F2H_BUSER    0
`define F2H_ARUSER   0
`define F2H_RUSER    0

// DDR AXI ports parameters

`define DRAM_ID       8
`define DRAM_ADDR    32
`define DRAM_DATA   512
`define DRAM_AWUSER   0
`define DRAM_WUSER    0
`define DRAM_BUSER    0
`define DRAM_ARUSER   0
`define DRAM_RUSER    0

`define CONCRETE_PARAMS \
  `H2F_LW_ADDR \
, `H2F_LW_DATA \
, `H2F_LW_AWUSER \
, `H2F_LW_WUSER \
, `H2F_LW_BUSER \
, `H2F_LW_ARUSER \
, `H2F_LW_RUSER \
, `H2F_ID \
, `H2F_ADDR \
, `H2F_DATA \
, `H2F_AWUSER \
, `H2F_WUSER \
, `H2F_BUSER \
, `H2F_ARUSER \
, `H2F_RUSER \
, `F2H_ID \
, `F2H_ADDR \
, `F2H_DATA \
, `F2H_AWUSER \
, `F2H_WUSER \
, `F2H_BUSER \
, `F2H_ARUSER \
, `F2H_RUSER \
, `DRAM_ID \
, `DRAM_ADDR \
, `DRAM_DATA \
, `DRAM_AWUSER \
, `DRAM_WUSER \
, `DRAM_BUSER \
, `DRAM_ARUSER \
, `DRAM_RUSER \
, `DRAM_ID \
, `DRAM_ADDR \
, `DRAM_DATA \
, `DRAM_AWUSER \
, `DRAM_WUSER \
, `DRAM_BUSER \
, `DRAM_ARUSER \
, `DRAM_RUSER \
, `DRAM_ID \
, `DRAM_ADDR \
, `DRAM_DATA \
, `DRAM_AWUSER \
, `DRAM_WUSER \
, `DRAM_BUSER \
, `DRAM_ARUSER \
, `DRAM_RUSER \
, Bit #(512) \
, Bit #(512)

typedef DE10Pro_bsv_shell #(`CONCRETE_PARAMS)
  ConcreteDE10Pro_bsv_shell;
typedef DE10Pro_bsv_shell_Sig #(`CONCRETE_PARAMS)
  ConcreteDE10Pro_bsv_shell_Sig;
typedef DE10Pro_bsv_shell_Sig_Avalon #(`CONCRETE_PARAMS)
  ConcreteDE10Pro_bsv_shell_Avalon;

module mkPassThroughToDRAMDE10Pro_bsv_shell (ConcreteDE10Pro_bsv_shell);
  NumProxy #(2) proxyInDepth = ?;
  NumProxy #(2) proxyOutDepth = ?;
  match {.h2fSub, .h2fMgr} <-
    mkAXI4DataWidthShim_NarrowToWide (proxyInDepth, proxyOutDepth);
  let ddrbShim <- mkAXI4ShimFF;
  let ddrcShim <- mkAXI4ShimFF;
  let ddrdShim <- mkAXI4ShimFF;
  let ddrbMgr <- mkAXI4SingleIDMaster (ddrbShim.master);
  let ddrcMgr <- mkAXI4SingleIDMaster (ddrcShim.master);
  let ddrdMgr <- mkAXI4SingleIDMaster (ddrdShim.master);
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
            , cons (h2fMgr, nil)
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
  interface     axs_h2f = prepend_AXI4_Slave_id (0, h2fSub);
  interface     axm_f2h = culDeSac;
  interface    axm_ddrb = ddrbMgr;
  interface    axm_ddrc = ddrcMgr;
  interface    axm_ddrd = ddrdMgr;
  interface    tx_north = nullSource;
  interface    rx_north =   nullSink;
  interface     tx_east = nullSource;
  interface     rx_east =   nullSink;
  interface    tx_south = nullSource;
  interface    rx_south =   nullSink;
  interface     tx_west = nullSource;
  interface     rx_west =   nullSink;
  interface irqs = replicate (noIrq);
endmodule

module mkPassThroughToDRAMDE10Pro_bsv_shell_Sig (ConcreteDE10Pro_bsv_shell_Sig);
  let noSig <- mkPassThroughToDRAMDE10Pro_bsv_shell;
  let sig <- toDE10Pro_bsv_shell_Sig (noSig);
  return sig;
endmodule

module mkPassThroughToDRAMDE10Pro_bsv_shell_Sig_Avalon
  (ConcreteDE10Pro_bsv_shell_Avalon);
  let ifc <- mkPassThroughToDRAMDE10Pro_bsv_shell;
  let avalonIfc <- toDE10Pro_bsv_shell_Sig_Avalon (ifc);
  return avalonIfc;
endmodule

module mkDummyDE10Pro_bsv_shell_Sig (ConcreteDE10Pro_bsv_shell_Sig);
  let dummy_tx_north <- toSource_Sig (nullSource);
  let dummy_rx_north <-     toSink_Sig (nullSink);
  let dummy_tx_east  <- toSource_Sig (nullSource);
  let dummy_rx_east  <-     toSink_Sig (nullSink);
  let dummy_tx_south <- toSource_Sig (nullSource);
  let dummy_rx_south <-     toSink_Sig (nullSink);
  let dummy_tx_west  <- toSource_Sig (nullSource);
  let dummy_rx_west  <-     toSink_Sig (nullSink);
  interface axls_h2f_lw =       culDeSac;
  interface     axs_h2f =       culDeSac;
  interface     axm_f2h =       culDeSac;
  interface    axm_ddrb =       culDeSac;
  interface    axm_ddrc =       culDeSac;
  interface    axm_ddrd =       culDeSac;
  interface    tx_north = dummy_tx_north;
  interface    rx_north = dummy_rx_north;
  interface     tx_east =  dummy_tx_east;
  interface     rx_east =  dummy_rx_east;
  interface    tx_south = dummy_tx_south;
  interface    rx_south = dummy_rx_south;
  interface     tx_west =  dummy_tx_west;
  interface     rx_west =  dummy_rx_west;
  interface irqs = 0;
endmodule

endpackage
