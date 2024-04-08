/* -----------------------------------------------------------------
 *  Arquivo   : circuito_completo.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : fluxo de dados do Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2024  1.0     Vitor Sasaki      criacao
 *     11/03/2024  1.1     Vitor Sasaki      adiciona UART
 * -----------------------------------------------------------------
 */

module circuito_completo #(
    // Comprimento de uma palavra a ser enviada para a UART
    // Baud Rate
    parameter BAUD_RATE = 9600,
    // Frequencia do sinal de clock utilizado no sistema
    parameter CLOCK_HZ = 50_000_000,
    // Quantidade de bits = 1 ao final da palavra
    parameter STOP_BITS = 1,
    // numero de data bits por transmissao
    parameter N_BITS = 8
) (
    input clock,
    input reset,
    input iniciar,
    input rx,

    output acertou,
    output errou,
    output db_bloqueado,
    output [6:0] db_estado,
    output [6:0] db_mem1,
    output [6:0] db_mem2,
    output [6:0] db_contagem
);

    wire s_igual;
    wire s_excedeu;
    wire s_fim_verificacao;
    wire s_funcao_selecionada;
    wire s_contaC;
    wire s_contaT;
    wire s_contaTo;
    wire s_contaS;
    wire s_zeraC;
    wire s_zeraT;
    wire s_zeraTo;
    wire s_zeraS;
    wire s_registraO;
    wire s_zeraO;
    wire s_gravacao;
    wire s_escreve;
    wire s_escreve_serial;
    wire s_serial_finished;
    wire s_fim_gravacao;
    wire s_fim_time;
    wire [7:0] s_opcode;
    wire [7:0] s_serial_data;
    wire [4:0] s_db_estado;
    wire [7:0] s_db_memoria;
    wire [3:0] s_db_contagem;


    unidade_controle uc (
        .clock ( clock ),
        .reset  ( reset ),
        .iniciar( iniciar),
        .serial_finished ( s_serial_finished ),
        .igual ( s_igual ),
        .excedeu ( s_excedeu ),
        .fim_verificacao ( s_fim_verificacao ),
        .fim_gravacao ( s_fim_gravacao ),
        .fim_time     ( s_fim_time ),
        .contaC ( s_contaC ),
        .contaT ( s_contaT ),
        .contaTo ( s_contaTo ),
        .contaS ( s_contaS ),
        .zeraC  ( s_zeraC ),
        .zeraT  ( s_zeraT ),
        .zeraTo ( s_zeraTo ),
        .zeraS ( s_zeraS ),
        .registraO ( s_registraO ),
        .zeraO ( s_zeraO ),
        .escreve ( s_escreve ),
        .escreve_serial ( s_escreve_serial ),
        .gravacao ( s_gravacao ),
        .acertou ( acertou ),
        .errou   ( errou ),
        .opcode  ( s_opcode ),
        .db_bloqueado ( db_bloqueado ),
        .db_estado ( s_db_estado )
    );

    fluxo_dados fd (
        .clock ( clock ),
        .contaC ( s_contaC ),
        .contaT ( s_contaT ),
        .contaTo ( s_contaTo ),
        .contaS ( s_contaS ),
        .zeraC  ( s_zeraC ),
        .zeraT  ( s_zeraT ),
        .zeraTo ( s_zeraTo ),
        .zeraS ( s_zeraS ),
        .registraO ( s_registraO ),
        .zeraO ( s_zeraO ),
        .escreve ( s_escreve ),
        .escreve_serial ( s_escreve_serial ),
        .gravacao ( s_gravacao ),
        .max_tentativas ( 3 ),
        .igual ( s_igual ),
        .excedeu ( s_excedeu ),
        .fim_verificacao ( s_fim_verificacao ),
        .fim_gravacao ( s_fim_gravacao ),
        .fim_time     ( s_fim_time ),
        .serial_data  ( s_serial_data ),
        .opcode  ( s_opcode ),
        .db_memoria ( s_db_memoria ),
        .db_contagem ( s_db_contagem )
    );

    // UART
    uart_rx # (
        .BAUD_RATE ( BAUD_RATE ),
        .CLOCK_HZ  ( CLOCK_HZ ),
        .STOP_BITS ( STOP_BITS ),
        .N_BITS    ( N_BITS )
    ) receiver (
        .clk      ( clock ),
        .enable   ( 1'b1 ),
        .rxd      ( rx ),
        .reset    ( reset ),
        .data     ( s_serial_data ),
        .finished ( s_serial_finished )
    );

    hexa7seg hexmem1 (
        .hexa ( s_db_memoria[7:4]),
        .display ( db_mem1 )
    );

    hexa7seg hexmem2 (
        .hexa ( s_db_memoria[3:0]),
        .display ( db_mem2 )
    );

    hexa7seg hexestado (
        .hexa ( s_db_estado[3:0] ),
        .display ( db_estado )
    );

    hexa7seg hexcontagem (
        .hexa ( s_db_contagem ),
        .display ( db_contagem )
    );

endmodule