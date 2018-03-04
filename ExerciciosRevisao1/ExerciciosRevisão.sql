-- PREENCHA O CABEÇALHO --
-- Nome: Bruno Libardoni
-- Turma: Ciência da Computação
-- Data: 26/02/2018
-- OBS -> Ao enviar o nome do arquivo .sql deve ser alterado para o seu NOME. 
 

use jogos;

INSERT INTO aluno (nome,dataNasc,localidade,)

-- Insira dois novos registros na tabela de aluno;


-- Insira dois novos cenários na tabela Cenario; 


-- Insira um novo monstro e relacione este novo mostro com um novo cenario criado por você (temmonstro)


-- Adicione o nome da rua para a aluna Manuela


-- Insira um volume de 20 para a arma "Sniper"


-- Agora exclua o primeiro aluno adicionado por você, no primeiro exercício. 


-- Exclua também o cenário que você adicionou mas que não foi relacionado com nenhum monstro. 


-- ***************************
--       CONSULTAS
-- ***************************



-- 1 - Liste quais são os alunos que mataram monstros; (ESTA)

select aluno.nome from aluno
JOIN jogador on (aluno.idAluno = jogador.idAluno)
JOIN killMonstro ON (Jogador.idJogador = killMonstro.idMonstro)
ORDER BY aluno.nome;

-- 2 - Liste quais são os alunos que não são jogadores. (ESTA)

select aluno.nome from aluno
WHERE aluno.idAluno not in(select idAluno from jogador);

-- 3 - Liste os alunos que já usaram a arma 'Shotgun' (ESTA)

select aluno.nome from aluno
JOIN jogador ON (aluno.idAluno = jogador.idAluno)
JOIN temArma ON (jogador.idJogador = temArma.idJogador)
JOIN arma ON (temArma.idArma = arma.idArma)
WHERE arma.nome LIKE 'Shotgun';

-- 4 - Faça um select que retorna as munições que são utilizadas pelos jogadores(nome) que fazem mais ou igual a 39 PV de danos e tem peso menor de 60g (ordene-as por peso)
	select distinct municao.nome from municao
    join temMunicao on (municao.idmunicao=temMunicao.idmunicao)
    join jogador on (temMunicao.idJogador=jogador.idJogador)
    where municao.danos>=39 and municao.peso<60 order by municao.peso desc;
-- 5 - Faça um select que retorne qual são os monstros que nunca foram mortos.
	
    select monstro.nome from monstro
    where idMonstro not in (select idMonstro from killMonstro);
    
-- 6 - Liste quais os alunos que já foram mortos pelo menos uma vez. 
    select distinct aluno.nome from aluno
    join jogador on (aluno.idaluno=jogador.idaluno)
    where idJogador not in (select jogMorto from killJogador); 

-- 7 - Qual o nome dos jogadores que mataram a eles próprios?
	select distinct aluno.nome from aluno
    join jogador on (aluno.idaluno=jogador.idaluno)
    join killJogador as kj on (kj.jogmatador=jogador.idjogador)
    where jogador.idJogador=kj.jogmorto;
-- 8 - Faça um select que retorne quais são jogadores que pertencem a uma equipe, mas não entram num round de equipe ('CatchTheFlag' ou 'TeamDeathMatch'). (ESTA)

select aluno.nome from aluno
JOIN jogador ON (aluno.idAluno = jogador.idAluno)
JOIN equipe ON (jogador.idEquipe = equipe.idEquipe)
JOIN partida ON (jogador.idpartida = partida.idpartida)
WHERE partida.tipo not in ('catchTheFlag', 'TeamDeathMatch');


-- 9 - Qual cenário não possui nenhum monstro?

	select cenario.nome from cenario 
    where cenario.idcenario not in (select idCenario from temmonstro);
    

-- 10 - Qual o monstro que não foi morto e a qual cenário ele pertencia? (ESTA)

SELECT monstro.nome as Mostro, cenario.nome as Cenario from monstro
JOIN temmonstro ON (monstro.idMonstro = temmonstro.idMonstro)
JOIN cenario ON (cenario.idCenario = temmonstro.idCenario)
WHERE monstro.idMonstro not in (select idMonstro from killmonstro);

-- 11 - Qual o nome do jogador que matou mais monstros (ESTA)
select distinct aluno.nome from aluno
join jogador on (aluno.idAluno=jogador.idAluno)
join killMonstro as c on (jogador.idjogador=c.idJogador)
where c.idjogador in (select killmonstro.idjogador as a from killmonstro
group by idjogador
having count(idjogador)>1);

-- 12 - Qual foi o cenário que tem a maior quantidade de morte de monstros? 
		select cenario.nome from cenario
        join temmonstro on (cenario.idcenario=temmonstro.idcenario)
        join monstro on (temmonstro.idmonstro=monstro.idmonstro)
        where monstro.idmonstro in (select idmonstro from killmonstro
        group by idmonstro
		having count(idmonstro)>1);
-- 13 - Quais os jogadores que mataram monstros que não pertencem ao cenário do seu round? 
       select aluno.nome from aluno
       join jogador on (aluno.idaluno=jogador.idaluno)
       join killmonstro on (jogador.idjogador=killmonstro.idjogador)
       join partida on (jogador.idpartida=partida.idpartida)
       join cenario on (cenario.idcenario=partida.idcenario)
       join temmonstro on (temmonstro.idcenario=cenario.idcenario)
       where temmonstro.idmonstro not in ( select idmonstro from killmonstro);
       /*falar com a professora*/
-- 14 - Faça um select que apresente os alunos que mataram UM monstro em todas partidas que participaram?  -- DICA USAR HAVING 
		
