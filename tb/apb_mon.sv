`ifndef _apb_mon_
`define _apb_mon_

`include "apb_base.sv"

class apb_mon;
  apb_base pkt;
  mailbox mon2sb;
  virtual apb_if intf;

  function new(apb_base pkt, mailbox mon2sb, virtual apb_if intf);
    this.pkt=pkt;
    this.mon2sb=mon2sb;
    this.intf=intf;
  endfunction

  task mon_run();
   begin
    forever begin
     @(posedge intf.pclk); 
	if (intf.psel && intf.penable && intf.pready && intf.pwrite == 0) begin
          pkt = new();

          pkt.paddr   = intf.paddr;
          pkt.pwdata  = intf.pwdata;
          pkt.pwrite  = intf.pwrite;
          pkt.psel    = intf.psel;
          pkt.penable = intf.penable;
          pkt.prdata  = intf.prdata;
          pkt.pready  = intf.pready;
          pkt.pslverr = intf.pslverr;

          mon2sb.put(pkt);

         // $display("[%0t] MONITOR CAPTURED | Addr=0x%0h | Write=%0b | Wdata=0x%0h | Rdata=0x%0h | PSLVERR=%0b",
          //          $time, pkt.paddr, pkt.pwrite, pkt.pwdata, pkt.prdata, pkt.pslverr);
        end
      end
    end
  endtask

endclass

`endif