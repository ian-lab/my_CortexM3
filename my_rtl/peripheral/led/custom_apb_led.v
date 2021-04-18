//
module custom_apb_led(
    //led core ports
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] ledNumIn,
    output reg  [3:0]  ledNumOut    // When high, the LED on board turns on
);

always @ (posedge clk or negedge rst)
begin
    if(!rst)
        ledNumOut <= 4'b0;
    else if(ledNumIn >= 4'b1111)
        ledNumOut <= 4'b0;
    else
        ledNumOut <= ledNumIn;
end

endmodule