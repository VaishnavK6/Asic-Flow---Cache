`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date: 08.02.2025
// Design Name: Cache Memory (4-way Set Associative)
// Module Name: cache_memory
// Project Name: Cache Simulation
// Target Devices: FPGA / Simulation
// Tool Versions: Vivado / ModelSim-compatible
// Description: 
//    - Implements a 4-way set-associative cache
//    - Tag comparison for read and write
//    - Simple replacement policy using external `replace_way` input
//    - Each cache line holds a single 32-bit word
//////////////////////////////////////////////////////////////////////////////////

module cache_memory (
    input clk,                   // System clock
    input reset,                 // Active-high reset
    input read,                  // Read enable
    input write,                 // Write enable
    input [31:0] address,        // 32-bit memory address
    input [31:0] write_data,     // Data to be written
    output reg [31:0] read_data, // Output data (valid if hit = 1)
    output reg hit,              // High if access is a hit
    input [1:0] replace_way      // Replacement way selector (0 to 3)
);

    // Cache Parameters
    parameter NUM_WAYS = 4;   // 4-way set-associative
    parameter NUM_SETS = 32;  // 5-bit index: 2^5 = 32 sets

    // Cache Storage:
    // Each set has 4 ways, each with valid, tag, and data
    reg valid [NUM_SETS-1:0][NUM_WAYS-1:0];     // Valid bits
    reg [24:0] tag [NUM_SETS-1:0][NUM_WAYS-1:0];// 27-bit tag (from address[31:10])
    reg [31:0] data [NUM_SETS-1:0][NUM_WAYS-1:0];// 32-bit data word per line

    // Address decoding
    wire [4:0] index = address[6:2];   // Set index (5 bits for 32 sets)
    wire [24:0] tag_in = address[31:7]; // Tag (remaining upper 25 bits)

    integer i, j;

    // -----------------------------
    // Write & Reset Logic (Sync)
    // -----------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all valid bits and tags to zero
            for (i = 0; i < NUM_SETS; i = i + 1) begin
                for (j = 0; j < NUM_WAYS; j = j + 1) begin
                    valid[i][j] <= 0;
                    tag[i][j] <= 0;
                    data[i][j] <= 0;
                end
            end
        end
        else if (write) begin
            hit = 0;
            // Search all ways for a hit
            for (i = 0; i < NUM_WAYS; i = i + 1) begin
                if (valid[index][i] && tag[index][i] == tag_in) begin
                    data[index][i] <= write_data; // Write data to matching line
                    hit = 1; // Write hit
                end
            end
            // If miss, use external replacement way
            if (!hit) begin
                valid[index][replace_way] <= 1;
                tag[index][replace_way] <= tag_in;
                data[index][replace_way] <= write_data;
            end
        end
    end

    // -----------------------------
    // Read Logic (Combinational)
    // -----------------------------
    always @(*) begin
        hit = 0;
        read_data = 32'b0;
        if (read) begin
            // Check each way for a matching valid tag
            for (i = 0; i < NUM_WAYS; i = i + 1) begin
                if (valid[index][i] && tag[index][i] == tag_in) begin
                    read_data = data[index][i]; // Return data
                    hit = 1; // Read hit
                end
            end
        end
    end

endmodule
