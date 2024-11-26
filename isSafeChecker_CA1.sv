`timescale 1ns/1ns
module NQueens;

// Parameter for board size
localparam int N = 8;
bit [7:0] board [0:N-1];

// Function to check if a queen can be placed safely
function automatic bit isSafe(input bit [7:0] board[], input int row, input int col);
    for (int i = 0; i < col; i++) begin
        // Check if there is a queen in the same row
        if ((board[row] & (1 << i)) != 0) 
            return 0; // false

        // Check for queens on upper left diagonal
        if ((row - (col - i) >= 0) && ((board[row - (col - i)] & (1 << i)) != 0))
            return 0; // false

        // Check for queens on lower left diagonal
        if ((row + (col - i) < N) && ((board[row + (col - i)] & (1 << i)) != 0))
            return 0; // false
    end
    return 1; // true
endfunction

// Testbench to verify the isSafe function
initial begin
    // Open a VCD file for waveform output
    $dumpfile("NQueens.vcd");
    $dumpvars(0, NQueens);

    // Test case 1: No queens placed
    for (int i = 0; i < N; i++) 
        board[i] = 8'b00000000; // Empty board

    // Expect true since no queens are placed
    if (isSafe(board, 0, 0) != 1) begin
        $fatal(0, "Test case 1 failed!"); // Correct usage
    end

    // Test case 2: One queen placed
    board[0] = 8'b00000001; // Place a queen in the first column of the first row

    // Expect true since no conflicts
    if (isSafe(board, 1, 1) != 1) begin
        $fatal(0, "Test case 2 failed!"); // Correct usage
    end

    // Test case 3: Queen in the same row
    board[1] = 8'b00000010; // Place a queen in the first column of the second row

    // Expect false since there's a queen in the same row
    if (isSafe(board, 1, 0) != 0) begin
        $fatal(0, "Test case 3 failed!"); // Correct usage
    end

    // Test case 4: Queen in the upper left diagonal
    board[2] = 8'b00000000; // Clear row 2
    board[0] = 8'b00000001; // Queen in row 0, column 0
    board[1] = 8'b00000000; // Clear row 1

    // Expect false since there's a queen on the upper left diagonal
    if (isSafe(board, 1, 1) != 0) begin
        $fatal(0, "Test case 4 failed!"); // Correct usage
    end

    // Test case 5: Queen in the lower left diagonal
    board[0] = 8'b00000001; // Queen in row 0, column 0
    board[1] = 8'b00000000; // Clear row 1
    board[2] = 8'b00000000; // Clear row 2

    // Place a queen in row 2, column 1
    board[2] = 8'b00000010; 

    // Expect false since there's a queen on the lower left diagonal
    if (isSafe(board, 3, 1) != 0) begin
        $fatal(0, "Test case 5 failed!"); // Correct usage
    end

    // Test case 6: Valid placement
    board[0] = 8'b00000001; // Queen in row 0, column 0
    board[1] = 8'b00000000; // Clear row 1
    board[2] = 8'b00000010; // Queen in row 2, column 1
    board[3] = 8'b00000000; // Clear row 3

    // Expect true since there's no conflict
    if (isSafe(board, 3, 2) != 1) begin
        $fatal(0, "Test case 6 failed!"); // Correct usage
    end

    // Print test completion
    $display("All test cases passed!");
    $finish;
end

endmodule
