`ifndef _apb_sb_
`define _apb_sb_


`include "apb_base.sv"

class apb_sb;
bit [31:0] mem[*];
apb_base pkt1, pkt2;
mailbox drv2sb, mon2sb;
int pass_count = 0;
int fail_count = 0;

function new(apb_base pkt1, pkt2, mailbox drv2sb, mon2sb);
this.pkt1=pkt1;
this.pkt2=pkt2;
this.drv2sb=drv2sb;
this.mon2sb=mon2sb;
endfunction

task sb_run1();
begin

drv2sb.get(pkt1);

mem[pkt1.paddr]=pkt1.pwdata;

pkt1.prdata=mem[pkt1.paddr];
end
endtask


task sb_run();
begin

  mon2sb.get(pkt2);

  if(pkt2.prdata == pkt1.prdata) 
  begin
  pass_count++;
    $display("[%0t] APB READ MATCH  | Addr = 0x%0h | Expected = 0x%0h | Actual = 0x%0h",
              $time, pkt2.paddr, pkt1.prdata, pkt2.prdata);
  end
  else
  begin
  fail_count++;
    $display("[%0t] APB READ MISMATCH | Addr = 0x%0h | Expected = 0x%0h | Actual = 0x%0h",
              $time, pkt2.paddr, pkt1.prdata, pkt2.prdata);
  end
end
endtask

task report();
  $display("\n=====================================");
  $display("APB TEST SUMMARY");
  $display("PASS COUNT = %0d", pass_count);
  $display("FAIL COUNT = %0d", fail_count);

  if (fail_count == 0)
    $display("FINAL RESULT: APB TEST PASSED ?");
  else
    $display("FINAL RESULT: APB TEST FAILED ?");

  $display("=====================================\n");
endtask
endclass



`endif