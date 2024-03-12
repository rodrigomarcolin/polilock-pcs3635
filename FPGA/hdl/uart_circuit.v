
module uart_circuit #(
    // Comprimento de uma palavra a ser enviada para a UART
    // Baud Rate
    parameter BAUD_RATE = 9600,
    // Frequencia do sinal de clock utilizado no sistema
    parameter CLOCK_HZ = 50_000_000,
    // Quantidade de bits = 1 ao final da palavra
    parameter STOP_BITS = 1,
    // numero de data bits por transmissao
    parameter N_BITS = 8
)
(
    input clock,
    input rxd,
    input reset,

    output [6:0] received_high, received_low
);

    wire [7:0] serial_data;
    reg [7:0] received_data;
    wire finished;

    uart_rx # (
        .BAUD_RATE ( BAUD_RATE ),
        .CLOCK_HZ  ( CLOCK_HZ ),
        .STOP_BITS ( STOP_BITS ),
        .N_BITS    ( N_BITS )
    ) uart (
        .clk      (clock),
        .enable   (1'b1),
        .rxd      (rxd),
        .reset    (~reset),
        .data     (serial_data),
        .finished (finished)
    );

    always @(posedge clock) begin
        if (finished) received_data <= serial_data;
        else if (~reset) received_data <= 0;
    end

    hexa7seg hex1 (
        .hexa( received_data[7:4] ),
        .display ( received_high )
    );

    hexa7seg hex0 (
        .hexa( received_data[3:0] ),
        .display ( received_low )
    );


endmodule