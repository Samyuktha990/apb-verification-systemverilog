`ifndef _apb_sb_
`define _apb_sb_


`include "apb_base.sv"

class apb_sb;
bit [31:0] mem[*];
bit [31:0] exp_mem [int];
int pass_count;
int fail_count;
apb_base pkt1, pkt2;
mailbox drv2sb, mon2sb;

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

if(pkt2.prdata==pkt1.prdata)
$display("%t Matched pkt2.prdata=%d, pkt1.prdata=%d",$time,pkt2.prdata, pkt1.prdata);
else
$display("%t Not Matched pkt2.prdata=%d, pkt1.prdata=%d",$time,pkt2.prdata, pkt1.prdata);
end

endtask

task store_expected(input [31:0] addr, input [31:0] data);
begin
  exp_mem[addr] = data;
end
endtask

task check_read(input [31:0] addr, input [31:0] actual);
begin
  if (exp_mem.exists(addr) && actual == exp_mem[addr]) begin
    pass_count++;
    $display("[%0t] READ MATCH | Addr=0x%0h | Expected=0x%0h | Actual=0x%0h",
              $time, addr, exp_mem[addr], actual);
  end
  else begin
    fail_count++;
    $display("[%0t] READ MISMATCH | Addr=0x%0h | Expected=0x%0h | Actual=0x%0h",
              $time, addr, exp_mem[addr], actual);
  end
end
endtask

task report();
begin
  $display("\n========== APB TEST SUMMARY ==========");
  $display("PASS COUNT = %0d", pass_count);
  $display("FAIL COUNT = %0d", fail_count);

  if (fail_count == 0)
    $display("FINAL RESULT: APB VERIFICATION PASSED");
  else
    $display("FINAL RESULT: APB VERIFICATION FAILED");

  $display("======================================\n");
end
endtask

endclass


`endif