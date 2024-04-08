onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /circuito_completo_tb2/acertou_out
add wave -noupdate /circuito_completo_tb2/caso
add wave -noupdate /circuito_completo_tb2/clock_in
add wave -noupdate /circuito_completo_tb2/db_bloqueado_out
add wave -noupdate /circuito_completo_tb2/errou_out
add wave -noupdate /circuito_completo_tb2/iniciar_in
add wave -noupdate /circuito_completo_tb2/reset_in
add wave -noupdate /circuito_completo_tb2/rxd_in
add wave -noupdate /circuito_completo_tb2/dut/s_serial_data
add wave -noupdate /circuito_completo_tb2/dut/s_serial_finished
add wave -noupdate /circuito_completo_tb2/dut/fd/s_memoria_principal
add wave -noupdate /circuito_completo_tb2/dut/fd/s_memoria_serial
add wave -noupdate /circuito_completo_tb2/dut/fd/igual
add wave -noupdate -radix hexadecimal /circuito_completo_tb2/dut/uc/Eatual
add wave -noupdate /circuito_completo_tb2/dut/s_gravacao
add wave -noupdate /circuito_completo_tb2/dut/s_opcode
add wave -noupdate -expand /circuito_completo_tb2/dut/fd/serial_ram/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {11355937 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 100
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
configure wave -timelineunits ms
update
WaveRestoreZoom {11355908 ns} {11355972 ns}
