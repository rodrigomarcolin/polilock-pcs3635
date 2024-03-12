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

    input serial_finished,
    // sinais FD
    input igual,
    input excedeu,
    input fim_verificacao,
    input fim_gravacao,
    input fim_time,
    input [7:0] opcode, // "v" para verificacao, "m" para modificacao

    // saidas para FD
    output reg contaC,
    output reg contaT,
    output reg contaTo,
    output reg contaS,
    
    output reg zeraC,
    output reg zeraT,
    output reg zeraTo,
    output reg zeraS,

    output reg zeraO,
    output reg registraO,

    output reg escreve,
    output reg escreve_serial,
    output reg gravacao,

    // saidas do circuito
    output reg acertou,
    output reg errou,
    output reg db_bloqueado,
    output reg [4:0] db_estado
);

    // Define estados
    parameter inicial          = 5'b00000;  // 0
    parameter preparacao       = 5'b00001;  // 1
    parameter espera_funcao    = 5'b00010;  // 2
    parameter seleciona_funcao = 5'b00011;  // 3
    parameter comparacao       = 5'b00100;  // 4
    parameter proximo_char     = 5'b00101;  // 5
    parameter espera_mem1      = 5'b00110;  // 6
    parameter conta_tent       = 5'b00111;  // 7
    parameter ganhou           = 5'b01000;  // 8
    parameter perdeu           = 5'b01001;  // 9
    parameter bloqueado        = 5'b01010;  // A
    parameter grava            = 5'b01011;  // B
    parameter proximo_end      = 5'b01100;  // C
    parameter espera_mem2      = 5'b01101;  // D
    parameter espera_serial    = 5'b01110;  // E
    parameter grava_serial     = 5'b01111;  // F
    parameter espera_serial_m  = 5'b10000;  // 10
    parameter grava_serial_m   = 5'b10001;  // 11
    parameter espera_serial_v  = 5'b10010;  // 12
    parameter grava_serial_v   = 5'b10011;  // 13

    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

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
            preparacao: Eprox = espera_serial;
            espera_serial: Eprox = serial_finished ? grava_serial : espera_serial;
            grava_serial: Eprox = seleciona_funcao;
            seleciona_funcao: begin
                if (opcode == "v") Eprox = espera_serial_v;
                else if (opcode == "m") Eprox = espera_serial_m;
                else Eprox = espera_serial;
            end
            espera_serial_v: begin
                if (serial_finished) Eprox = grava_serial_v;
                else if (fim_time) Eprox = preparacao;
                else Eprox = espera_serial_v;
            end
            grava_serial_v: Eprox = fim_gravacao ? espera_mem1 : espera_serial_v;
            espera_serial_m: begin
                if (serial_finished) Eprox = grava_serial_m;
                else if (fim_time) Eprox = preparacao;
                else Eprox = espera_serial_m;
            end
            grava_serial_m: Eprox = fim_gravacao ? espera_mem2 : espera_serial_m;
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
        zeraT = (Eatual == inicial || Eatual == ganhou) ? 1'b1: 1'b0;
        zeraS = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraTo = (Eatual == inicial || Eatual == preparacao || Eatual == grava_serial_m || Eatual == grava_serial_v) ? 1'b1 : 1'b0;

        contaC = (Eatual == proximo_char || Eatual == proximo_end) ? 1'b1 : 1'b0;
        contaT = (Eatual == conta_tent) ? 1'b1 : 1'b0;
        contaS = (Eatual == grava_serial_v || Eatual == grava_serial_m) ? 1'b1 : 1'b0;
        contaTo = (Eatual == espera_serial_v || Eatual == espera_serial_m) ? 1'b1 : 1'b0;

        escreve = (Eatual == grava) ? 1'b1 : 1'b0;
        escreve_serial = (Eatual == grava_serial_v || Eatual == grava_serial_m) ? 1'b1 : 1'b0;
        gravacao = (Eatual == grava_serial_v || Eatual == grava_serial_m) ? 1'b1 : 1'b0;

        registraO = (Eatual == grava_serial) ? 1'b1 : 1'b0;
        zeraO = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;

        acertou = (Eatual == ganhou) ? 1'b1 : 1'b0;
        errou = (Eatual == perdeu) ? 1'b1 : 1'b0;
        db_bloqueado = (Eatual == bloqueado) ? 1'b1 : 1'b0;

        db_estado = Eatual;
    end

endmodule