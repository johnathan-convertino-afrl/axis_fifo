//******************************************************************************
// file:    tb_coctb.v
//
// author:  JAY CONVERTINO
//
// date:    2024/12/10
//
// about:   Brief
// Test bench wrapper for cocotb
//
// license: License MIT
// Copyright 2024 Jay Convertino
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//******************************************************************************

`timescale 1ns/100ps

/*
 * Module: tb_cocotb
 *
 * Test bench for axis_fifo. This will run a file through the system
 * and write its output. These can then be compared to check for errors.
 * If the files are identical, no errors. A FST file will be written.
 *
 * Parameters:
 *
 *    FIFO_DEPTH  - Depth of the fifo, must be a power of two number(divisable aka 256 = 2^8). Any non-power of two will be rounded up to the next closest.
 *    COUNT_WIDTH - Data count output width in bits. Should be the same power of two as fifo depth(256 for fifo depth... this should be 8).
 *    BUS_WIDTH   - Width of the axis data bus input/output in bytes.
 *    USER_WIDTH  - Width of the axis user bus input/output in bits.
 *    DEST_WIDTH  - Width of the axis dest bus input/output in bits.
 *    RAM_TYPE    - RAM type setting.
 *    PACKET_MODE - Set axis fifo to wait for tlast before allowing a read on master port output.
 *    COUNT_DELAY - Delay count by one clock cycle of the data count clock.
 *    COUNT_ENA   - Enable count, set this to 0 to disable (only disable if read/write/data_count are on the same clock domain!).
 *
 * Ports:
 *
 *    m_axis_aclk       - Clock for AXIS
 *    m_axis_arstn      - Negative reset for AXIS
 *    m_axis_tvalid     - When active high the output data is valid
 *    m_axis_tready     - When set active high the output device is ready for data.
 *    m_axis_tdata      - Output data
 *    m_axis_tkeep      - Output valid byte indicator
 *    m_axis_tlast      - Indicates last word in stream.
 *    m_axis_tuser      - Output user bus
 *    m_axis_tdest      - Output destination
 *    s_axis_aclk       - Clock for AXIS
 *    s_axis_arstn      - Negative reset for AXIS
 *    s_axis_tvalid     - When set active high the input data is valid
 *    s_axis_tready     - When active high the device is ready for input data.
 *    s_axis_tdata      - Input data
 *    s_axis_tkeep      - Input valid byte indicator
 *    s_axis_tlast      - Is this the last word in the stream (active high).
 *    s_axis_tuser      - Input user bus
 *    s_axis_tdest      - Input desitination
 *    data_count_aclk   - Clock for data count
 *    data_count_arstn  - Negative edge reset for data count.
 *    data_count        - Output that indicates the amount of data in the FIFO.
 */
module tb_cocotb #(
    parameter FIFO_DEPTH  = 256,
    parameter COUNT_WIDTH = 8,
    parameter BUS_WIDTH   = 1,
    parameter USER_WIDTH  = 1,
    parameter DEST_WIDTH  = 1,
    parameter RAM_TYPE    = "block",
    parameter PACKET_MODE = 0,
    parameter COUNT_DELAY = 1,
    parameter COUNT_ENA   = 1
  )
  (
    input                       m_axis_aclk,
    input                       m_axis_arstn,
    output                      m_axis_tvalid,
    input                       m_axis_tready,
    output  [(BUS_WIDTH*8)-1:0] m_axis_tdata,
    output  [BUS_WIDTH-1:0]     m_axis_tkeep,
    output                      m_axis_tlast,
    output  [USER_WIDTH-1:0]    m_axis_tuser,
    output  [DEST_WIDTH-1:0]    m_axis_tdest,
    input                       s_axis_aclk,
    input                       s_axis_arstn,
    input                       s_axis_tvalid,
    output                      s_axis_tready,
    input   [(BUS_WIDTH*8)-1:0] s_axis_tdata,
    input   [BUS_WIDTH-1:0]     s_axis_tkeep,
    input                       s_axis_tlast,
    input   [USER_WIDTH-1:0]    s_axis_tuser,
    input   [DEST_WIDTH-1:0]    s_axis_tdest,
    input                       data_count_aclk,
    input                       data_count_arstn,
    output  [COUNT_WIDTH:0]     data_count
  );
  // fst dump command
  initial begin
    $dumpfile ("tb_cocotb.fst");
    $dumpvars (0, tb_cocotb);
    #1;
  end
  
  //Group: Instantiated Modules

  /*
   * Module: dut
   *
   * Device under test, axis_fifo
   */
  axis_fifo #(
    .FIFO_DEPTH(FIFO_DEPTH),
    .COUNT_WIDTH(COUNT_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .USER_WIDTH(USER_WIDTH),
    .DEST_WIDTH(DEST_WIDTH),
    .RAM_TYPE(RAM_TYPE),
    .PACKET_MODE(PACKET_MODE),
    .COUNT_DELAY(COUNT_DELAY),
    .COUNT_ENA(COUNT_ENA)
  ) dut (
    .s_axis_aclk(s_axis_aclk),
    .s_axis_arstn(s_axis_arstn),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tlast(s_axis_tlast),
    .s_axis_tuser(s_axis_tuser),
    .s_axis_tdest(s_axis_tdest),
    .m_axis_aclk(m_axis_aclk),
    .m_axis_arstn(m_axis_arstn),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tuser(m_axis_tuser),
    .m_axis_tdest(m_axis_tdest),
    .data_count_aclk(data_count_aclk),
    .data_count_arstn(data_count_arstn),
    .data_count(data_count)
  );
  
endmodule

