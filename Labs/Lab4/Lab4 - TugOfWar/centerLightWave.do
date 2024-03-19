onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /centerLightTestbench/Clock
add wave -noupdate /centerLightTestbench/Reset
add wave -noupdate /centerLightTestbench/lightOn
add wave -noupdate /centerLightTestbench/L
add wave -noupdate /centerLightTestbench/R
add wave -noupdate /centerLightTestbench/NL
add wave -noupdate /centerLightTestbench/NR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {656 ps} 0}
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
WaveRestoreZoom {0 ps} {2016 ps}
