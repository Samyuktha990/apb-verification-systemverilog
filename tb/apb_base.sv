`ifndef _apb_base_
`define _apb_base_

class apb_base;
bit [31:0]paddr;
bit [31:0]pwdata;
bit pwrite;
bit psel;
bit penable;
bit pready;
bit pslverr;
bit [31:0]prdata;
endclass


`endif