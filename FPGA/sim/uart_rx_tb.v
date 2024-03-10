`timescale 1ns/1ns

module uart_rx_tb;

    // sinais de entrada para o circuito em teste
    reg clk_in;
    reg rxd_in;
    reg reset_in;
    wire [7:0] data_out;
    wire finished_out;

    // unidade em teste
    uart_rx dut (
        .clk      (clk_in),
        .enable   (1'b1),
        .rxd      (rxd_in),
        .reset    (reset_in),
        .data     (data_out),
        .finished (finished_out)
    );

    localparam CLOCK_PERIOD = 20; // f = 50MHz

    // Gerador de clock
    always #(CLOCK_PERIOD/2) clk_in = ~clk_in;

    initial begin
        $display("inicio da simulacao");

        // Condicoes iniciais
        clk_in   = 0;
        rxd_in   = 1;
        reset_in = 0;
        @(negedge clk_in); // espera borda de descida

        // gera sinal de reset
        reset_in = 1;
        #(CLOCK_PERIOD)
        reset_in = 0;

        #(CLOCK_PERIOD)
        $display("fim da simulacao");
        $stop;
    end
endmodule