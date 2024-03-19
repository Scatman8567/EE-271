onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /victoryTestbench/clock_period
add wave -noupdate /victoryTestbench/Clock
add wave -noupdate /victoryTestbench/Reset
add wave -noupdate /victoryTestbench/LEDR9
add wave -noupdate /victoryTestbench/LEDR1
add wave -noupdate /victoryTestbench/L
add wave -noupdate /victoryTestbench/R
add wave -noupdate /victoryTestbench/restart
add wave -noupdate /victoryTestbench/HEX0
add wave -noupdate /victoryTestbench/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3400 ps} {4400 ps}
