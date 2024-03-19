onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /normalLightTestbench/Clock
add wave -noupdate /normalLightTestbench/Reset
add wave -noupdate /normalLightTestbench/lightOn
add wave -noupdate /normalLightTestbench/L
add wave -noupdate /normalLightTestbench/R
add wave -noupdate /normalLightTestbench/NL
add wave -noupdate /normalLightTestbench/NR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3667 ps} 0}
quietly wave cursor active 1
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
