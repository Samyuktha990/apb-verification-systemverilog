interface apb_if(input pclk, prst);

logic pwrite;
logic penable;
logic psel;
logic pready;
logic pslverr;
logic [31:0] paddr;
logic [31:0] pwdata;
logic [31:0] prdata;

clocking cb @(posedge pclk);
  default input #1 output #10;

  input  prdata;
  input  pready;
  input  pslverr;

  output pwrite;
  output penable;
  output psel;
  output pwdata;
  output paddr;
endclocking

modport dut(
  input  pwrite, penable, psel, pclk, prst, pwdata, paddr,
  output prdata, pready, pslverr
);

modport tb(
  output pwrite, penable, psel, pwdata, paddr,
  input  prdata, pready, pslverr
);

endinterface
