`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: [Your Name]
// 
// Create Date: 08.02.2025
// Design Name: Cache Top Module
// Module Name: cache_top
// Project Name: Set-Associative Cache with FIFO Replacement
// Description: 
//     - Top-level integration of cache memory and FIFO replacement logic.
//     - Provides read/write access with hit/miss handling.
//     - Automatically updates replacement way on write miss.
//
// Inputs:
//     - clk          : System clock
//     - reset        : Asynchronous reset
//     - read         : Read enable
//     - write        : Write enable
//     - address[31:0]: 32-bit memory address
//     - write_data   : Data to write into cache (if write enabled)
//
// Outputs:
//     - read_data    : Data read from cache (if read enabled)
//     - hit          : Indicates whether access is a cache hit or miss
//
//////////////////////////////////////////////////////////////////////////////////

module cache_top (
    input clk,
    input reset,
    input read,
    input write,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data,
    output  hit
);

    // Output from FIFO module: indicates which way to replace on write miss
    wire [1:0] replace_way;

    // Generate FIFO update signal (only when a write is attempted)
    wire fifo_update = write;

    //===============================
    // Cache Memory Submodule
    //===============================
    // - Handles tag checking, hit detection, data storage
    // - Uses the replace_way from FIFO logic when inserting new blocks
    cache_memory u_cache (
        .clk(clk),
        .reset(reset),
        .read(read),
        .write(write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .hit(hit),
        .replace_way(replace_way)  // Input: Way chosen by FIFO for replacement
    );

    //===============================
    // FIFO Replacement Submodule
    //===============================
    // - Maintains a 2-bit counter per set (32 sets total)
    // - Counter selects one of 4 ways (0-3) for replacement
    fifo_replacement u_fifo (
        .clk(clk),
        .reset(reset),
        .update(fifo_update),       // Trigger update on each write (miss logic inside cache)
        .index(address[9:5]),       // Set index extracted from address
        .replace_way(replace_way)   // Output: next way to be replaced
    );

endmodule
