//------------------------------------------------------------------
// Arquivo   : registrador_8.v
// Projeto   : Polilock
//------------------------------------------------------------------
// Descricao : Registrador de 8 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//     11/03/2024  1.1     Vitor Sasaki      transforma em 8 bits
//------------------------------------------------------------------
//
module registrador_8 (
    input        clock,
    input        clear,
    input        enable,
    input  [7:0] D,
    output [7:0] Q
);

    reg [7:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule
