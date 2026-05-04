`ifndef __apb_drv__
`define __apb_drv__


`include "apb_base.sv"

class apb_drv;
apb_base pkt;
mailbox gen2drv, drv2sb;
virtual apb_if intf;

function new(apb_base pkt, mailbox gen2drv, drv2sb, virtual apb_if intf);
this.pkt=pkt;
this.gen2drv=gen2drv;
this.drv2sb=drv2sb;
this.intf=intf;
endfunction

task driver_master();
begin
  @(posedge intf.pclk);
  intf.psel    <= 1;
  intf.penable <= 0;
  intf.paddr   <= pkt.paddr;
  intf.pwdata  <= pkt.pwdata;
  intf.pwrite  <= pkt.pwrite;

  @(posedge intf.pclk);
  intf.penable <= 1;

  wait(intf.pready == 1);

  @(posedge intf.pclk);
  intf.psel    <= 0;
  intf.penable <= 0;
end
endtask

task drv_run();
begin
  // WRITE transaction
  gen2drv.get(pkt);

  @(posedge intf.pclk);
  intf.psel    <= 1;
  intf.penable <= 0;
  intf.paddr   <= pkt.paddr;
  intf.pwdata  <= pkt.pwdata;
  intf.pwrite  <= 1;

  @(posedge intf.pclk);
  intf.penable <= 1;

  wait(intf.pready == 1);

  @(posedge intf.pclk);
  intf.psel    <= 0;
  intf.penable <= 0;

  drv2sb.put(pkt);

  // READ transaction
  gen2drv.get(pkt);

  @(posedge intf.pclk);
  intf.psel    <= 1;
  intf.penable <= 0;
  intf.paddr   <= pkt.paddr;
  intf.pwdata  <= pkt.pwdata;
  intf.pwrite  <= 0;

  @(posedge intf.pclk);
  intf.penable <= 1;

  wait(intf.pready == 1);

  @(posedge intf.pclk);
  intf.psel    <= 0;
  intf.penable <= 0;
end
endtask
endclass

`endif
