onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_rx_tb/clk_in
add wave -noupdate /uart_rx_tb/rxd_in
add wave -noupdate /uart_rx_tb/reset_in
add wave -noupdate /uart_rx_tb/data_out
add wave -noupdate /uart_rx_tb/finished_out
add wave -noupdate -radix decimal /uart_rx_tb/dut/cycle_counter
add wave -noupdate /uart_rx_tb/dut/current_data
add wave -noupdate -radix decimal /uart_rx_tb/dut/data_counter
add wave -noupdate /uart_rx_tb/dut/sample
add wave -noupdate /uart_rx_tb/dut/received
add wave -noupdate /uart_rx_tb/dut/current_state
add wave -noupdate /uart_rx_tb/dut/counter_finished
add wave -noupdate /uart_rx_tb/dut/counter_half
add wave -noupdate /uart_rx_tb/dut/receive_finished
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {0 ns} {163 ns}
