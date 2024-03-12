/* -----------------------------------------------------------------
 *  Arquivo   : circuito_completo_tb2.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : Testbench 2 circuito completo Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     11/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */

`timescale 1ns/1ns

module circuito_completo_tb2;

    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg        rxd_in     = 1;

    wire acertou_out;
    wire errou_out;
    wire db_bloqueado_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_mem1_out;
    wire [6:0] db_mem2_out;
    wire [6:0] db_contagem_out;

    localparam BAUD_RATE = 9600;
    localparam CLOCK_HZ = 50_000_000;
    localparam STOP_BITS = 1;
    localparam N_BITS = 8;

    localparam clockPeriod = 20; // in ns f = 50MHz
    // Bits enviados por nano segundo
    localparam BITS_PNS = 1_000_000_000 * 1/BAUD_RATE;
    // Periodo do sinal de clock em nano segundos
    localparam CLK_PNS = 1_000_000_000 * 1/CLOCK_HZ;
    // Numeros de ciclos de clock por bit de dados
    localparam CLK_P_BIT = BITS_PNS / CLK_PNS;

    integer caso = 0;

    always #( (clockPeriod / 2)) clock_in = ~clock_in;

    circuito_completo #(
        .BAUD_RATE ( BAUD_RATE ),
        .CLOCK_HZ  ( CLOCK_HZ ),
        .STOP_BITS ( STOP_BITS ),
        .N_BITS    ( N_BITS )
    )
    dut (
        .clock   ( clock_in ),
        .reset   ( reset_in ),
        .iniciar ( iniciar_in ),
        .rx      ( rxd_in ),

        .acertou ( acertou_out ),
        .errou   ( errou_out ),
        .db_bloqueado ( db_bloqueado_out ),
        .db_estado ( db_estado_out ),
        .db_mem1 ( db_mem1_out ),
        .db_mem2 ( db_mem2_out ),
        .db_contagem ( db_contagem_out )
    );

    // Verifica senha incorreta 3 vezes seguidas
    integer i = 0;
    task send_char(input [7:0] char);
        begin
            i = 0;
            // manda start bit
            @(negedge clock_in);
            rxd_in = 0;
            // espera uart receber start bit
            #(CLK_P_BIT * clockPeriod);
            for (; i < 8; i = i + 1) begin
                @(negedge clock_in);
                // envia bit
                rxd_in = char[i];
                // espera uart receber 
                #(CLK_P_BIT * clockPeriod);
            end
            // manda stop bit
            @(negedge clock_in);
            rxd_in = 1;
            #(CLK_P_BIT * clockPeriod);
        end
    endtask

    initial begin
        $display("Inicio da simulacao");
        
        caso = 0;
        clock_in = 1;
        reset_in = 0;
        iniciar_in = 0;
        
        caso = 1;
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        #( 5 * clockPeriod);

        caso = 2;
        @(negedge clock_in);
        iniciar_in = 1;
        #(clockPeriod);
        iniciar_in = 0;
        #( 5 * clockPeriod);

        caso = 3;
        send_char("v");
        #(10* clockPeriod);
        send_char("V");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("R");
        #(10* clockPeriod);
        send_char("I");
        #(10* clockPeriod);
        send_char("L");
        #(10* clockPeriod);
        send_char("O");
        #(10* clockPeriod);
        send_char("G");
        #(10* clockPeriod);
        send_char("U");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("A");
        #(10* clockPeriod);

        #(50* clockPeriod);
        
        caso = 4;
        @(negedge clock_in);
        iniciar_in = 1;
        #(clockPeriod);
        iniciar_in = 0;
        #( 5 * clockPeriod);

        caso = 5;
        send_char("v");
        #(10* clockPeriod);
        send_char("V");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("R");
        #(10* clockPeriod);
        send_char("I");
        #(10* clockPeriod);
        send_char("L");
        #(10* clockPeriod);
        send_char("O");
        #(10* clockPeriod);
        send_char("G");
        #(10* clockPeriod);
        send_char("U");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("A");
        #(10* clockPeriod);

        #(50* clockPeriod);

        caso = 6;
        @(negedge clock_in);
        iniciar_in = 1;
        #(clockPeriod);
        iniciar_in = 0;
        #( 5 * clockPeriod);

        caso = 7;
        send_char("v");
        #(10* clockPeriod);
        send_char("V");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("R");
        #(10* clockPeriod);
        send_char("I");
        #(10* clockPeriod);
        send_char("L");
        #(10* clockPeriod);
        send_char("O");
        #(10* clockPeriod);
        send_char("G");
        #(10* clockPeriod);
        send_char("U");
        #(10* clockPeriod);
        send_char("E");
        #(10* clockPeriod);
        send_char("A");
        #(10* clockPeriod);

        #(50* clockPeriod);

        caso = 6;
        @(negedge clock_in);
        iniciar_in = 1;
        #(clockPeriod);
        iniciar_in = 0;
        #( 5 * clockPeriod);

        $display("fim da simulacao");
        $stop;
    end
endmodule