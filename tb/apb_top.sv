`include "apb3_slave.sv"
`include "apb_env.sv"
`include "apb_if.sv"
`include "apb_dut.sv"
`include "apb_tb.sv"

module apb_top();
bit pclk;
bit prst;
apb_if intf(pclk,prst);
apb_dut dut (intf);
apb_tb tb(intf);

initial
begin
  prst=0;
  #10
  prst=1;
  #1000 $finish;
end

initial begin
	pclk=0;
	forever #5 pclk=~pclk;
end

endmodule

