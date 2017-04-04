vlib work

;#vcom sign_mux.vhd
;#vcom ALU_control.vhd
;#vcom FETCH.vhd
;#vcom mux_2.vhd
;#vcom memoryINS.vhd
;#vcom addr_mux.vhd
;#vcom comparator_32.vhd
;#vcom program_counter.vhd
vcom MEM_WB.vhd
;#vcom mem_control.vhd
;#vcom Split_32.vhd
;#vcom ID_EX.vhd
;#vcom ALU.vhd
;#vcom memoryData.vhd
vcom EX_MEM.vhd
;#vcom IF_ID.vhd
;#vcom EX.vhd
;#vcom ID.vhd
vcom pipelined_processor_tb.vhd
;#vcom if_load.vhd
;#vcom branch_control.vhd
;#vcom MEM.vhd
;#vcom Sign_extend.vhd
;#vcom registers.vhd
;#vcom adder.vhd
;#vcom wb_control.vhd
vcom pipelined_processor.vhd

vsim pipelined_processor_tb

force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

run 100ns
