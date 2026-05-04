`ifndef __apb_env__
`define __apb_env__

`include "apb_base.sv"
`include "apb_sb.sv"
`include "apb_mon.sv"
`include "apb_drv.sv"
`include "apb_gen.sv"
`include "apb_con.sv"

class apb_env;
apb_base pkt1, pkt2;
mailbox gen2drv, drv2sb, mon2sb;
apb_con cfg;
apb_gen gen;
apb_drv drv;
apb_mon mon;
apb_sb sb;
virtual apb_if intf;

function new(apb_con cfg, virtual apb_if intf);
this.pkt1=new();
this.pkt2=new();
this.gen2drv=new();
this.drv2sb=new();
this.mon2sb=new();

this.cfg=cfg;
this.intf=intf;
this.gen=new(pkt1, gen2drv);
this.drv= new(pkt1, gen2drv, drv2sb, intf);
this.mon=new(pkt2,mon2sb, intf);
this.sb=new(pkt1,pkt2, drv2sb, mon2sb);
endfunction

task env_run();
begin
  $display("\n========== APB VERIFICATION START ==========");

  reset_test();
  valid_write_read_test();
  multiple_address_test();
  overwrite_test();
  pslverr_test();

  sb.report();

  $display("========== APB VERIFICATION END ==========\n");
end
endtask

task reset_test();
begin
  $display("\nTEST 1: RESET TEST");

  intf.psel    <= 0;
  intf.penable <= 0;
  intf.pwrite  <= 0;
  intf.paddr   <= 0;
  intf.pwdata  <= 0;

  @(posedge intf.pclk);

  if (intf.prdata == 0 && intf.pready == 0 && intf.pslverr == 0) begin
    sb.pass_count++;
    $display("RESET TEST PASSED");
  end
  else begin
    sb.fail_count++;
    $display("RESET TEST FAILED");
  end
end
endtask

task valid_write_read_test();
begin
  $display("\nTEST 2: VALID WRITE-READ TEST");

  drv.apb_write(32'h10, 32'hA5);
  sb.store_expected(32'h10, 32'hA5);

  drv.apb_read(32'h10);
  #1;
  sb.check_read(32'h10, intf.prdata);
end
endtask

task multiple_address_test();
begin
  $display("\nTEST 3: MULTIPLE ADDRESS TEST");

  drv.apb_write(32'h01, 32'h11);
  sb.store_expected(32'h01, 32'h11);

  drv.apb_write(32'h02, 32'h22);
  sb.store_expected(32'h02, 32'h22);

  drv.apb_write(32'h03, 32'h33);
  sb.store_expected(32'h03, 32'h33);

  drv.apb_read(32'h01); #1; sb.check_read(32'h01, intf.prdata);
  drv.apb_read(32'h02); #1; sb.check_read(32'h02, intf.prdata);
  drv.apb_read(32'h03); #1; sb.check_read(32'h03, intf.prdata);
end
endtask

task overwrite_test();
begin
  $display("\nTEST 4: OVERWRITE TEST");

  drv.apb_write(32'h05, 32'hAA);
  sb.store_expected(32'h05, 32'hAA);

  drv.apb_write(32'h05, 32'h55);
  sb.store_expected(32'h05, 32'h55);

  drv.apb_read(32'h05);
  #1;
  sb.check_read(32'h05, intf.prdata);
end
endtask

task pslverr_test();
begin
  $display("\nTEST 5: PSLVERR TEST");

  drv.apb_read(32'd100);
  #1;

  if (intf.pslverr == 1)
    $display("PSLVERR TEST PASSED | Invalid address detected");
  else
    $display("PSLVERR TEST FAILED | PSLVERR not asserted");
end
endtask
endclass

`endif