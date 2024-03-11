onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /circuito_completo_tb1/acertou_out
add wave -noupdate /circuito_completo_tb1/caso
add wave -noupdate /circuito_completo_tb1/db_bloqueado_out
add wave -noupdate /circuito_completo_tb1/errou_out
add wave -noupdate /circuito_completo_tb1/funcao_in
add wave -noupdate /circuito_completo_tb1/iniciar_in
add wave -noupdate /circuito_completo_tb1/reset_in
add wave -noupdate /circuito_completo_tb1/dut/fd/escreve
add wave -noupdate /circuito_completo_tb1/dut/fd/db_contagem
add wave -noupdate /circuito_completo_tb1/dut/fd/fim_verificacao
add wave -noupdate /circuito_completo_tb1/dut/fd/igual
add wave -noupdate /circuito_completo_tb1/dut/fd/s_endereco
add wave -noupdate /circuito_completo_tb1/dut/fd/s_memoria_principal
add wave -noupdate /circuito_completo_tb1/dut/fd/s_memoria_serial
add wave -noupdate /circuito_completo_tb1/dut/fd/s_tentativas
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1317 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 283
configure wave -valuecolwidth 171
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
WaveRestoreZoom {0 ns} {835 ns}
