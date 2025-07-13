`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:
// 
// Create Date: 08.02.2025
// Design Name: FIFO Replacement Logic
// Module Name: fifo_replacement
// Project Name: Cache Memory System
// Description: 
//     - Implements FIFO (First-In-First-Out) replacement for a 4-way set-associative cache.
//     - Each cache set (32 total) has a 2-bit counter (0 to 3) indicating the next way to be replaced.
//     - When `update` is high, the module outputs the current replacement way and increments the counter.
//     - After reaching 3, the counter wraps around to 0.
//
// Inputs:
//     - clk      : System clock
//     - reset    : Active-high synchronous reset
//     - update   : Triggers the replacement and counter update
//     - index[4:0]: Cache index (0 to 31)
//
// Output:
//     - replace_way[1:0]: Indicates which way (0-3) should be replaced
//
//////////////////////////////////////////////////////////////////////////////////

module fifo_replacement (
    input clk,
    input reset,
    input update,
    input [4:0] index,         // Cache set index (32 sets)
    output reg [1:0] replace_way // Way number to replace (0-3)
);

    // 32 counters, one for each set
    reg [1:0] fifo_counter [31:0];
    integer i;

    // Sequential logic: counter update and replacement decision
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all counters to 0 on reset
            for (i = 0; i < 32; i = i + 1)
                fifo_counter[i] <= 2'b00;
        end
        else if (update) begin
            // Output the current replacement way
            replace_way <= fifo_counter[index];
            // Increment the counter (wraps automatically since it's 2-bit)
            fifo_counter[index] <= fifo_counter[index] + 1'b1;
        end
    end

endmodule
