module EightQueensSolver (
    input logic clk, reset
);

    // Internal connections
    logic [2:0] row, col;
    logic place_queen, remove_queen, is_safe;
    logic [7:0] row_used, col_used;
    logic [14:0] left_diag, right_diag;

    EightQueensDataPath datapath (
        .clk(clk),
        .reset(reset),
        .row(row),
        .col(col),
        .place_queen(place_queen),
        .remove_queen(remove_queen),
        .row_used(row_used),
        .col_used(col_used),
        .left_diag(left_diag),
        .right_diag(right_diag),
        .is_safe(is_safe)
    );

    EightQueensController controller (
        .clk(clk),
        .reset(reset),
        .row(row),
        .col(col),
        .place_queen(place_queen),
        .remove_queen(remove_queen),
        .is_safe(is_safe)
    );

endmodule

