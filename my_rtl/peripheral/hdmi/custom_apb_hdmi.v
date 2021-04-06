

module custom_apb_hdmi #(
    parameter memory_depth = 784
)
(
    input                       PCLK,    
    input                       PRESETN,  
    //APB
    input                       PSEL,
    input      [11 : 2]         PADDR,
    input                       PENABLE,
    input                       PWRITE,
    input      [31:0]           PWDATA,

    output     [31:0]           PRDATA,
    output                      PREDAY,
    output                      PSELVER
    
);

assign PREDAY = 1'b1;
assign PSELVER = 1'b0;

(*rom_style="block"*) reg [7:0] memory [memory_depth - 1 : 0];

wire write_en = PSEL & PWRITE & (~PENABLE);
reg wr_en_reg;

always@(posedge PCLK or negedge PRESETN) begin
  if(~PRESETN) 
    wr_en_reg <= 1'b0;
  else if(write_en) 
    wr_en_reg <= 1'b1;
  else 
    wr_en_reg <= 1'b0;
end

always @(posedge PCLK or negedge PRESETN) begin
    if(~PRESETN) begin
        
    end else if(wr_en_reg) begin
        memory[{PADDR[11:2], 2'b00}] <= PWDATA[ 7: 0];
        memory[{PADDR[11:2], 2'b01}] <= PWDATA[15: 8];
        memory[{PADDR[11:2], 2'b10}] <= PWDATA[23:16];
        memory[{PADDR[11:2], 2'b11}] <= PWDATA[31:24];
    end
end

wire read_en = PSEL & (~PWRITE);
assign PRDATA = read_en ? { memory[{PADDR[11:2], 2'b11}], memory[{PADDR[11:2], 2'b10}],
                            memory[{PADDR[11:2], 2'b01}], memory[{PADDR[11:2], 2'b00}] } : {32{1'b0}};

// reg rd_en_reg;
// always @(posedge PCLK or negedge PRESETN) begin 
//     if(~PRESETN) begin
//         PREDAY <= 1'b0;
//     end  
//     else if(read_en) begin
//         read_en<
//     end
//     else 
//       rd_en_reg <= 1'b0;
// end
 


endmodule