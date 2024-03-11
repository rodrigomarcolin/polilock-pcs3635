/* -----------------------------------------------------------------
 *  Arquivo   : fluxo_dados.v
 *  Projeto   : Polilock
 * -----------------------------------------------------------------
 * Descricao : fluxo de dados do Polilock
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     10/03/2024  1.0     Vitor Sasaki      criacao
 * -----------------------------------------------------------------
 */


module fluxo_dados (
    input clock,
    
    input contaC,
    input contaT,
    input zeraC,
    input zeraT,
    input escreve,
    input [3:0] max_tentativas,

    output igual,
    output excedeu,
    output fim_verificacao,

    output [7:0] db_memoria,
    output [3:0] db_contagem
);

    wire [3:0] s_endereco;
    wire [7:0] s_memoria_serial;
    wire [7:0] s_memoria_principal;
    wire [3:0] s_tentativas;

    assign db_contagem = s_endereco;

    sync_rom_16x8 rom (
        .clock    ( clock ),
        .address  ( s_endereco ),
        .data_out ( s_memoria_serial )
    );

	contador_163 contador_sequencia (
		.clock( clock ),
		.clr  ( ~zeraC ),
		.ld   ( 1'b1 ),
		.ent  ( 1'b1 ),
		.enp  ( contaC ),
		.D    ( 4'b0 ),
		.Q    ( s_endereco )
	);

    sync_ram_16x8_file memoria (
        .clk  ( clock ),
        .we   ( escreve ),
        .data ( s_memoria_serial ),
        .addr ( s_endereco ),
        .q    ( s_memoria_principal )
    );

    // comparador fim da verificacao
	comparador_85 comparador_fim_verificacao (
		.A   ( s_endereco ), // endereco atual
		.B   ( 4'b1001 ), // 1001
		.ALBi( 1'b0 ),
		.AGBi( 1'b0 ),
		.AEBi( 1'b1 ),
		.AEBo( fim_verificacao )
	);

    // comparador caracteres
	comparador_8b comparador_verificacao (
		.A   ( s_memoria_principal ), // memoria
		.B   ( s_memoria_serial ), // memoria serial
		.AEB ( igual )
	);

	contador_163 contador_tentativas (
		.clock( clock ),
		.clr  ( ~zeraT ),
		.ld   ( 1'b1 ),
		.ent  ( 1'b1 ),
		.enp  ( contaT ),
		.D    ( 4'b0 ),
		.Q    ( s_tentativas )
	);

    // comparador fim da verificacao
	comparador_85 comparador_tentativas (
		.A   ( s_tentativas ), // tentativas
		.B   ( max_tentativas ), // valor max
		.ALBi( 1'b0 ),
		.AGBi( 1'b0 ),
		.AEBi( 1'b1 ),
		.AEBo( excedeu )
	);

endmodule