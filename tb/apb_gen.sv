`ifndef _apb_gen_
`define _apb_gen_

`include "apb_base.sv"

class apb_gen;
apb_base pkt;
mailbox gen2drv;

function new(apb_base pkt, mailbox gen2drv);
this.pkt=pkt;
this.gen2drv=gen2drv;
endfunction

task gen_run();
begin
#15
pkt = new();

pkt.paddr  = $urandom_range(0, 15);
pkt.pwdata = $urandom_range(0, 255);
pkt.pwrite = 1;
pkt.psel   = 1;
pkt.penable = 1;

gen2drv.put(pkt);
//$display("%t pkt.gen1=%p",$time, pkt);
#15

pkt.pwrite=0;
gen2drv.put(pkt);
//$display("%t pkt.gen2=%p",$time, pkt);


//#50
//pkt.pwrite=0;*/
//gen2drv.put(pkt);

end

endtask
endclass


`endif