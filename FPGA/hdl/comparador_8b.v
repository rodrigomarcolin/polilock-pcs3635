/* -----------------------------------------------------------------
 *  Arquivo   : comparador_8b.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : comparador magnitude de 8 bits
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */

module comparador_8b (
    input [7:0] A,
    input [7:0] B,
    output AEB,
    output ALB,
    output AGB
);

    assign AEB = A == B;
    assign ALB = A < B;
    assign AGB = A > B;

endmodule