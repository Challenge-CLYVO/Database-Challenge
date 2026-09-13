SET SERVEROUTPUT ON
SET VERIFY OFF

DROP TABLE Usuario CASCADE CONSTRAINTS;
DROP TABLE Clinica CASCADE CONSTRAINTS;
DROP TABLE Responsavel CASCADE CONSTRAINTS;
DROP TABLE Veterinario CASCADE CONSTRAINTS;
DROP TABLE Pet CASCADE CONSTRAINTS;
DROP TABLE Vacina CASCADE CONSTRAINTS;
DROP TABLE Consulta CASCADE CONSTRAINTS;
DROP TABLE Aplicacao_vacina CASCADE CONSTRAINTS;
DROP TABLE Lembrete CASCADE CONSTRAINTS;
DROP TABLE Sensor CASCADE CONSTRAINTS;
DROP TABLE Leitura CASCADE CONSTRAINTS;
DROP TABLE Log_erro CASCADE CONSTRAINTS;
DROP TABLE Auditoria CASCADE CONSTRAINTS;



--tabela usuario 
CREATE TABLE  Usuario(
    id_usuario NUMBER,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(255)NOT NULL,
    senha VARCHAR2(255)NOT NULL,
    telefone VARCHAR2(11) NOT NULL,
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20)DEFAULT 'ATIVO'NOT NULL,
    tipo_usuario VARCHAR2(20)NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uk_usuario_email UNIQUE(email),
    CONSTRAINT ck_usuario_status CHECK (status IN('ATIVO','INATIVO')),
    CONSTRAINT ck_usuario_tipo CHECK(tipo_usuario IN('RESPONSAVEL','VETERINARIO'))
);
--tabela clinica
CREATE TABLE Clinica(
    id_clinica NUMBER,
    nome VARCHAR2(100) NOT NULL,
    cnpj VARCHAR2(14) NOT NULL,
    telefone VARCHAR2(11) NOT NULL,
    email VARCHAR2(255),
    endereco VARCHAR2(255)NOT NULL,
    CONSTRAINT pk_clinica PRIMARY KEY (id_clinica),
    CONSTRAINT uk_clinica_cnpj UNIQUE (cnpj)
);

--table responsavel
CREATE TABLE Responsavel(
    id_responsavel NUMBER,
    cpf VARCHAR2(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    id_usuario NUMBER NOT NULL,
    CONSTRAINT pk_responsavel PRIMARY KEY(id_responsavel),
    CONSTRAINT uk_responsavel UNIQUE (cpf),
    CONSTRAINT uk_responsavel_usuario UNIQUE(id_usuario),
    CONSTRAINT fk_responsavel_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)   
);

--tabela Veterinario
CREATE TABLE Veterinario(
    id_veterinario NUMBER,
    crv VARCHAR2(20) NOT NULL,
    especialidade VARCHAR2(100) NOT NULL,
    id_usuario NUMBER NOT NULL,
    id_clinica NUMBER NOT NULL,
    CONSTRAINT pk_veterinario PRIMARY KEY (id_veterinario),
    CONSTRAINT uk_veterinario_crv UNIQUE (crv),
    CONSTRAINT uk_veterinario_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_veterinario_usuario FOREIGN KEY(id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_veterinario_clinica FOREIGN KEY(id_clinica) REFERENCES CLinica(id_clinica)  
);

--tabela pet
CREATE TABLE Pet(
    id_pet NUMBER,
    nome VARCHAR2(100) NOT NULL,
    sexo VARCHAR2(20) NOT NULL,
    raca VARCHAR2(50)NOT NULL,
    especie VARCHAR2(50)NOT NULL,
    data_nascimento DATE NOT NULL,
    id_responsavel NUMBER NOT NULL,
    CONSTRAINT pk_pet PRIMARY KEY(id_pet),
    CONSTRAINT ck_pet_sexo CHECK(sexo IN('MACHO','FEMEA','NAO_INFORMADO')),
    CONSTRAINT fk_pet_responsavel FOREIGN KEY (id_responsavel) REFERENCES responsavel(id_responsavel)
);

--tabela vacina
CREATE TABLE Vacina(
    id_vacina NUMBER,
    nome VARCHAR2(100)NOT NULL,
    descricao VARCHAR2(255),
    CONSTRAINT pk_vacina PRIMARY KEY(id_vacina)
);

--tabela consulta
CREATE TABLE Consulta(
    id_consulta NUMBER,
    data_hora DATE NOT NULL,
    motivo VARCHAR2(100)NOT NULL,
    observacao VARCHAR2(255),
    status VARCHAR2(20)NOT NULL,
    id_pet NUMBER NOT NULL,
    id_veterinario NUMBER NOT NULL,
    id_clinica NUMBER NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY(id_consulta),
    CONSTRAINT ck_consulta_status CHECK (status IN('AGENDADA', 'REALIZADA', 'CANCELADA')),
    CONSTRAINT fk_consulta_pet FOREIGN KEY (id_pet)REFERENCES Pet(id_pet),
    CONSTRAINT fk_consulta_veterinario FOREIGN KEY(id_veterinario) REFERENCES Veterinario(id_veterinario),
    CONSTRAINT fk_consulta_clinica FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica)
);

--tabela aplicacao_vacina
CREATE TABLE Aplicacao_vacina(
    id_aplicacao_vacina NUMBER,
    data_aplicacao DATE NOT NULL,
    dose VARCHAR(20)NOT NULL,
    observacao VARCHAR2(255),
    id_pet NUMBER NOT NULL,
    id_vacina NUMBER NOT NULL,
    id_veterinario NUMBER,
    CONSTRAINT pk_aplicacao_vacina PRIMARY KEY (id_aplicacao_vacina),
    CONSTRAINT fk_aplicacao_pet FOREIGN KEY(id_pet) REFERENCES Pet(id_pet),
    CONSTRAINT fk_aplicacao_vacina FOREIGN KEY (id_vacina) REFERENCES Vacina(id_vacina),
    CONSTRAINT fk_aplicacao_veterinario FOREIGN KEY (id_veterinario) REFERENCES Veterinario(id_veterinario) 
);

--tabela lembrete
CREATE TABLE Lembrete(
    id_lembrete NUMBER,
    titulo VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(255),
    data_hora DATE NOT NULL,
    status VARCHAR2(20) NOT NULL,
    id_pet NUMBER NOT NULL,
    CONSTRAINT pk_lembrete PRIMARY KEY (id_lembrete),
    CONSTRAINT ck_lembrete_status CHECK(status IN('PENDENTE', 'CONCLUIDO','CANCELADO')),
    CONSTRAINT fk_lembrete_pet FOREIGN KEY(id_pet) REFERENCES Pet(id_pet)
);

--tabela sensor
CREATE TABLE Sensor(
    id_sensor NUMBER,
    tipo VARCHAR2(50) NOT NULL,
    unidade VARCHAR2(20) NOT NULL,
    status VARCHAR2(20) NOT NULL,
    id_pet NUMBER NOT NULL,
    CONSTRAINT pk_sensor PRIMARY KEY (id_sensor),
    CONSTRAINT ck_sensor_status CHECK(status in ('ATIVO', 'INATIVO')),
    CONSTRAINT fk_sensor_pet FOREIGN KEY (id_pet) REFERENCES Pet(id_pet)
);

--tabela leitura
CREATE TABLE Leitura(
    id_leitura NUMBER,
    data_registro DATE DEFAULT SYSDATE NOT NULL,
    valor NUMBER (10,2) NOT NULL,
    id_sensor NUMBER NOT NULL,
    CONSTRAINT pk_leitura PRIMARY KEY (id_leitura),
    CONSTRAINT fk_leitura_sensor FOREIGN KEY (id_sensor) REFERENCES Sensor(id_sensor)
);

--table Log_erro
CREATE TABLE Log_erro(
    id_log_erro NUMBER,
    nome_procedure VARCHAR2(100),
    usuario VARCHAR2(100),
    data_erro DATE DEFAULT SYSDATE NOT NULL,
    codigo_erro NUMBER,
    mensagem_erro VARCHAR2(500) NOT NULL,
    CONSTRAINT pk_log_erro PRIMARY KEY (id_log_erro)
);

--tabela de auditoria
CREATE TABLE Auditoria(
    id_auditoria NUMBER GENERATED BY DEFAULT AS IDENTITY,
    usuario VARCHAR2(100) NOT NULL,
    operacao VARCHAR2(10) NOT NULL,
    data_operacao DATE DEFAULT SYSDATE NOT NULL,
    valor_antigo VARCHAR2(4000),
    valor_novo VARCHAR2(4000),
    tabela_afetada VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_auditoria PRIMARY KEY(id_auditoria),
    CONSTRAINT ck_auditoria_operacao CHECK (operacao IN ('INSERT', 'UPDATE', 'DELETE'))
);
--insert usuario
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (1, 'Ana Souza', 'ana@email.com', 'senha1', '11999990001', 'RESPONSAVEL');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (2, 'Carlos Lima', 'carlos@email.com', 'senha2', '11999990002', 'RESPONSAVEL');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (3, 'Marina Alves', 'marina@email.com', 'senha3', '11999990003', 'RESPONSAVEL');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (4, 'Dr. Paulo Mendes', 'paulo@vet.com', 'senha4', '11999990004', 'VETERINARIO');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (5, 'Dra. Juliana Rocha', 'juliana@vet.com', 'senha5', '11999990005', 'VETERINARIO');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (6, 'Fernanda Costa', 'fernanda@email.com', 'senha6','11999990006', 'RESPONSAVEL');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (7, 'Ricardo Santos', 'ricardo@email.com', 'senha7','11999990007', 'RESPONSAVEL');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (8, 'Dr. Marcelo Nunes', 'marcelo@vet.com', 'senha8','11999990008', 'VETERINARIO');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (9, 'Dra. Beatriz Lopes', 'beatriz@vet.com', 'senha9','11999990009', 'VETERINARIO');
INSERT INTO Usuario (id_usuario, nome, email, senha, telefone, tipo_usuario) VALUES (10, 'Dr. Rafael Martins', 'rafael@vet.com', 'senha10','11999990010', 'VETERINARIO');

--insert clinica
INSERT INTO Clinica (id_clinica, nome, cnpj, telefone, email, endereco) VALUES  (1, 'Clinica Pet Vida', '11111111000111', '1133330001','contato@petvida.com', 'Rua A, 100');
INSERT INTO Clinica (id_clinica, nome, cnpj, telefone, email, endereco) VALUES  (2, 'Vet Center', '22222222000122', '1133330002','contato@vetcenter.com', 'Rua B, 200');
INSERT INTO Clinica (id_clinica, nome, cnpj, telefone, email, endereco) VALUES  (3, 'Animal Care', '33333333000133', '1133330003', 'contato@animalcare.com', 'Rua C, 300');
INSERT INTO Clinica (id_clinica, nome, cnpj, telefone, email, endereco) VALUES  (4, 'Saude Pet', '44444444000144', '1133330004','contato@saudepet.com', 'Rua D, 400');
INSERT INTO Clinica (id_clinica, nome, cnpj, telefone, email, endereco) VALUES  (5, 'Vet Mais', '55555555000155', '1133330005','contato@vetmais.com', 'Rua E, 500');

--insert responsavel
INSERT INTO Responsavel (id_responsavel, cpf, data_nascimento, id_usuario) VALUES (1, '11111111111', DATE '1995-03-10', 1);
INSERT INTO Responsavel (id_responsavel, cpf, data_nascimento, id_usuario) VALUES (2, '22222222222', DATE '1990-07-21', 2);
INSERT INTO Responsavel (id_responsavel, cpf, data_nascimento, id_usuario) VALUES (3, '33333333333', DATE '1998-11-05', 3);
INSERT INTO Responsavel (id_responsavel, cpf, data_nascimento, id_usuario) VALUES (4, '44444444444', DATE '1993-02-15', 6);
INSERT INTO Responsavel (id_responsavel, cpf, data_nascimento, id_usuario) VALUES (5, '55555555555', DATE '1988-09-30', 7);

--insert veterinario
INSERT INTO Veterinario (id_veterinario, crv, especialidade, id_usuario, id_clinica) VALUES (1, 'CRV1001', 'Clinica Geral', 4, 1);
INSERT INTO Veterinario (id_veterinario, crv, especialidade, id_usuario, id_clinica) VALUES (2, 'CRV1002', 'Dermatologia', 5, 2);
INSERT INTO Veterinario (id_veterinario, crv, especialidade, id_usuario, id_clinica) VALUES (3, 'CRV1003', 'Cardiologia', 8, 3);
INSERT INTO Veterinario (id_veterinario, crv, especialidade, id_usuario, id_clinica) VALUES (4, 'CRV1004', 'Ortopedia', 9, 4);
INSERT INTO Veterinario (id_veterinario, crv, especialidade, id_usuario, id_clinica) VALUES (5, 'CRV1005', 'Clinica Geral', 10, 5);

--insert pet
INSERT INTO Pet (id_pet, nome, sexo, raca, especie, data_nascimento, id_responsavel) VALUES (1, 'Rex', 'MACHO', 'Labrador', 'CACHORRO',DATE '2021-03-15', 1);
INSERT INTO Pet (id_pet, nome, sexo, raca, especie, data_nascimento, id_responsavel) VALUES (2, 'Luna', 'FEMEA', 'Siamês', 'GATO', DATE '2022-07-10', 2);
INSERT INTO Pet (id_pet, nome, sexo, raca, especie, data_nascimento, id_responsavel) VALUES (3, 'Thor', 'MACHO', 'Golden Retriever', 'CACHORRO',DATE '2020-11-05', 3);
INSERT INTO Pet (id_pet, nome, sexo, raca, especie, data_nascimento, id_responsavel) VALUES (4, 'Mel', 'FEMEA', 'SRD', 'CACHORRO',DATE '2023-01-20', 4);
INSERT INTO Pet (id_pet, nome, sexo, raca, especie, data_nascimento, id_responsavel) VALUES (5, 'Nina', 'FEMEA', 'Persa', 'GATO',DATE '2019-06-12', 5);

--insert vacina
INSERT INTO Vacina (id_vacina, nome, descricao) VALUES (1, 'Antirrabica', 'Vacina para prevencao da raiva');
INSERT INTO Vacina (id_vacina, nome, descricao) VALUES (2, 'V8', 'Vacina multipla para caes');
INSERT INTO Vacina (id_vacina, nome, descricao) VALUES (3, 'V10', 'Vacina multipla para caes');
INSERT INTO Vacina (id_vacina, nome, descricao) VALUES (4, 'Triplice Felina', 'Vacina multipla para gatos');
INSERT INTO Vacina (id_vacina, nome, descricao) VALUES (5, 'Giardia', 'Vacina auxiliar na prevencao da giardiase');

--insert aplicacao_vacina
INSERT INTO Aplicacao_vacina (id_aplicacao_vacina, data_aplicacao, dose, observacao,id_pet, id_vacina, id_veterinario) VALUES (1, DATE '2026-04-10', '1 DOSE','Aplicacao sem intercorrencias',1, 1, 1);
INSERT INTO Aplicacao_vacina (id_aplicacao_vacina, data_aplicacao, dose, observacao,id_pet, id_vacina, id_veterinario) VALUES (2, DATE '2026-05-12', 'REFORCO','Reforco anual',2, 4, 2);
INSERT INTO Aplicacao_vacina (id_aplicacao_vacina, data_aplicacao, dose, observacao,id_pet, id_vacina, id_veterinario) VALUES (3, DATE '2026-06-15', '1 DOSE','Normal',3, 2, 3);
INSERT INTO Aplicacao_vacina (id_aplicacao_vacina, data_aplicacao, dose, observacao,id_pet, id_vacina, id_veterinario) VALUES (4, DATE '2026-02-20', 'REFORCO','Registro de vacina aplicada anteriormente',4, 3, 3);
INSERT INTO Aplicacao_vacina (id_aplicacao_vacina, data_aplicacao, dose, observacao,id_pet, id_vacina, id_veterinario) VALUES (5, DATE '2026-03-11', '1 DOSE','Tutor nao informou o profissional',5, 4, 4);

--insert consulta
INSERT INTO Consulta (id_consulta, data_hora, motivo, observacao, status,id_pet, id_veterinario, id_clinica) VALUES (1, DATE '2026-08-10','Consulta de rotina','Animal em boas condicoes','REALIZADA',1, 1, 1);
INSERT INTO Consulta (id_consulta, data_hora, motivo, observacao, status,id_pet, id_veterinario, id_clinica) VALUES (2, DATE '2026-08-12','Coceira persistente','Possivel quadro alergico','REALIZADA',2, 2, 2);
INSERT INTO Consulta (id_consulta, data_hora, motivo, observacao, status,id_pet, id_veterinario, id_clinica) VALUES (3, DATE '2026-08-15','Avaliacao cardiaca','Acompanhamento preventivo','REALIZADA',3, 3, 3);
INSERT INTO Consulta (id_consulta, data_hora, motivo, observacao, status,id_pet, id_veterinario, id_clinica) VALUES (4, DATE '2026-09-20','Avaliacao ortopedica','Acompanhamento preventivo','AGENDADA',4, 4, 4);
INSERT INTO Consulta (id_consulta, data_hora, motivo, observacao, status,id_pet, id_veterinario, id_clinica) VALUES (5, DATE '2026-09-22','Consulta de rotina','Avaliacao ortopedica','AGENDADA',5, 5, 5);

--insert lembrete
INSERT INTO Lembrete (id_lembrete, titulo, descricao, data_hora, status, id_pet) VALUES (1, 'Reforco de vacina','Verificar data do reforco da vacina',DATE'2026-10-10','PENDENTE', 1);
INSERT INTO Lembrete (id_lembrete, titulo, descricao, data_hora, status, id_pet) VALUES (2, 'Consulta dermatologica','Retorno para avaliacao',DATE'2026-09-18','PENDENTE', 2);
INSERT INTO Lembrete (id_lembrete, titulo, descricao, data_hora, status, id_pet) VALUES (3, 'Medicamento','Administrar medicamento prescrito',DATE '2026-09-08','PENDENTE', 3);
INSERT INTO Lembrete (id_lembrete, titulo, descricao, data_hora, status, id_pet) VALUES (4, 'Consulta ortopedica','Comparecer a clinica',DATE '2026-09-20','PENDENTE', 4);
INSERT INTO Lembrete (id_lembrete, titulo, descricao, data_hora, status, id_pet) VALUES (5, 'Consulta anual','Realizar avaliacao preventiva',DATE '2026-09-22','PENDENTE', 5);

--insert sensor
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (1, 'TEMPERATURA', 'C', 'ATIVO', 1);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (2, 'ATIVIDADE', 'METROS', 'ATIVO', 1);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (3, 'TEMPERATURA', 'C', 'ATIVO', 2);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (4, 'ATIVIDADE', 'METROS', 'ATIVO', 2);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (5, 'TEMPERATURA', 'C', 'ATIVO', 3);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (6, 'ATIVIDADE', 'METROS', 'ATIVO', 3);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (7, 'TEMPERATURA', 'C', 'ATIVO', 4);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (8, 'ATIVIDADE', 'METROS', 'ATIVO', 4);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (9, 'TEMPERATURA', 'C', 'ATIVO', 5);
INSERT INTO Sensor (id_sensor,tipo,unidade, status, id_pet) VALUES (10, 'ATIVIDADE', 'METROS', 'ATIVO', 5);

--insert leitura
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (1, DATE '2026-09-01', 38.50, 1);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (2, DATE '2026-09-02', 38.70, 1);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (3, DATE '2026-09-01', 72.00, 2);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (4, DATE '2026-09-02', 68.00, 2);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (5, DATE '2026-09-01', 38.90, 3);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (6, DATE '2026-09-02', 39.10, 3);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (7, DATE '2026-09-01', 65.00, 4);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (8, DATE '2026-09-02', 61.00, 4);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (9, DATE '2026-09-01', 38.40, 5);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (10, DATE '2026-09-02', 38.60, 5);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (11, DATE '2026-09-01', 80.00, 6);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (12, DATE '2026-09-02', 77.00, 6);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (13, DATE '2026-09-01', 38.80, 7);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (14, DATE '2026-09-02', 39.00, 7);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (15, DATE '2026-09-01', 55.00, 8);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (16, DATE '2026-09-02', 48.00, 8);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (17, DATE '2026-09-01', 38.60, 9);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (18, DATE '2026-09-02', 38.70, 9);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (19, DATE '2026-09-01', 60.00, 10);
INSERT INTO Leitura (id_leitura, data_registro, valor, id_sensor) VALUES (20, DATE '2026-09-02', 57.00, 10);




--function(1) pega os dados de consulta e coloca num json
CREATE OR REPLACE FUNCTION fn_consulta_json(
    p_id_consulta IN NUMBER
)  RETURN VARCHAR2
IS
    v_json VARCHAR2(4000);
    v_pet Pet.nome%TYPE;
    v_veterinario Usuario.nome%TYPE;
    v_clinica Clinica.nome%TYPE;
    v_data Consulta.data_hora%TYPE;
    v_motivo Consulta.motivo%TYPE;
    v_status Consulta.status%TYPE;
    e_id_invalido EXCEPTION;
    
BEGIN

    IF p_id_consulta IS NULL OR p_id_consulta <= 0 THEN RAISE e_id_invalido;
    END IF;
    

    SELECT p.nome,u.nome, c.nome,co.data_hora, co.motivo, co.status
    INTO   v_pet,v_veterinario,v_clinica,v_data,v_motivo,v_status
    FROM    Consulta co 
    JOIN Pet p 
        ON co.id_pet = p.id_pet
    JOIN Veterinario v
        ON co.id_veterinario = v.id_veterinario
    JOIN Usuario u
        ON v.id_usuario = u.id_usuario
    JOIN Clinica c
        ON co.id_clinica = c.id_clinica
    WHERE co.id_consulta = p_id_consulta;
            
    v_json :=
        '{'||
        '"id_consulta":' || p_id_consulta || ',' ||
        '"pet":"' || v_pet || '",' ||
        '"veterinario":"' || v_veterinario || '",' ||
        '"clinica":"' || v_clinica || '",' ||
        '"data":"' || TO_CHAR(v_data, 'YYYY-MM-DD') || '",' ||
        '"motivo":"' || v_motivo || '",' ||
        '"status":"' || v_status || '"' ||
        '}';
    
    RETURN v_json;

EXCEPTION
    
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Consulta nao encontrada.');
        RETURN '{"erro":"Consulta nao encontrada"}';

    WHEN e_id_invalido THEN
    DBMS_OUTPUT.PUT_LINE('ID da consulta invalido.');
    RETURN '{"erro":"ID da consulta invalido"}';

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
        RETURN '{"erro":"' || REPLACE(SQLERRM, '"', '''') || '"}';
            
END;
/

--function(02) validacao cpf
CREATE OR REPLACE FUNCTION fn_validar_cpf(
    p_cpf IN VARCHAR2
)RETURN VARCHAR2
IS 
    v_soma NUMBER :=0;
    v_resto NUMBER;
    v_digito NUMBER;
    v_digito1 NUMBER;
    v_digito2 NUMBER;
    I NUMBER;
    
    e_cpf_nao_informado EXCEPTION;
    e_tamanho_invalido EXCEPTION;

BEGIN

    
    IF p_cpf IS NULL THEN RAISE e_cpf_nao_informado;   
    END IF;
    
    IF LENGTH(p_cpf) != 11 THEN RAISE e_tamanho_invalido; 
    END IF;
    
    --primeiro digito
    v_soma := 0;
    i := 1;
    
    WHILE i <= 9 LOOP
    
    v_digito := TO_NUMBER(SUBSTR(p_cpf, i, 1));
        
    v_soma := v_soma + v_digito * (11 - i);

    i := i + 1;
    
    END LOOP;
    
    v_resto := MOD(v_soma,11);
    
    IF v_resto < 2 THEN
        v_digito1 :=0;
    ELSE
        v_digito1 :=11 - v_resto;
    END IF;
    
    --segundo digito
    
    v_soma := 0;
    i :=1;
    
    WHILE i <= 10 LOOP
    
    v_digito := TO_NUMBER(SUBSTR(p_cpf,i,1));
    
    v_soma := v_soma + v_digito * (12 - i);
    
    i := i +1;
    
    END LOOP;
    
    v_resto := MOD(v_soma, 11);
    
    IF v_resto  <2 THEN
    
        v_digito2 :=0;
    
    ELSE
        
        v_digito2 := 11- v_resto;
    
    END IF;
     
    
    IF v_digito1 = TO_NUMBER(SUBSTR(p_cpf,10,1)) AND v_digito2 = TO_NUMBER(SUBSTR(p_cpf,11,1)) THEN
        DBMS_OUTPUT.PUT_LINE('CPF valido.');
        RETURN 'CPF VALIDO';
    ELSE
        DBMS_OUTPUT.PUT_LINE('CPF invalido.');
        RETURN 'CPF INVALIDO';
    END IF;

EXCEPTION

    WHEN e_cpf_nao_informado THEN
        DBMS_OUTPUT.PUT_LINE('CPF nao informado.');
        RETURN 'CPF INVALIDO';
    
    WHEN e_tamanho_invalido THEN
        DBMS_OUTPUT.PUT_LINE('CPF deve possuir 11 numeros.');
        RETURN 'CPF INVALIDO';

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('CPF invalido. Informa apenas numeros');
        RETURN 'CPF INVALIDO';
    
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('Erro na conversao numerica do CPF.');
        RETURN 'CPF INVALIDO';
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: '||SQLERRM);
        RETURN 'ERRO';
END;
/

--procedure(1) relacionada a function(1) leitura e impressão dos dados

CREATE OR REPLACE PROCEDURE pr_consulta_pet_json(
    p_id_pet IN NUMBER
)
IS
    v_quantidade NUMBER;
    v_consultas NUMBER;

    e_id_invalido EXCEPTION;
    e_pet_nao_encontrado EXCEPTION;
    e_sem_consultas EXCEPTION;

BEGIN

    IF p_id_pet IS NULL OR p_id_pet <= 0 THEN RAISE e_id_invalido;
    END IF;
        


    SELECT COUNT(*)
    INTO v_quantidade
    FROM Pet
    WHERE id_pet = p_id_pet;
    
    
    IF v_quantidade = 0 THEN RAISE e_pet_nao_encontrado;
    END IF;    
         
    SELECT COUNT(*)
    INTO v_consultas
    FROM Consulta
    WHERE id_pet = p_id_pet;
    
    IF v_consultas = 0 THEN RAISE e_sem_consultas;
    END IF;    
         
         
    
        FOR r IN( SELECT p.nome, c.id_consulta
                  FROM Pet p
                  JOIN Consulta c
                    ON p.id_pet = c.id_pet
                  WHERE p.id_pet = p_id_pet
                  ORDER BY c.data_hora)
        LOOP
            DBMS_OUTPUT.PUT_LINE(
                fn_consulta_json(r.id_consulta)    
                );
        END LOOP;
    

EXCEPTION
    
    WHEN e_id_invalido THEN
        INSERT INTO Log_Erro (nome_procedure,usuario,codigo_erro,mensagem_erro)
        VALUES ('PR_CONSULTA_PET_JSON',USER,-20001,'ID do pet invalido');
        DBMS_OUTPUT.PUT_LINE('ID do pet invalido.');

    WHEN e_pet_nao_encontrado THEN
        INSERT INTO Log_Erro (nome_procedure,usuario,codigo_erro,mensagem_erro)
        VALUES ('PR_CONSULTA_PET_JSON',USER,-20002,'Pet nao encontrado.');
        DBMS_OUTPUT.PUT_LINE('Pet nao encontrado.');
    
    WHEN e_sem_consultas THEN
        INSERT INTO Log_Erro (nome_procedure,usuario,codigo_erro,mensagem_erro)
        VALUES ('PR_CONSULTA_PET_JSON',USER,-20003,'O pet nao possui consultas cadastradas.');
        DBMS_OUTPUT.PUT_LINE('O pet nao possui consultas cadastradas.');
    
    WHEN OTHERS THEN
    
        INSERT INTO  Log_erro(nome_procedure,usuario,data_erro,codigo_erro,mensagem_erro)
        VALUES('PR_CONSULTA_PET_JSON',USER,SYSDATE,SQLCODE,SQLERRM);
    
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: '||SQLERRM);
    
END;
/
    
--procedure 2 relatorio_leitura atividade dos pets
CREATE OR REPLACE PROCEDURE pr_relatorio_leituras
IS
    
    v_especie_anterior Pet.especie%TYPE;
    v_pet_anterior Pet.nome%TYPE;

    v_soma_pet NUMBER := 0;
    v_subtotal_especie NUMBER := 0;
    v_total_geral NUMBER := 0;

    v_primeira_linha NUMBER := 1;
    
    v_quantidade NUMBER;
    v_valores_invalidos NUMBER;
    
    e_sem_leituras EXCEPTION;
    e_dados_insuficientes EXCEPTION;
    e_valor_negativo EXCEPTION;

BEGIN

    SELECT COUNT(*)
    INTO v_quantidade
    FROM Leitura l
    JOIN Sensor s
        ON l.id_sensor = s.id_sensor
    WHERE s.tipo = 'ATIVIDADE';
    
    IF v_quantidade = 0 THEN RAISE e_sem_leituras;
    END IF;
    
    IF v_quantidade < 5 THEN RAISE e_dados_insuficientes;
    END IF;


    SELECT COUNT(*)
    INTO v_valores_invalidos
    FROM Leitura l
    JOIN Sensor s
        ON l.id_sensor = s.id_sensor
    WHERE s.tipo = 'ATIVIDADE'
      AND l.valor < 0;
      
     IF v_valores_invalidos > 0 THEN  RAISE e_valor_negativo;
     END IF;

    FOR r IN( SELECT p.especie, p.nome, l.valor
              FROM Leitura l
              JOIN Sensor s
                ON l.id_sensor = s.id_sensor
              JOIN Pet p
                ON s.id_pet = p.id_pet
              WHERE s.tipo = 'ATIVIDADE'
              ORDER BY
                p.especie,
                p.nome
            
    )
    LOOP
    
    IF v_primeira_linha = 1 THEN
        
          v_especie_anterior := r.especie;
          v_pet_anterior := r.nome;
          v_primeira_linha := 0;    

    END IF;
    
    IF r.nome != v_pet_anterior OR r.especie != v_especie_anterior THEN
        DBMS_OUTPUT.PUT_LINE( v_especie_anterior ||' | ' ||v_pet_anterior ||' | ' ||v_soma_pet);

        v_soma_pet := 0;

    END IF;
    
    IF r.especie != v_especie_anterior THEN
         DBMS_OUTPUT.PUT_LINE(v_especie_anterior ||' | NULL | ' ||v_subtotal_especie);
         DBMS_OUTPUT.PUT_LINE('-----------------------');
        
        
        
         v_subtotal_especie := 0;

    END IF;
    
        v_especie_anterior := r.especie;
        v_pet_anterior := r.nome;
        
        v_soma_pet := v_soma_pet + r.valor;
        
        v_subtotal_especie := v_subtotal_especie + r.valor;
        
        v_total_geral := v_total_geral + r.valor;
    
    END LOOP;
    
    IF v_primeira_linha = 0 THEN
        DBMS_OUTPUT.PUT_LINE(v_especie_anterior ||' | ' ||v_pet_anterior ||' | ' ||v_soma_pet);
        DBMS_OUTPUT.PUT_LINE(v_especie_anterior ||' | NULL | ' ||v_subtotal_especie);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('NULL | NULL | ' ||v_total_geral);
    
    ELSE
        
        DBMS_OUTPUT.PUT_LINE('Nenhuma leitura encontrada.');
    
    END IF;

EXCEPTION

    WHEN e_sem_leituras THEN
         DBMS_OUTPUT.PUT_LINE('Nenhuma leitura de atividade encontrada.');
    
    WHEN e_dados_insuficientes THEN 
        DBMS_OUTPUT.PUT_LINE( 'Quantidade insuficiente de leituras. Minimo: 5.'); 
     
    WHEN e_valor_negativo THEN  
        DBMS_OUTPUT.PUT_LINE('Existem leituras de atividade com valor negativo.');
    
    WHEN OTHERS THEN
        INSERT INTO  Log_erro(nome_procedure,usuario,data_erro,codigo_erro,mensagem_erro)
        VALUES('PR_RELATORIO_LEITURAS',USER,SYSDATE,SQLCODE,SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);

END;
/

SET SERVEROUTPUT ON;

--triggers auditoria 
CREATE OR REPLACE TRIGGER trg_auditoria_consulta
AFTER INSERT OR UPDATE OR DELETE ON Consulta

FOR EACH ROW

BEGIN
    IF INSERTING THEN
        
        INSERT INTO Auditoria(
            usuario,
            operacao,
            data_operacao,
            valor_antigo,
            valor_novo,
            tabela_afetada
        )
        VALUES(USER,'INSERT',SYSDATE,NULL,'ID_CONSULTA=' || :NEW.id_consulta ||', STATUS=' || :NEW.status ||', ID_PET=' || :NEW.id_pet,'CONSULTA');
    

    ELSIF UPDATING THEN
    
        INSERT INTO Auditoria(
            usuario,
            operacao,
            data_operacao,
            valor_antigo,
            valor_novo,
            tabela_afetada
        )
        VALUES(USER,'UPDATE',SYSDATE,'ID_CONSULTA=' || :OLD.id_consulta ||', STATUS=' || :OLD.status ||', ID_PET=' || :OLD.id_pet,'ID_CONSULTA=' || :NEW.id_consulta ||', STATUS=' || :NEW.status ||', ID_PET=' || :NEW.id_pet,'CONSULTA');
        
    ELSIF DELETING THEN  
    
        INSERT INTO Auditoria(
            usuario,
            operacao,
            data_operacao,
            valor_antigo,
            valor_novo,
            tabela_afetada
        )
        VALUES (USER,'DELETE',SYSDATE,'ID_CONSULTA=' || :OLD.id_consulta ||', STATUS=' || :OLD.status ||', ID_PET=' || :OLD.id_pet,NULL,'CONSULTA');
    
    END IF;
END;
/

-- 1. TESTES FUNCTION 1 - CONSULTA PARA JSON

-- Caso normal
SELECT fn_consulta_json(1) AS consulta_json FROM dual;

-- Excecao: ID invalido
SELECT fn_consulta_json(-1) AS consulta_json FROM dual;

-- Excecao: consulta inexistente
SELECT fn_consulta_json(9999) AS consulta_json FROM dual;

-- 2. TESTES FUNCTION 2 - VALIDACAO DE CPF

-- CPF valido
SELECT fn_validar_cpf('52998224725') AS resultado FROM dual;

-- CPF valido
SELECT fn_validar_cpf('11144477735') AS resultado FROM dual;

-- CPF com digitos verificadores invalidos
SELECT fn_validar_cpf('52998224726') AS resultado FROM dual;

-- Excecao: tamanho invalido
SELECT fn_validar_cpf('12345') AS resultado FROM dual;

-- Excecao: caracteres nao numericos
SELECT fn_validar_cpf('529982247AB') AS resultado FROM dual;

-- Excecao: CPF nao informado
SELECT fn_validar_cpf(NULL) AS resultado FROM dual;

-- 3. TESTES PROCEDURE 1 - CONSULTAS DO PET EM JSON
-- Caso normal
BEGIN
    pr_consulta_pet_json(1);
END;
/
-- Excecao: ID negativo
BEGIN
    pr_consulta_pet_json(-1);
END;
/
-- Excecao: ID zero
BEGIN
    pr_consulta_pet_json(0);
END;
/
-- Excecao: pet inexistente
BEGIN
    pr_consulta_pet_json(9998);
END;
/
-- Outro pet inexistente
BEGIN
    pr_consulta_pet_json(9999);
END;
/
-- 4. TESTE PROCEDURE 2 - RELATORIO NORMAL
BEGIN
    pr_relatorio_leituras;
END;
/
-- 5. TESTE PROCEDURE 2 - EXCECAO DE VALOR NEGATIVO
SELECT l.id_leitura,l.valor,s.tipo 
FROM Leitura l
JOIN Sensor s
    ON l.id_sensor = s.id_sensor
WHERE s.tipo = 'ATIVIDADE';

-- Marca um ponto da transacao
SAVEPOINT antes_teste_negativo;

-- Altera temporariamente uma leitura de atividade
UPDATE Leitura SET valor = -10 WHERE id_leitura = 3;

-- Executa a procedure
BEGIN
    pr_relatorio_leituras;
END;
/

-- Desfaz somente a alteracao de teste
ROLLBACK TO antes_teste_negativo;

-- Confirma que o valor voltou ao normal
SELECT id_leitura,valor FROM Leitura WHERE id_leitura = 3;

-- 6. TESTES DA TRIGGER DE AUDITORIA
-- Antes, confirme que o ID de teste nao existe
SELECT * FROM Consulta WHERE id_consulta = 9999;

-- TESTE INSERT
INSERT INTO Consulta (id_consulta, data_hora,motivo, status,id_pet,id_veterinario,id_clinica)
VALUES ( 9999,SYSDATE,'Teste auditoria','AGENDADA',1,1,1);

-- TESTE UPDATE 1
UPDATE Consulta SET status = 'CANCELADA' WHERE id_consulta = 9999;

--TESTE UPDATE 2
UPDATE Consulta SET status = 'AGENDADA' WHERE id_consulta = 9999;

-- TESTE DELETE
DELETE FROM Consulta WHERE id_consulta = 9999;

SELECT id_auditoria,usuario,operacao,data_operacao,valor_antigo, valor_novo,tabela_afetada FROM Auditoria ORDER BY id_auditoria;
COMMIT;

-- 7. TESTES DO LOG DE ERROS
SELECT id_log_erro, nome_procedure,usuario,data_erro,codigo_erro,mensagem_erro FROM Log_Erro ORDER BY id_log_erro DESC;

-- 8. TESTE EXTRA DO LOG - GERAR NOVO ERRO

SELECT COUNT(*) AS qtd_logs_antes FROM Log_Erro;

-- Gera erro tratado pela Procedure 1
BEGIN
    pr_consulta_pet_json(-10);
END;
/

-- Quantidade depois
SELECT COUNT(*) AS qtd_logs_depois
FROM Log_Erro;

-- Mostra o registro criado
SELECT id_log_erro, nome_procedure,usuario,data_erro,codigo_erro,mensagem_erro FROM Log_Erro ORDER BY id_log_erro DESC;