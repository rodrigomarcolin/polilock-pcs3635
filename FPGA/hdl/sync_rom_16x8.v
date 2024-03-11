//------------------------------------------------------------------
// Arquivo   : sync_rom_16x8.v
// Projeto   : Polilock
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x8
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//     10/03/2024  2.0     Vitor Sasaki      modifica para 16x8
//------------------------------------------------------------------
//
module sync_rom_16x8 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [7:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = "V";
            4'b0001: data_out = "E";
            4'b0010: data_out = "R";
            4'b0011: data_out = "I";
            4'b0100: data_out = "L";
            4'b0101: data_out = "O";
            4'b0110: data_out = "G";
            4'b0111: data_out = "U";
            4'b1000: data_out = "E";
            4'b1001: data_out = "A";
            4'b1010: data_out = "0";
            4'b1011: data_out = "0";
            4'b1100: data_out = "0";
            4'b1101: data_out = "0";
            4'b1110: data_out = "0";
            4'b1111: data_out = "0";
        endcase
    end
endmodule

