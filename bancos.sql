CREATE DATABASE bancos1;
USE bancos1;

EXEMPLO:
CREATE TABLE pessoa (
	nome VARCHAR(40) UNIQUE NOT NULL,
	idade INT NOT NULL,
	sexo VARCHAR(5) CHECK (sexo IN ('M', 'F', 'Outro')),
	raça VARCHAR(20) DEFAULT 'humano'
);

CREATE TABLE departamento (
    codDepartamento AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE
    descricaoFuununcional VARCHAR (80) OPTIONAL,
    localizacao TEXT NOT NULL,
);

CREATE TABLE estado (
    siglaEstado VARCHAR(2) PRIMARY KEY,
    nomeEstado VARCHAR(30) NOT NULL UNIQUE,
)

CREATE TABLE cidade (
    codCidade INT AUTO_INCREMENT PRIMARY KEY,
    nomeCidade VARCHAR(50) NOT NULL UNIQUE,
    siglaEstado VARCHAR(2) NOT NULL,
    FOREIGN KEY (siglaEstado) REFERENCES estado(siglaEstado) ON DELETE CASCADE ON UPDATE CASCADE
)

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
);

CREATE TABLE cliente (
    codCliente AUTOMATIC PRIMARY KEY,
    endereco VARCHAR(60) NOT NULL,
    codCidade INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('F', 'J')),
);

CREATE TABLE clienteFisico (
    codCliente INT PRIMARY KEY,
    nome VARCHAR (50) NOT NULL UNIQUE,
    dataNascimento DATE NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    rg CHAR(8) NOT NULL UNIQUE,
);

CREATE TABLE clienteJuridico (
    codCliente INT PRIMARY KEY,
    nomeFantasia VARCHAR(80), UNIQUE,
    razaoScial VARCHAR 80, NOT NULL UNIQUE,
    ie VARCHAR(20) NOT NULL UNIQUE,
    cgc VARCHAR(20), NOT NULL UNIQUE,
);

CREATE TABLE classe (
    codClasse INT AUTO_INCREMENT PRIMARY KEY,
    sigla VARCHAR(12),
    nome VARCHAR(40) NOT NULL UNIQUE,
    descricao VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE produto (
    codProduto INT AUTO_INCREMENT PRIMARY KEY, 
    descricao VARCHAR(40) NOT NULL UNIQUE,
    unidadeMedida CHAR(2) NOT NULL CHECK,
    embalagem VARCHAR(15) NOT NULL UNIQUE DEFAULT 'fardo',
    codClasse INT NOT NULL,
    precoVenda NUMERIC (14,2) DECIMAL(14,2 NOT NULL UNIQUE),
    estoqueMinimo NUMERIC(14,2) DECIMAL(14,2 NOT NULL UNIQUE),
);

CREATE TABLE produtoLote (
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL,
    quantidadeAdquirida NUMERIC(14,2), DECIMAL(14,2) NOT NULL UNIQUE,
    quantidadeVendida NUMERIC(14,2) DECIMAL(14,2) NOT NULL UNIQUE,
    precoCusto NUMERIC(14,2) DECIMAL(14,2) NOT NULL UNIQUE,
    dataValidade DATE NOT NULL UNIQUE,
);   

CREATE TABLE venda (
    codVenda INT PRIMARY KEY,
    codCliente INT,
    codVendedor INT,
    dataVenda DATE NOT NULL (DEFAULT CURRENT_DATE)
    enderecoEntraga VARCHAR(60) NOT NULL,
    status VARCHAR (30),
);

CREATE TABLE itemVenda (
    codVenda INT,
    codProduto INT,
    numeroLote INT,
    quantidade NUMERIC(14,2) DECIMAL (14,2) NOT NULL CHECK (quantidade > 0),
);

CREATE TABLE fornecedor (
    codFornecedor INT PRIMARY KEY,
    nomeFantasia VARCHAR(80) NOT NULL UNIQUE,
    razaoSocial VARCHAR(80) NOT NULL UNIQUE,
    ie VARCHAR(20) NOT NULL UNIQUE,
    cgc VARCHAR(20) NOT NULL UNIQUE,
    endereco VARCHAR(60) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    codCidade INT NOT NULL,
);

CREATE TABLE pedido (
    codPedido INT AutO_INCREMENT PRIMARY KEY,
    dataRealizacao DATE NOT NULL DEFAULT CURRENT_DATE,
    dataEntrega DATE NOT NULL DEFAULT CURRENT_DATE,
    codFornecedor INT NOT NULL,
    valor NUMERIC DECIMAL(20,2) NOT NULL UNIQUE,
);

CREATE TABLE itemPedido (
    codPedido INT NOT NULL,
    codProduto INT NOT NULL,
    numeroLote INT NOT NULL,
    quantidade NUMERIC(14,2) DECIMAL(14,2) NOT NULL CHECK (quantidade > 0),
);