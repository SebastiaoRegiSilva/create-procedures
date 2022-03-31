CREATE DATABASE bancoAtividade;
USE bancoAtividade;

CREATE TABLE conta(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	saldo DECIMAL(10,2),
	tipoConta ENUM('C','P')
);

CREATE TABLE transferencia(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	idContaOrigem INT(11),
	idContaDestino INT(11),
	valor DECIMAL(10,2),
	FOREIGN KEY(idContaOrigem) REFERENCES conta(id),
	FOREIGN KEY(idContaDestino) REFERENCES conta(id)
);

-- Inserindo dados nas tabelas.
INSERT INTO conta (saldo,tipoConta) VALUES (8500.00, 'C');
INSERT INTO conta (saldo,tipoConta) VALUES (9874.15, 'P');
INSERT INTO conta (saldo,tipoConta) VALUES (69810.47, 'P');
INSERT INTO conta (saldo,tipoConta) VALUES (1457.99, 'P');
INSERT INTO conta (saldo,tipoConta) VALUES (6666.33, 'C');
INSERT INTO conta (saldo,tipoConta) VALUES (74840.31, 'P');
INSERT INTO conta (saldo,tipoConta) VALUES (2411.85, 'C');
INSERT INTO conta (saldo,tipoConta) VALUES (369145.24, 'P');
INSERT INTO conta (saldo,tipoConta) VALUES (365494.21, 'C');
INSERT INTO conta (saldo,tipoConta) VALUES (1.25, 'P');

-- Buscar Tipo da Conta.
-- Criando procedure.
DELIMITER $$
CREATE PROCEDURE BuscarTipoConta(INOUT id INT)
BEGIN
	SELECT conta.tipoConta FROM conta WHERE conta.id = id;
END $$
DELIMITER ; 

-- Setando valores nas variáveis.
SET @idConta =1;

-- Chamando a procedure.
CALL BuscarTipoConta(@idConta);

-- Transferir de um conta para outra.
-- Criando procedure.
DELIMITER $$
CREATE PROCEDURE Transferir(INOUT valor INT, INOUT idOrigem INT, INOUT idDestino INT)
BEGIN
	UPDATE conta SET saldo = saldo-valor WHERE id = idOrigem;
    UPDATE conta SET saldo = saldo+valor WHERE id = idDestino;
    INSERT INTO transferencia (idContaOrigem, idContaDestino, valor) VALUES (idOrigem, idDestino, valor);
END $$
DELIMITER ;

-- Setando valores nas variáveis.
SET @valor = 1000.00;
SET @idContaOrigem = 1;
SET @idContaDestino = 10;

-- Chamando a procedure.
CALL Transferir(@valor, @idContaOrigem, @IdContaDestino);
SELECT @valor , @idContaOrigem , @IdContaDestino;

-- Busca o Saldo da conta de Origem e Destino da última transferência. 
SELECT conta.id, conta.saldo FROM conta where id IN (@idContaOrigem, @idContaDestino); 

-- Sacar o valor em conta.
-- Criando procedure.
DELIMITER $$
CREATE PROCEDURE Sacar(INOUT valor INT, INOUT conta INT)
BEGIN
	UPDATE conta SET saldo = saldo-valor WHERE id = conta;
END $$
DELIMITER ;

-- Buscar o saldo de todas as contas.
SELECT conta.saldo from conta;


-- Setando valores nas variáveis.
SET @valorSacar = 1000.00;
SET @idConta = 1;

-- Chamando a procedure.
CALL Sacar(@valorSacar, @idConta);
SELECT @valorSacar, @idConta;

-- Busca o Saldo da conta que foi sacado o valor. 
SELECT conta.id, conta.saldo FROM conta where id IN (@idConta); 
