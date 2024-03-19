onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SocTestbench/CLOCK_50
add wave -noupdate /DE1_SocTestbench/SW
add wave -noupdate {/DE1_SocTestbench/SW[9]}
add wave -noupdate {/DE1_SocTestbench/KEY[0]}
add wave -noupdate /DE1_SocTestbench/LEDR
add wave -noupdate /DE1_SocTestbench/HEX0
add wave -noupdate /DE1_SocTestbench/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1367 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3141 ps}
