module HazardUnit(
    Rs1D, Rs2D, RdE, RdM, RdW, Rs2E, Rs1E,
    PCSrcE, resultSrc0, regWriteW,
    regWriteM, stallF, stallD, flushD,
    flushE, forwardAE, forwardBE, luiM
);

    input [4:0] Rs1D, Rs2D, RdE, RdM, RdW, Rs1E, Rs2E;
    input [1:0] PCSrcE;
    input regWriteM, regWriteW, resultSrc0, luiM;
    output reg [1:0] forwardAE, forwardBE;
    output wire stallF, stallD, flushD, flushE; // Changed from reg to wire

    always @(Rs1E or RdM or RdW or regWriteM or regWriteW) begin
        if (Rs1E == 5'b0)
            forwardAE <= 2'b00;
        else if ((Rs1E == RdM) && regWriteM)
            forwardAE <= (luiM) ? 2'b11 : 2'b10;
        else if ((Rs1E == RdW) && regWriteW)
            forwardAE <= 2'b01;
        else 
            forwardAE <= 2'b00;
    end    

    always @(Rs2E or RdM or RdW or regWriteM or regWriteW) begin
        if (Rs2E == 5'b0)
            forwardBE <= 2'b00;
        else if ((Rs2E == RdM) && regWriteM)
            forwardBE <= (luiM) ? 2'b11 : 2'b10;
        else if ((Rs2E == RdW) && regWriteW)
            forwardBE <= 2'b01;
        else 
            forwardBE <= 2'b00;
    end 

    // Change lwStall to wire
    wire lwStall;
    assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && resultSrc0;

    // Continuous assignments for stall and flush signals
    assign stallF = lwStall;
    assign stallD = lwStall;

    assign flushD = (PCSrcE != 2'b00);
    assign flushE = lwStall || (PCSrcE != 2'b00);

endmodule
