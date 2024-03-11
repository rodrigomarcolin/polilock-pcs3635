/* -----------------------------------------------------------------
 *  Arquivo   : unidade_controle.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : unidade de controle do Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */

module unidade_controle (
    input clock,

    input reset,
    input iniciar,

    // sinais FD
    input igual,
    input excedeu,
    input fim_verificacao,
    input funcao_selecionada,
    // 2'b01 se verificacao, 2'b10 se configuracao
    input [1:0] funcao,

    // saidas para FD
    output reg contaC,
    output reg contaT,
    output reg zeraC,
    output reg zeraT,
    output reg escreve,

    // saidas do circuito
    output reg acertou,
    output reg errou,
    output reg db_bloqueado,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial        = 4'b0000;  // 0
    parameter preparacao     = 4'b0001;  // 1
    parameter espera_funcao  = 4'b0010;  // 2
    parameter escolhe_funcao = 4'b0011;  // 3
    parameter comparacao     = 4'b0100;  // 4
    parameter proximo_char   = 4'b0101;  // 5
    parameter espera_mem1    = 4'b0110;  // 6
    parameter conta_tent     = 4'b0111;  // 7
    parameter ganhou         = 4'b1000;  // 8
    parameter perdeu         = 4'b1001;  // 9
    parameter bloqueado      = 4'b1010;  // A
    parameter grava          = 4'b1011;  // B
    parameter proximo_end    = 4'b1100;  // C
    parameter espera_mem2    = 4'b1101;  // D

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial: Eprox = iniciar ? preparacao : inicial;
            preparacao: Eprox = espera_funcao;
            espera_funcao: Eprox = funcao_selecionada ? escolhe_funcao : espera_funcao;
            escolhe_funcao: begin
                if (funcao == 2'b01) Eprox = comparacao;
                else if (funcao == 2'b10) Eprox = grava;
                else Eprox = espera_funcao;
            end
            comparacao: begin
                if (igual == 0) Eprox = conta_tent;
                else if (fim_verificacao) Eprox = ganhou;
                else Eprox = proximo_char;
            end
            proximo_char: Eprox = espera_mem1;
            espera_mem1: Eprox = comparacao;
            conta_tent: Eprox = perdeu;
            ganhou: Eprox = iniciar ? preparacao : ganhou;
            perdeu: begin
                if (iniciar == 0) Eprox = perdeu;
                else if (excedeu) Eprox = bloqueado;
                else Eprox = preparacao;
            end
            bloqueado: Eprox = bloqueado;
            grava: Eprox = fim_verificacao ? preparacao: proximo_end;
            proximo_end: Eprox = espera_mem2;
            espera_mem2: Eprox = grava;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        contaC = (Eatual == proximo_char || Eatual == proximo_end) ? 1'b1 : 1'b0;
        zeraT = (Eatual == inicial || Eatual == ganhou) ? 1'b1: 1'b0;
        contaT = (Eatual == conta_tent) ? 1'b1 : 1'b0;
        escreve = (Eatual == grava) ? 1'b1 : 1'b0;
        acertou = (Eatual == ganhou) ? 1'b1 : 1'b0;
        errou = (Eatual == perdeu) ? 1'b1 : 1'b0;
        db_bloqueado = (Eatual == bloqueado) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:       db_estado = 4'b0000;  // 0
            preparacao:    db_estado = 4'b0001;  // 1
            espera_funcao :db_estado = 4'b0010;  // 2
            escolhe_funcao:db_estado = 4'b0011;  // 3
            comparacao:    db_estado = 4'b0100;  // 4
            proximo_char:  db_estado = 4'b0101;  // 5
            espera_mem1:   db_estado = 4'b0110;  // 6
            conta_tent:    db_estado = 4'b0111;  // 7
            ganhou:        db_estado = 4'b1000;  // 8
            perdeu:        db_estado = 4'b1001;  // 9
            bloqueado:     db_estado = 4'b1010;  // A
            grava:         db_estado = 4'b1011;  // B
            proximo_end:   db_estado = 4'b1100;  // C
            espera_mem2:   db_estado = 4'b1101;  // D
            default:       db_estado = 4'b1111;  // F
        endcase
    end

endmodule