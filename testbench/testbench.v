`timescale 1ps/1ps

module tb();

reg clk;
reg rstn;

CortexM3 #(
    .SimPresent (1 )
)
u_SOC(
    .CLK50m(clk),
    .RSTn(rstn),
    .RXD(1'b0)
);


initial begin
    clk = 1;
    rstn = 0;
    #101
    rstn = 1;
end

always begin
    #10 clk = ~clk;
end

endmodule