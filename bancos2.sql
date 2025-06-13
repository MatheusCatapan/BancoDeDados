CREATE DATABASE banco2;
USE banco2;

CREATE TABLE departamento (
    codDepartamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    descricaoFuncional VARCHAR(80) DEFAULT NULL,
    localizacao TEXT NOT NULL   
);

CREATE TABLE estado (
    siglaEstado VARCHAR(2) PRIMARY KEY,
    nomeEstado VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE cidade (
    codCidade INT AUTO_INCREMENT PRIMARY KEY,
    nomeCidade VARCHAR(50) NOT NULL UNIQUE,
    siglaEstado VARCHAR(2) NOT NULL,
    FOREIGN KEY (siglaEstado) REFERENCES estado(siglaEstado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE vendedor (
    codVendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    dataNascimento DATE NOT NULL,
    endereco VARCHAR(60) NOT NULL,
    cep CHAR(8) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL,
    dataContratacao DATE DEFAULT CURRENT_DATE NOT NULL,
    codDepartamento INT NOT NULL,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codDepartamento) REFERENCES departamento(codDepartamento) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cliente (
    codCliente INT AUTO_INCREMENT PRIMARY KEY,
    endereco VARCHAR(60) NOT NULL,
    codCidade INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('F', 'J')),
    dataCadastro DATE DEFAULT CURRENT_DATE NOT NULL,
    cep CHAR(8) NOT NULL,
    FOREIGN KEY (codCidade) REFERENCES cidade(codCidade) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codCliente) REFERENCES clienteFisico(codCliente) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codCliente) REFERENCES clienteJuridico(codCliente) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE classe (
    codClasse INT AUTO_INCREMENT PRIMARY KEY,
    sigla VARCHAR(12) NOT NULL UNIQUE,
    nome VARCHAR(40) NOT NULL UNIQUE,
    descricao VARCHAR(80) DEFAULT NULL
);

CREATE TABLE produto (
    codProduto INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(40) NOT NULL UNIQUE,
    unidadeMedida CHAR(2) NOT NULL CHECK (unidadeMedida IN ('UN', 'KG', 'LT', 'PC')),
    embalagem VARCHAR(15) NOT NULL DEFAULT 'fardo',
    codClasse INT NOT NULL,
    precoVenda DECIMAL(14,2) NOT NULL UNIQUE,
    estoqueMinimo DECIMAL(14,2) NOT NULL UNIQUE,
    FOREIGN KEY (codClasse) REFERENCES classe(codClasse) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE produtoLote (
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL PRIMARY KEY,
    quantidadeAdquirida DECIMAL(14,2) NOT NULL,
    quantidadeVendida DECIMAL(14,2) NOT NULL,
    precoCusto DECIMAL(14,2) NOT NULL,
    dataValidade DATE NOT NULL,
    FOREIGN KEY (codProduto) REFERENCES produto(codProduto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE venda (
    codVenda INT AUTO_INCREMENT PRIMARY KEY,
    codCliente INT NOT NULL,
    codVendedor INT NOT NULL,
    dataVenda DATE DEFAULT CURRENT_DATE NOT NULL,
    enderecoEntrega VARCHAR(60) NOT NULL,
    status CHAR(30) NOT NULL,
    FOREIGN KEY (codVenda) REFERENCES itemVenda(codVenda) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE itemVenda (
    codVenda INT NOT NULL,
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL,
    quantidade DECIMAL(14,2) NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (codVenda, codProduto, numeroLote),
);

CREATE TABLE fornecedor (
    codFornecedor INT AUTO_INCREMENT PRIMARY KEY
    nomeFantasia VARCHAR(80) NOT NULL UNIQUE,
    razaoSocial VARCHAR(80) NOT NULL UNIQUE,
    ie VARCHAR(20) NOT NULL UNIQUE,
    cgc VARCHAR(20) NOT NULL UNIQUE,
    endereco VARCHAR(60) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL,
    FOREIGN KEY (codFornecedor) REFERENCES pedido(codFornecedor) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE pedido (
    codPedido INT AUTO_INCREMENT PRIMARY KEY,
    dataRealizacao DATE DEFAULT CURRENT_DATE NOT NULL,
    dataEntrega DATE DEFAULT CURRENT_DATE NOT NULL,
    codFornecedor INT NOT NULL,
    valor DECIMAL(20,2) NOT NULL UNIQUE,
    FOREIGN KEY (codPedido) REFERENCES itemPedido(codPedido) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE itemPedido (
    codPedido INT NOT NULL,
    codProduto INT NOT NULL, 
    quantidade DECIMAL(14,2) NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (codPedido, codProduto)
)


CREATE TABLE contasPagar (
    codTitulo INT AUTO_INCREMENT PRIMARY KEY,
    dataVencimento DATE NOT NULL,
    parcela INT NOT NULL,
    codPedido INT NOT NULL, 
    valor DECIMAL(20,2) NOT NULL UNIQUE,
    dataPagamento DATE DEFAULT NULL,
    localPagamento VARCHAR(80) DEFAULT NULL,
    juros DECIMAL(12,2) DEFAULT NULL,
    correcaoMonetaria DECIMAL(12,2) DEFAULT NULL,
    FOREIGN KEY (codTitulo) REFERENCES contasReceber(codTitulo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codPedido) REFERENCES pedido(codPedido) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE contasReceber (
    codTitulo INT AUTO_INCREMENT PRIMARY KEY,
    dataVencimento DATE NOT NULL,
    codVenda INT NOT NULL,
    parcela INT NOT NULL, 
    valor DECIMAL(20,2) NOT NULL UNIQUE,
    dataPagamento DATE DEFAULT NULL,
    localPagamento VARCHAR(80) DEFAULT NULL,
    juros DECIMAL(12,2) DEFAULT NULL,
    correcaoMonetaria DECIMAL(12,2) DEFAULT NULL,
    FOREIGN KEY (codTitulo) REFERENCES contasPagar(codTitulo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codVenda) REFERENCES venda(codVenda) ON DELETE CASCADE ON UPDATE CASCADE
);