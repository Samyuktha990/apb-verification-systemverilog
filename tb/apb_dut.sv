module apb_dut(apb_if.dut intf);

apb_slave Vcode(
  .pclk(intf.pclk),
  .prst(intf.prst),
  .paddr(intf.paddr),
  .pwdata(intf.pwdata),
  .pwrite(intf.pwrite),
  .psel(intf.psel),
  .penable(intf.penable),
  .prdata(intf.prdata),
  .pready(intf.pready),
  .slverr(intf.pslverr)   // ? FIX
);

endmodule
