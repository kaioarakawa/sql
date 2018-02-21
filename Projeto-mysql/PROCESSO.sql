create database PROCESSO;

use PROCESSO;

CREATE TABLE etnia(
  	id int not null auto_increment,
    descricao varchar(200),
    primary key (id)
    );
    
    
CREATE TABLE pessoa (
    id_etnia int,
    escolaridade varchar(200),
    cpf BIGINT not null,
    sexo enum('F','M','ND'),
    emissor_rg VARCHAR(200),
    rg BIGINT,
    nome VARCHAR(200),
    nome_pai VARCHAR(200),
	nome_mae VARCHAR(200),
    data_nascimento date,
    primary key (cpf),
    foreign key(id_etnia) references etnia(id)
    
);

CREATE TABLE nacionalidade(
	id int not null auto_increment,
    pais varchar(200) default 'brasileira',
    primary key (id)
 );

CREATE TABLE estado (
	id int not null auto_increment,
    uf char(2),
    id_nacionalidade int,
    primary key(id),
    foreign key (id_nacionalidade) references nacionalidade(id)
);


 CREATE TABLE cidade(
	id int not null auto_increment,
	id_estado int,
    nome varchar(200),
    primary key (id),
    foreign key (id_estado) references estado(id)
 );

 
 CREATE TABLE endereco(
	id int not null auto_increment,
    rua varchar(200),
    id_cidade int,
    id_pessoa bigint,
    primary key(id),
    foreign key (id_pessoa) references pessoa(cpf),
	foreign key (id_cidade) references cidade(id)
 );


CREATE TABLE telefones(
	id int not null auto_increment,
	telefone bigint,
    id_pessoa bigint,
    foreign key(id_pessoa) references pessoa(cpf),
    primary key(id,id_pessoa)
	);
    
CREATE TABLE necessidades(
	id int not null auto_increment,
    tipo varchar(200),
    primary key (id)
    );
    
    CREATE TABLE necessidades_pessoa(
	id_pessoa bigint not null,
	id_necessidades int not null,
	primary key(id_pessoa,id_necessidades),
	foreign key(id_pessoa) references pessoa(cpf),
	foreign key(id_necessidades) references necessidades(id)
);

    
    CREATE TABLE contaUsuario(
    ativo boolean,
    data_cadastro datetime,
    ultima_atualizacao timestamp,
    id_pessoa bigint not null,
	foreign key(id_pessoa) references pessoa(cpf)
    );
    
    CREATE TABLE cargo(
    id integer not null auto_increment,
    descricao varchar(200),
    primary key(id)
    );
    
    CREATE TABLE aplicador (
    id int not null auto_increment,
    id_cargo int,
    id_pessoa bigint,
    primary key(id),
    foreign key(id_cargo) references cargo(id),
    foreign key(id_pessoa) references pessoa(cpf)
    );
    
	CREATE TABLE categoria(
    id int not null auto_increment,
    descricao varchar(200),
    primary key(id)
    );
    
    CREATE TABLE processoSeletivo(
    id int not null auto_increment,
    id_categoria int,
    ano year,
    semestre enum('1','2'),
    nome varchar(200),
    inicio_de_inscricao date,
    fim_de_inscricao date,
    fim_pagamento date,
    valor_taxa decimal(5,2) unsigned,
    primary key (id),
    foreign key (id_categoria) references categoria(id)
    );
    
	CREATE TABLE aplicador_processoseletivo(
    id_aplicador int not null,
    id_processoseletivo int not null,
    primary key(id_aplicador,id_processoseletivo),
    foreign key(id_aplicador) references aplicador(id),
    foreign key(id_processoseletivo) references processoseletivo(id)
    );
    
    CREATE TABLE cotas(
    id int not null auto_increment,
    descricao varchar(200),
    primary key(id)
    );
    
    CREATE TABLE escolaridade(
    id int not null auto_increment,
    descricao_escola varchar(200),
    primary key(id)
    );
    
    CREATE TABLE curso(
    id int not null auto_increment,
    nome_curso varchar(200),
    primary key(id)
    
    );
    
    
	CREATE TABLE tipo_tec(
    id int not null auto_increment,
    descricao varchar(200),
    primary key(id)
    );
    
    CREATE TABLE tecnico(
	id_tec int,
    id int not null auto_increment,
    id_curso int,
    primary key(id),
    foreign key(id_tec) references tipo_tec(id),
    foreign key(id_curso) references curso(id)
	);
    

    

    CREATE TABLE superior(
    id int not null auto_increment,
    id_curso int,
    primary key(id),
    foreign key (id_curso) references curso(id)
    );
    
    
    CREATE TABLE areas(
    id int not null auto_increment,
    descricao varchar(200),
    primary key(id)
    );
    
    
	CREATE TABLE participa_ProcessoSeletivo(
    id int not null auto_increment,
    id_pessoa bigint,
    id_processoSeletivo int not null,
    id_curso int not null,
    id_curso2 int default null,
    id_cota int default null,
    id_escolaridade int,
    media_final double,
    data_inscricao datetime,
    pagou_taxa boolean,
    primary key(id),
    foreign key(id_pessoa) references pessoa(cpf),
    foreign key(id_processoSeletivo) references processoSeletivo(id),
    foreign key(id_curso) references curso(id),
	foreign key(id_curso2) references curso(id),
    foreign key(id_cota) references cotas(id),
    foreign key(id_escolaridade) references escolaridade(id)
    );
    
	CREATE TABLE areas_pontua(
    id_areas int,
    id_participa int,
    nota int,
    primary key(id_areas,id_participa),
    foreign key(id_areas) references areas(id),
    foreign key(id_participa) references participa_ProcessoSeletivo(id)
    );
    
    
        DELIMITER //
    
    CREATE TRIGGER curso_sem_igual BEFORE INSERT ON participa_ProcessoSeletivo for each ROW
        BEGIN
		IF(new.id_curso = new.id_curso2) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ops! Esse curso ja esta cadastrado no curso primario';
        END IF;
    END//
    DELIMITER ;
    
    
    
    DELIMITER $$
    
    CREATE TRIGGER disjunct_curso BEFORE INSERT ON tecnico for each ROW
        BEGIN
		IF((SELECT COUNT(*) from SUPERIOR WHERE id_curso = new.id_curso) > 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ops! Essa pessoa já está cadastrada no curso superior';
        END IF;
    END$$
    
    
    
    DELIMITER ;
    
        DELIMITER &&
    
    CREATE TRIGGER disjunct_cursosu BEFORE INSERT ON superior for each ROW
        BEGIN
		IF((SELECT COUNT(*) from TECNICO WHERE id_curso = new.id_curso) > 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ops! Essa pessoa já está cadastrada no curso tecnico';
        END IF;
    END&&
    DELIMITER ;
    
    
    
    DELIMITER \\
    CREATE PROCEDURE media_final ()
    BEGIN
    
    UPDATE participa_ProcessoSeletivo SET media_final = (SELECT sum(notas) FROM areas_pontua as a join participa_ProcessoSeletivo as p WHERE a.id_participa = p.id) / (SELECT count(*) FROM areas);
    
    END \\
    
    DELIMITER ;
    
     insert into etnia(id,descricao)
     values (null,'japonesa'),(null,'brasileira');
    
    insert into pessoa
    values (1,'médio completo',454545,'M','SSP',54657,'Kaio','Helena','Raulino','1999-04-15'),
    (2,'médio completo',2525,'F','SP',578,'Halyson','Eliete','Halyson','1998-12-31');
    
    
    insert into nacionalidade values
    (null,'brasil'),
    (null,'japones');
    
    insert into estado values 
    (null,'sp',1) ,(null,'sc',2);
    
    insert into cidade values
    (default,1,'brotas'),(default,2,'treze tillias');
    insert into endereco values
    (null,'jose',1,454545),(null,'limao',2,2525);
    insert into telefones values
    (null,454654,454545),(null,454654,2525);
    insert into necessidades values
    (null,'raquitico');
    insert into necessidades_pessoa values
    (2525,1);
    
    insert into contaUsuario values
    (true,now(),now(),454545),(true,now(),now(),2525);
    insert into cargo values
    (1,'porteiro especial');
    insert into aplicador values
    (null,1,454545);
    insert into categoria values
    (null,'superior');
    insert into processoSeletivo values
    (null,1,2016,2,'IFC sup','2016-02-15','2016-03-15','2016-03-20',250.00);
    insert into aplicador_processoseletivo values
    (1,1);
    insert into cotas values
    (null,'asiatico');
    insert into escolaridade values
    (null,'medio completo');
    insert into curso values
    (null, 'marceneiro'),
    (null, 'computação');
    insert into tipo_tec values
    (null,'tecnico em marcenaria');
    insert into tecnico values
    (1,null,1);
    insert into superior values
     (null,2);
    insert into areas values
    (null,'matematica'),(null,'geo');
    insert into participa_ProcessoSeletivo values
    (1,2525,1,1,null,1,1,null,now(),true);
    insert into areas_pontua values
    (1,1,10),(2,1,5);
    
    /*Dados Das Pessoas com a Idade*/
    select 
		*,
        FLOOR(datediff(now(),data_nascimento)/360) as idade
        from pessoa;
     /*Quantidades de pessoas Inscritas*/
    select COUNT(*) AS quantidades_candidatos from participa_ProcessoSeletivo;
    
     /*Quantidades de pessoas Inscritas*/
    select COUNT(*) AS quantidades_aplicadores from aplicador_processoseletivo;
    
    /*Pessoas Inscritas e curso escolhido*/
	select pp.id_pessoa as CPF,pp.data_inscricao, if(pp.pagou_taxa,'sim','não') as pagou_taxa, c.nome_curso from participa_ProcessoSeletivo as pp
    INNER JOIN curso as c where pp.id_curso=c.id;
    
    show triggers;