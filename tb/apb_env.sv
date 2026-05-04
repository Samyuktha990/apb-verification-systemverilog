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
fork
mon.mon_run();
join_none

repeat(cfg.num_txn)
begin
gen.gen_run();
drv.drv_run();
sb.sb_run1();
sb.sb_run();
end

sb.report();
endtask
endclass

`endif