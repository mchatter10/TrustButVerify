// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Interface for verifying the reseed activity of the masking PRNG inside AES. This interface
// can only be used if masking is enabled via compile-time parameter. If masking is disabled,
// only the aes_reseed_if interface can be used.

`include "prim_assert.sv"

interface aes_masking_reseed_if
  import aes_pkg::*;
  import aes_reg_pkg::*;
#(
  parameter int unsigned EntropyWidth = edn_pkg::ENDPOINT_BUS_WIDTH,
  parameter int unsigned StateWidth   = prim_trivium_pkg::BiviumStateWidth
) (
  input logic clk_i,
  input logic rst_ni,

  // Entropy request/ack signals
  input logic entropy_masking_req,
  input logic entropy_masking_ack,

  // Entropy input and PRNG state signals
  input logic [EntropyWidth-1:0] entropy_i,
  input logic [StateWidth-1:0]   state_q,

  // Control signals
  input logic      block_ctr_expr,
  input aes_ctrl_e ctrl_state,
  input aes_ctrl_e ctrl_state_next,
  input logic      alert_fatal,

  //for added assertion
  input logic trigger_start,
  input logic manual_operation,
  input logic [5:0] ctrl_mode,
  input logic idle,
  input logic output_valid,
  input logic output_lost,
  input logic stall,
  input logic [127:0] data_in,
  input logic [255:0] key_touch_forces_reseed,
  input logic iv_ready
);

  localparam int unsigned LastStatePartFractional = StateWidth % EntropyWidth != 0 ? 1 : 0;
  localparam int unsigned NumStateParts = StateWidth / EntropyWidth + LastStatePartFractional;
  localparam int unsigned NumBitsLastPart = StateWidth - (NumStateParts - 1) * EntropyWidth;
  localparam int unsigned LastStatePart = NumStateParts - 1;

  logic [NumStateParts-1:0] state_part_matches_input;
  always_comb begin
    state_part_matches_input = '0;
    for (int unsigned i = 0; i < LastStatePart; i++) begin
      state_part_matches_input[i] = state_q[i * EntropyWidth +: EntropyWidth] == entropy_i;
    end
    state_part_matches_input[LastStatePart] =
        state_q[StateWidth - 1 -: NumBitsLastPart] == entropy_i[NumBitsLastPart-1:0];
  end

  // Make sure the entropy input obtained from EDN actually ends up in one part of the PRNG state.
  `ASSERT(MaskingPrngStatePartMatchesEdnInput_A, entropy_masking_req && entropy_masking_ack
      |-> ##1 |state_part_matches_input)

  // Make sure the masking PRNG is reseeded when a new block is started while the block counter
  // has expired unless a fatal alert is triggered.
  `ASSERT(MaskingPrngReseedWhenCtrExpires_A,
      (block_ctr_expr && (ctrl_state == CTRL_IDLE) && (ctrl_state_next == CTRL_LOAD)) |->
      ##[1:20] entropy_masking_req || alert_fatal)

//----------------//
//ADDED ASSERTIONS//
//----------------//


  
  // TC_START_01: Normal Trigger Start (Manual Mode)
  `ASSERT(TC_START_01_A,
    (trigger_start && idle) |-> ##[1:3] !idle)

  // TC_START_02: Trigger Ignored (Automatic Mode)
  `ASSERT(TC_START_02_A, //##1 
    (!manual_operation && trigger_start) |-> ##[1:$] idle)

  // TC_START_03: Premature Trigger While Busy
  `ASSERT(TC_START_03_A,
    (!idle && trigger_start) |-> ##1 !idle)

  // TC_START_04: Output Overwrite Check
  `ASSERT(TC_START_04_A,
    (trigger_start && output_valid) |-> ##[1:3] output_lost)

  // TC_START_05: Missing Inputs Prevent Start (Auto Mode)
  `ASSERT(TC_START_05_A,
    (!manual_operation && (!iv_ready || (data_in === 'x))) |-> ##[0:$] idle)

  // TC_START_06: Reset Effect on Trigger
  `ASSERT(TC_START_06_A,
    !rst_ni |-> ##1 (!trigger_start && idle))

  // TC_START_07: Key Change Triggers Reseed
  `ASSERT(TC_START_07_A,//[1:5]
    (trigger_start && key_touch_forces_reseed !== 'x) |-> ##[5:$] alert_fatal || !idle)

  // TC_START_08: Trigger with AES_NONE Mode
  `ASSERT(TC_START_08_A,
    (ctrl_mode == 6'b10_0000 && trigger_start) |-> ##1 idle)

endinterface // aes_masking_reseed_if