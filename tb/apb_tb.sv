`ifndef _apb_tb
`define _apb_tb_

`include "apb_env.sv"
`include "apb_con.sv"


module apb_tb(apb_if.tb intf);

class test_case;
apb_con cfg;

task tb_run();
cfg=new();
cfg.num_txn=20;
endtask

endclass

test_case test;
apb_env env;

initial
 begin

test=new();
test.tb_run();
env=new(test.cfg,intf);
env.env_run();

end

endmodule

`endif