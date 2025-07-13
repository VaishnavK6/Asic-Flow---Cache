`timescale 1ns / 1ps

module tb_cache_top;

  // Testbench signals
  reg clk;
  reg reset;
  reg read;
  reg write;
  reg [31:0] address;
  reg [31:0] write_data;
  wire [31:0] read_data;
  wire hit;

  // Instantiate the DUT (Device Under Test)
  cache_top dut (
    .clk(clk),
    .reset(reset),
    .read(read),
    .write(write),
    .address(address),
    .write_data(write_data),
    .read_data(read_data),
    .hit(hit)
  );

  // Clock generation: 100 MHz
  always #5 clk = ~clk;

  // Task to perform write operation
  task write_cache(input [31:0] addr, input [31:0] data);
    begin
      @(negedge clk);
      address = addr;
      write_data = data;
      write = 1;
      read = 0;
      @(negedge clk);
      write = 0;
    end
  endtask

  // Task to perform read operation
  task read_cache(input [31:0] addr);
    begin
      @(negedge clk);
      address = addr;
      read = 1;
      write = 0;
      @(negedge clk);
      read = 0;
    end
  endtask

  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    read = 0;
    write = 0;
    address = 0;
    write_data = 0;

    // Reset pulse
    #20;
    reset = 0;

    // Test writes to the same set with different tags
    write_cache(32'h0000_0040, 32'hAAAA_AAAA);  // Tag 0x00000, Index 1
    write_cache(32'h0000_0840, 32'hBBBB_BBBB);  // Tag 0x00002, Index 1
    write_cache(32'h0000_1040, 32'hCCCC_CCCC);  // Tag 0x00004, Index 1
    write_cache(32'h0000_1840, 32'hDDDD_DDDD);  // Tag 0x00006, Index 1
    write_cache(32'h0000_2040, 32'hEEEE_EEEE);  // Should trigger FIFO replacement

    // Corresponding reads
    read_cache(32'h0000_0040);  // Might miss (replaced)
    read_cache(32'h0000_0840);  // Should hit
    read_cache(32'h0000_1040);  // Should hit
    read_cache(32'h0000_1840);  // Should hit
    read_cache(32'h0000_2040);  // Should hit
  end

endmodule
