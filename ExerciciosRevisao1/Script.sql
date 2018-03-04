
create database jogos;
use jogos;


create table cenario
(
   idCenario integer auto_increment PRIMARY KEY, 
   nome char(30),
   tipo varchar(15) NOT NULL, -- floresta, citadino, etc
   dimensao char(15) NOT NULL -- string tipo compxlarg
);

create table jogo
(
   idJogo integer PRIMARY KEY,
   datahora timestamp not null default now()
);
   
create table partida
(
   idpartida integer auto_increment primary key,
   datahora timestamp not null default now(),  
   tipo varchar(15) NOT NULL check (tipo in ('CatchTheFlag','TeamDeathMatch','KillAll')), 
   idJogo integer NOT NULL references jogo(idJogo) on delete cascade,
   idCenario integer NOT NULL references cenario(idCenario) on delete set null
);

create table monstro
(
   idMonstro integer auto_increment PRIMARY KEY, 
   nome char(30) ,
   danos smallint NOT NULL,
   tipoAtaque char(15) NOT NULL, -- contundente, arma, etc
   energia smallint NOT NULL -- Pontos de vida, energia
);

create table equipe
(
   idequipe integer auto_increment PRIMARY KEY,
   nome varchar(40) NOT NULL unique
);

create table aluno
(
   idAluno char(10) PRIMARY KEY,
   nome varchar(60) NOT NULL,
   dataNasc date,
   localidade varchar(50),
   rua varchar(50),
   numeroPorta varchar(15) -- 5 Esq      
);

create table jogador
(
   idJogador serial PRIMARY KEY,
   catchTheFlag bool,
   idAluno char(10) NOT NULL,
   idequipe integer,
   idpartida integer NOT NULL,  
   
   FOREIGN KEY (idequipe)  REFERENCES equipe(idequipe),
   FOREIGN KEY (idAluno) REFERENCES aluno(idAluno),
   FOREIGN KEY (idpartida) REFERENCES partida(idpartida),

   CONSTRAINT flag_on_equip check ( (catchTheFlag is not NULL and equipe is not NULL)
         OR (catchTheFlag is NULL))
         -- se catchFlag for verdadeiro ou falso a equipe tem de ser não NULO
);


create table arma
(
   idArma integer auto_increment PRIMARY KEY, 
   nome char(20) ,
   alcance smallint NOT NULL,
   volume smallint,
   peso float,
   danos smallint NOT NULL
);

create table municao
(
   idMunicao integer auto_increment PRIMARY KEY,
   nome char(20), 
   tipo char(10) NOT NULL check (tipo in
      ('Explosivo','Impacto','Perfurante','Cortante','Laser','Gás','Queima')),
   volume smallint,
   peso float,
   danos smallint NOT NULL,
   idArma integer, 
   FOREIGN KEY (idArma) references arma(idArma) on delete cascade
);

-- ***************************
--       Relacionamentos
-- ***************************
create table temmonstro
(
   idCenario integer references cenario(idCenario) on delete cascade,
   idMonstro integer references monstro(idMonstro) on delete cascade,
   PRIMARY KEY (idCenario, idMonstro)
);

create table killmonstro
(
   idJogador integer references jogador(idJogador) on delete cascade,
   idMonstro integer references monstro(idMonstro) on delete cascade,
   PRIMARY KEY (idJogador, idMonstro)
);

create table killJogador
(
   jogMatador integer references jogador(idJogador) on delete cascade,
   jogMorto integer references jogador(idJogador) on delete cascade,
   PRIMARY KEY (jogMatador, jogMorto)
);

create table temArma
(
   idJogador integer references jogador(idJogador) on delete cascade,
   idArma integer references arma(idArma) on delete cascade,
   PRIMARY KEY (idJogador, idArma)
);

create table temMunicao
(
   idJogador integer references jogador(idJogador) on delete cascade,
   idMunicao integer references municao(idMunicao) on delete cascade,
   PRIMARY KEY (idJogador, idMunicao)
);

   

   

/*delete from temmunicao;
delete from municao;
delete from temmonstro;
delete from killJogador;
delete from temarma;
delete from arma;
delete from killmonstro;
delete from monstro;
delete from jogador;
delete from equipe;
delete from round;
delete from jogo;
delete from cenario;
delete from aluno;*/



--      Alunos
-- ***************
insert into aluno (idAluno,nome, dataNasc, localidade,rua,numeroporta) values
('030307001', 'João Chico',     '1985-12-12', '', '', ''), 
('030316001', 'Vera Moniz',	    '1983-1-1',	 'GAIA','', ''),
('030310001', 'João Marco',	    '1983-5-1',	 'GAIA','', ''),
('999999999', 'Raquel Gago',    '1980-2-16', 'Porto','', ''),
('030306001', 'Luís Bicudo',    '1982-5-16', 'Matosinhos','', ''),
('030370001', 'Joana Ferreira',	'1985-8-23',  '','Barão do Corvo', ''),
('030307002', 'Pedro Molo',	    '1983-2-22', '','', ''),
('030316002', 'Luísa Barata',   '1984-6-1', 'GAIA'	, '', ''),
('666666666', 'Rui Morongo',	'1981-4-26', 'Porto', '', ''),
('030306002', 'Manuela Bicudo', '1982-5-16', 'Matosinhos', '', ''),
('030370002', 'Carla Ferreira',	'1986-9-13', '', 'Barão do Corvo', ''),
('030310002', 'Kirina Brandt',  '1984-9-13', 'Arcozelo', '', '');


--  Cenarios
-- **********
-- cenario(id, nome,tipo,dimensao)
insert into cenario values(null, 'Krimeia','Ruínas','1500x1300');
insert into cenario values(null, 'NY Gheto','Urbano','2500x2300');
insert into cenario values(null, 'Amazon','Floresta','2000x2000');



--  Jogos
-- *******
insert into jogo values (1,now()); 
insert into jogo values (2,'2004-10-21 10:30'); 
insert into jogo values (3,'2004-11-1 22:30'); 
insert into jogo values (4,'2004-9-10 00:30');
insert into jogo values (5,'2004-8-16 03:30');

--   partida
-- *********
insert into partida(datahora,idJogo,idCenario,tipo) 	values 
	('2004-9-10 01:00',  4, 3, 'KillAll'), 
	('2004-10-21 10:30', 2,	1, 'KillAll'),
	('2004-10-21 11:00', 2,	1, 'KillAll'),
	('2004-10-21 11:30', 2,	3, 'CatchTheFlag'),
	('2004-11-1 22:30',	 3,	3, 'KillAll'),
	('2004-8-16 04:00',	 5,	2, 'TeamDeathMatch');


--  equipes
-- *********
insert into equipe(nome) values('TheKongs');
insert into equipe(nome) values('UltimateDeath');
insert into equipe values(12,'Supremes');
insert into equipe values(22,'TheIncredibles');


--  Jogadores
-- ************
insert into jogador(idAluno,idpartida) values ('030310002',5);
insert into jogador(idAluno,idpartida) values ('030316002',4);
insert into jogador(idAluno,idpartida) values ('030316002',5);
insert into jogador(idAluno,idpartida) values ('030307001',4);
insert into jogador(idAluno,idpartida) values ('030307001',6);
insert into jogador(idJogador,idAluno,idpartida,idequipe) values (132,'999999999',3,22);
insert into jogador(idJogador,idAluno,idpartida,idequipe) values (142,'666666666',4,12);
insert into jogador(idJogador,idAluno,idpartida) values (152,'030316002',4);



insert into monstro (nome, danos, tipoAtaque, energia) values
('EYE', 30, 'Contundente', 150),
('Berserker', 10, 'Arma', 40),
('Bear',10, 'Contundente', 60),
('Zombie', 25, 'Cortante', 35);


--  TemMonstro
-- ************
insert into temmonstro (idCenario, idMonstro) values
	(1, 1), 
    (1, 2), 
    (3, 3), 
    (3, 4);

--  KillMonstro
-- *************
insert into killmonstro values(132,1);
insert into killmonstro values(132,2);
insert into killmonstro values(142,2);
insert into killmonstro values(152,3);

--   Armas
-- ********
insert into arma (nome, alcance, volume, peso, danos) values 
	('Shotgun', 10, null, 3.5, 45), 
	('Laser', 100, null, 2.0, 100),
	('Sniper', 300, null, 4.9, 100), 
	('P226357SIG', 50, null, 0.9, 10),
	('MA9221', 15, null, 2.9, 30);


--  Temarma
-- *********
insert into temarma values(132, 1);
insert into temarma values(142, 1);
insert into temarma values(142, 2);
insert into temarma values(132, 3);

--  Municoes
-- **********
insert into  municao (nome, tipo, volume, peso, danos, idArma) values 
	('Shells', 'Impacto', null, 45, 40, 1), 
	('ExpShells', 'Explosivo', null, 60, 65, 1), 
	('223Remington', 'Perfurante', null, 55, 70, 3), 
	('M1A.308', 'Impacto', null, 48, 35, 5);


--  TemMunicao
-- ************
insert into temmunicao values 
	(132, 1), 
	(142, 2), 
	(152, 3),
	(142, 3);


--  KillJogador
-- *************
insert into KillJogador values(132,142);
insert into KillJogador values(142,142);
insert into KillJogador values(142,132);
insert into KillJogador values(152,132);


-- Referência. FERREIRA, Michel. 2005. FCUP. 
