/* -----------------------------------------------------------------
 *  Arquivo   : circuito_completo.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : fluxo de dados do Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */

module circuito_completo (
    input clock,
    input reset,
    input iniciar,

    input [1:0] funcao,

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
    wire s_contaC;
    wire s_contaT;
    wire s_zeraC;
    wire s_zeraT;
    wire s_escreve;
    wire [3:0] s_db_estado;
    wire [7:0] s_db_memoria;
    wire [3:0] s_db_contagem;


    unidade_controle uc (
        .clock ( clock ),
        .reset  ( reset ),
        .iniciar( iniciar),
        .igual ( s_igual ),
        .excedeu ( s_excedeu ),
        .fim_verificacao (s_fim_verificacao),
        .funcao ( funcao ),
        .contaC ( s_contaC ),
        .contaT ( s_contaT ),
        .zeraC  ( s_zeraC ),
        .zeraT  ( s_zeraT ),
        .escreve ( s_escreve ),
        .acertou ( acertou ),
        .errou   ( errou ),
        .db_bloqueado ( db_bloqueado ),
        .db_estado ( s_db_estado )
    );

    fluxo_dados fd (
        .clock ( clock ),
        .contaC ( s_contaC ),
        .contaT ( s_contaT ),
        .zeraC  ( s_zeraC ),
        .zeraT  ( s_zeraT ),
        .escreve ( s_escreve ),
        .max_tentativas ( 3 ),
        .igual ( s_igual ),
        .excedeu ( s_excedeu ),
        .fim_verificacao ( s_fim_verificacao ),
        .db_memoria ( s_db_memoria ),
        .db_contagem ( s_db_contagem )
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
        .hexa ( s_db_estado ),
        .display ( db_estado )
    );

    hexa7seg hexcontagem (
        .hexa ( s_db_contagem ),
        .display ( db_contagem )
    );

endmodule