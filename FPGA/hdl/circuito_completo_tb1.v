/* -----------------------------------------------------------------
 *  Arquivo   : circuito_completo_tb1.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : Testbench 1 circuito completo Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     11/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */

`timescale 1ns/1ns

module circuito_completo_tb1;

    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [1:0] funcao_in  = 2'b00;

    wire acertou_out;
    wire errou_out;
    wire db_bloqueado_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_mem1_out;
    wire [6:0] db_mem2_out;
    wire [6:0] db_contagem_out;

    parameter clockPeriod = 20; // in ns f = 50MHz

    integer caso = 0;

    always #( (clockPeriod / 2)) clock_in = ~clock_in;

    circuito_completo dut (
        .clock   ( clock_in ),
        .reset   ( reset_in ),
        .iniciar ( iniciar_in ),
        .funcao  ( funcao_in ),

        .acertou ( acertou_out ),
        .errou   ( errou_out ),
        .db_bloqueado ( db_bloqueado_out ),
        .db_estado ( db_estado_out ),
        .db_mem1 ( db_mem1_out ),
        .db_mem2 ( db_mem2_out ),
        .db_contagem ( db_contagem_out )
    );
    // Com Veriloguer carregado na memoria principal e VerilogueA carregado na memoria serial
    // inicialmente e realizada a verificacao, que deve falhar, em seguida, e ativada a funcao
    // configuracao, que grava a senha da memoria serial na memoria principal, por fim e executado
    // novamente a verificacao, desta vez dando corretamente.

    initial begin
        $display("Inicio da simulacao");
        
        caso = 0;
        clock_in = 1;
        reset_in = 0;
        iniciar_in = 0;
        funcao_in = 2'b00;
        #clockPeriod;

        caso = 1;
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        #(10 * clockPeriod);

        caso = 2;
        @(negedge clock_in);
        iniciar_in = 1;
        #(5 * clockPeriod);
        iniciar_in = 0;
        #(10 * clockPeriod);

        caso = 3;
        @(negedge clock_in);
        funcao_in = 2'b01;
        #(5 * clockPeriod );
        funcao_in = 2'b00;

        #( 50 * clockPeriod);

        caso = 4;
        @(negedge clock_in);
        iniciar_in = 1;
        #(5 * clockPeriod);
        iniciar_in = 0;
        #(10 * clockPeriod);

        caso = 5;
        @(negedge clock_in);
        funcao_in = 2'b10;
        #(5 * clockPeriod );
        funcao_in = 2'b00;

        #( 50 * clockPeriod);

        caso = 6;
        @(negedge clock_in);
        funcao_in = 2'b01;
        #(5 * clockPeriod );
        funcao_in = 2'b00;

        #( 50 * clockPeriod);

        $display("fim da simulacao");
        $stop;
    end
    
endmodule