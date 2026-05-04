module apb_slave(
  input pclk,
  input prst,
  input [31:0] paddr,
  input [31:0] pwdata,
  input pwrite,
  input psel,
  input penable,
  output reg [31:0] prdata,
  output reg pready,
  output reg slverr
);

  reg [31:0] mem[0:63];

  always @(posedge pclk) begin
    if (prst == 0) begin
      prdata <= 0;
      pready <= 0;
      slverr <= 0;
    end
    else begin
      if (psel == 1 && penable == 1) begin
        pready <= 1;

        if (paddr > 63) begin
          slverr <= 1;
          prdata <= 0;
        end
        else begin
          slverr <= 0;

          if (pwrite == 1)
            mem[paddr] <= pwdata;
          else
            prdata <= mem[paddr];
        end
      end
      else begin
        pready <= 0;
        slverr <= 0;
      end
    end
  end

endmodule
