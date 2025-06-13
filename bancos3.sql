CREATE DATABASE bancos3;
USE bancos3;

CREATE TABLE cidade (
    codCidade INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (codCidade),
    siglaEstado VARCHAR(2) NOT NULL REFERENCES estado(siglaEstado) ON DELETE CASCADE ON UPDATE CASCADE,    
);

CREATE TABLE vendedor (
    codVendedor INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    dataNascimento DATE NOT NULL,
    endreco VARCHAR(60) NOT NULL,
    cep CHAR(8) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL DEFAULT 1,
    dataContratacao DATE DEFAULT CURRENT_DATE,
    codDepartamento INT,
    FOREIGN KEY (codDepartamento) REFERENCES departamento(codDepartamento) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE SET NULL ON UPDATE CASCADE,
);

CREATE TABLE cliente (
    codCliente NUMERIC(10, 0) NOT NULL AUTO_INCREMENT
    endereco VARCHAR(60),
    codCidade INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo CHAR(1),
    dataCadastro DATE DEFAULT CURRENT_DATE,
    cep CHAR(8) NOT NULL,
    CONSTRAINT fk_cli_cid FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (codCliente),
);

CREATE TABLE clienteFisico (
    codCliente INT NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    dataNascimento DATE NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    rg CHAR(8),
    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE clienteJuridico (
    codCliente INT PRIMARY KEY NOT NULL,
    nomeFatansia VARCHAR(80) NOT NULL,
    razaoSocial VARCHAR(80) NOT NULL,
    ie VARCHAR(20) NOT NULL,
    cgc VARCHAR(20) NOT NULL,
    endereco VARCHAR(60) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL,
    dataCadastro DATE DEFAULT CURRENT_DATE,
    codDepartamento INT,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (codDepartamento) REFERENCES departamento(codDepartamento) ON DELETE SET NULL ON UPDATE CASCADE,
);

CREATE TABLE produto (
    codProduto INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    descricao VARCHAR(40) NOT NULL,
    undadeMedida CHAR(2) NOT NULL,
    embalagem VARCHAR(15) NOT NULL DEFAULT 'FARDO',
    codClasse INT NOT NULL,
    precoVenda DECIMAL(14, 2) NOT NULL,
    estoqueMinimo NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    ON DELETE SET NULL ON UPDATE NULL,
);

CREATE TABLE produtoLote (
    codLote INT NOT NULL,
    numeroLote INT NOT NULL PRIMARY KEY,
    quantidadeAdquirida NUMERIC(14,2) NOT NULL,
    quantidadeVendida NUMERIC(14,2) NOT NULL,
    precoCusto NUMERIC(14,2) NOT NULL,
    dataValidade DATE NOT NULL,
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE venda (
    codVenda INT NOT NULL AUTO_INCREMENT,
    dataVenda DATE NOT NULL DEFAULT CURRENT_DATE,
    codVendedor INT NOT NULL,
    codCliente INT NOT NULL,
    valorTotal NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (codVenda),
    FOREIGN KEY (codVendedor) REFERENCES vendedor(codVendedor) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (codCliente) REFERENCES cliente(codCliente) ON DELETE SET NULL ON UPDATE CASCADE

);

CREATE TABLE itemVenda (
    codVenda INT NOT NULL PRIMARY KEY,
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL,
    quantidade NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (numeroLote) REFERENCES produtoLote(numeroLote) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE fornecedor (
    codFornecedor INT NOT NULL AUTO_INCREMENT,
    nomeFantasia VARCHAR(80) NOT NULL,
    razaoSocial VARCHAR(80) NOT NULL,
    ie VARCHAR(20) NOT NULL,
    cgc VARCHAR(20) NOT NULL,
    endereco VARCHAR(60) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE SET NULL ON UPDATE CASCADE,
);

CREATE TABLE pedido (
    codPedido INT NOT NULL AUTO_INCREMENT,
    dataRealizacao DATE NOT NULL DEFAULT CURRENT_DATE,
    dataEntrega DATE NOT NULL DEFAULT CURRENT_DATE,
    codFornecedor INT NOT NULL,
    valor NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (codPedido) REFERENCES itemPedido(codPedido) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE itemPedido (
    codPedido INT NOT NULL,
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL,
    quantidade NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    precoCusto NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (codPedido, codProduto, numeroLote),
    FOREIGN KEY (codPedido) REFERENCES pedido(codPedido) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (numeroLote) REFERENCES produtoLote(numeroLote) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE contasPagar (
    codTitulo INT NOT NULL AUTO_INCREMENT,
    dataVencimento DATE NOT NULL,
    parcela INT NOT NULL,
    codPedido INT NOT NULL,
    valor NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    dataPagamento DATE DEFAULT NULL,
    localPagamento VARCHAR(80) DEFAULT NULL,
    juros NUMERIC(14,2) DEFAULT NULL,
    correcaoMonetaria NUMERIC(14,2) DEFAULT NULL,
    FOREIGN KEY (codPedido) REFERENCES pedido(codPedido) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codTitulo) REFERENCES contasReceber(codTitulo) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE contasReceber (
    codTitulo INT NOT NULL AUTO_INCREMENT,
    dataVencimento DATE NOT NULL,
    codVenda INT NOT NULL,
    parcela INT NOT NULL,
    valor NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    dataPagamento DATE DEFAULT NULL,
    localPagamento VARCHAR(80) DEFAULT NULL,
    juros NUMERIC(14,2) DEFAULT NULL,
    correcaoMonetaria NUMERIC(14,2) DEFAULT NULL,
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codTitulo) REFERENCES contasPagar(codTitulo) ON DELETE CASCADE ON UPDATE CASCADE,
);