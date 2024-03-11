//------------------------------------------------------------------
// Arquivo   : sync_ram_16x8_file.v
// Projeto   : Polylock
 
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x8
//
//   - conteudo inicial armazenado em arquivo .txt
//   - descricao baseada em template 'single_port_ram_with_init.v' 
//     do Intel Quartus Prime
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     02/02/2024  1.0     Edson Midorikawa  versao inicial
//     10/03/2024  1.1     Vitor Sasaki      modifica para 16x8
//------------------------------------------------------------------
//

module sync_ram_16x8_file #(
    parameter BINFILE = "ram_init.txt"
)
(
    input        clk,
    input        we,
    input  [7:0] data,
    input  [3:0] addr,
    output [7:0] q
);

    // Variavel RAM (armazena dados)
    reg [7:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        // leitura do conteudo a partir de um arquivo
        $readmemb(BINFILE, ram);
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule
