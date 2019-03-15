onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label {Input 1} /tb_top/riscV/dp/alu_module/SrcA
add wave -noupdate -label {Input 2} /tb_top/riscV/dp/alu_module/SrcB
add wave -noupdate -label Operation /tb_top/riscV/dp/alu_module/Operation
add wave -noupdate -label Result -radix decimal /tb_top/riscV/dp/alu_module/ALUResult
add wave -noupdate -label Result -radix hexadecimal /tb_top/riscV/dp/alu_module/ALUResult
add wave -noupdate -label Instruction /tb_top/riscV/dp/instr_mem/rd
add wave -noupdate -label Clock -radix decimal /tb_top/riscV/dp/rf/clk
add wave -noupdate -label PC -radix decimal -radixshowbase 0 /tb_top/riscV/dp/pcadd/a
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {579465 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 302
configure wave -valuecolwidth 115
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {322580 ps} {415326 ps}
