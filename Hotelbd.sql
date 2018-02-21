create database hotel;

use hotel;

create table pessoa(
	id int auto_increment,
    cpf varchar(200) not null,
    nome varchar(200) not null,
    endereco varchar(200),
    cidade varchar(200),
    uf varchar(5),
    pais varchar(200),
    dt_nascimento date,
    telefone varchar(200),
    primary key (id)
    
);

create table servidor(
    num_carteiraTrabalho varchar(200) not null,
    id_pessoa int,
    primary key(id_pessoa),
    foreign key(id_pessoa) references pessoa(id)
);

create table cliente(
    id_pessoa int,
    profissao varchar(200),
    primary key (id_pessoa),
    foreign key (id_pessoa) references pessoa(id)
);

create table reserva(
	num_reserva int auto_increment,
    id_cliente int,
    id_servidor int,
	dt_reserva timestamp not null,
    primary key (num_reserva),
    foreign key (id_cliente) references cliente(id_pessoa),
    foreign key (id_servidor) references servidor(id_pessoa)
);


create table apartamento(
	 num_apt int ,
     tipo_apartamento varchar(200),
     valor_apt double,
     primary key(num_apt)
);

create table ref_inclu(
	id int ,
    tipo varchar(200),
    valor double,
    primary key(id)
);


create table apartamento_reserva(
	id_apartamento int,
    id_reserva int,
    situacao_reserva boolean,
    valor_total double,
	data_entrada date not null,
    data_saida date not null,
    placa_car varchar(50),
    id_ref int,
    primary key(data_entrada,id_apartamento),
    foreign key(id_ref) references ref_inclu(id),
    foreign key (id_apartamento) references apartamento(num_apt),
    foreign key (id_reserva) references reserva(num_reserva)
);




insert into ref_inclu(id,tipo,valor)
values(0,'Nenhuma',0);

insert into ref_inclu(id,tipo,valor)
values(1,'Meia Pensão',50);


insert into ref_inclu(id,tipo,valor)
values(2,'Pensão Completa',100);

SELECT MAX(id) AS codigo FROM pessoa;

select * from ref_inclu;    

SELECT apartamento.valor_apt from apartamento where num_apt=1;
select valor_total from apartamento_reserva where id_apartamento=1;
SELECT max(apartamento.valor_apt+ref_inclu.valor) from apartamento_reserva inner join ref_inclu on (ref_inclu.id=apartamento_reserva.id_ref)
    inner join apartamento on (apartamento.num_apt=apartamento_reserva.id_apartamento) inner join reserva where (reserva.num_reserva=apartamento_reserva.id_reserva);
drop procedure valor_total;
select pessoa.nome ,pessoa.CPF, servidor.id_pessoa from pessoa inner JOIN servidor where pessoa.id=servidor.id_pessoa;

select reserva.num_reserva, pessoa.nome, pessoa.cpf from pessoa inner join cliente  on(cliente.id_pessoa=pessoa.id) inner join reserva  
on reserva.id_cliente=cliente.id_pessoa;



select apartamento_reserva.situacao_reserva, apartamento_reserva.valor_total,apartamento_reserva.id_reserva as numero_da_reserva, apartamento_reserva.data_entrada, apartamento_reserva.data_saida,
apartamento_reserva.placa_car, apartamento.num_apt, apartamento.tipo_apartamento,pessoa.nome  from apartamento_reserva inner join apartamento on (apartamento_reserva.id_apartamento=apartamento.num_apt)
inner join reserva on(apartamento_reserva.id_reserva=reserva.num_reserva) inner join pessoa on reserva.id_cliente=pessoa.id order by nome;

