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

    input [7:0] serial_data,
    
    input contaC,
    input contaT,
    input contaTo,
    input contaS,

    input zeraC,
    input zeraT,
    input zeraTo,
    input zeraS,

    input registraO,
    input zeraO,

    input escreve,
    input escreve_serial,
    input gravacao,

    input [3:0] max_tentativas,

    output igual,
    output excedeu,
    output fim_verificacao,
    output fim_gravacao,
    output fim_time,

    output [7:0] opcode,

    output [7:0] db_memoria,
    output [3:0] db_contagem
);

    wire [3:0] s_endereco;
    wire [3:0] s_endereco_gravacao;
    wire [7:0] s_memoria_serial;
    wire [7:0] s_memoria_principal;
    wire [3:0] s_tentativas;
    wire [3:0] s_endereco_serial = gravacao ? s_endereco_gravacao : s_endereco;

    assign db_contagem = s_endereco;
	assign db_memoria = s_memoria_principal;

    // memoria para armazenar saida serial
    sync_ram_16x8_file #(
        .BINFILE ("arquivo_inexistente.txt")
    ) serial_ram (
        .clk  ( clock ),
        .addr ( s_endereco_serial ),
        .data ( serial_data ),
        .we   ( escreve_serial ),
        .q    ( s_memoria_serial )
    );

    // registrador de operacoes
    registrador_8 opcode_reg (
        .clock ( clock ),
        .clear ( zeraO ),
        .enable( registraO ),
        .D     ( serial_data ),
        .Q     ( opcode )
    );

    // contador de timeout
    contador_m #(.M(250_000_000), .N($clog2(250_000_000))) contador_timeout (
        .clock   ( clock ),
        .conta   ( contaTo ),
        .zera_as ( zeraTo ),
        .fim     ( fim_time )
    );

    // contador de sequencia
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
		.A   ( s_endereco_gravacao ), // endereco atual
		.B   ( 4'b1001 ), // 1001
		.ALBi( 1'b0 ),
		.AGBi( 1'b0 ),
		.AEBi( 1'b1 ),
		.AEBo( fim_gravacao )
	);

    // contador gravacao serial
	contador_163 contador_gravacao (
		.clock( clock ),
		.clr  ( ~zeraS ),
		.ld   ( 1'b1 ),
		.ent  ( 1'b1 ),
		.enp  ( contaS ),
		.D    ( 4'b0 ),
		.Q    ( s_endereco_gravacao )
	);

    // comparador fim da gravacao serial
	comparador_85 comparador_fim_gravacao (
		.A   ( s_endereco ), // endereco atual
		.B   ( 4'b1010 ), // 1001
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

    // contador de tentativas
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