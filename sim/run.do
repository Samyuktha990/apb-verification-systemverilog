vdel -all
vlib work

vlog ../rtl/apb_slave.sv
vlog ../tb/apb_if.sv
vlog ../tb/apb_dut.sv
vlog ../tb/apb_base.sv
vlog ../tb/apb_con.sv
vlog ../tb/apb_gen.sv
vlog ../tb/apb_drv.sv
vlog ../tb/apb_mon.sv
vlog ../tb/apb_sb.sv
vlog ../tb/apb_env.sv
vlog ../tb/apb_tb.sv
vlog ../tb/apb_top.sv

vsim work.apb_top

add wave sim:/apb_top/intf/*

run -all