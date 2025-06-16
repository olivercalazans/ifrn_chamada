#!/bin/bash

read -p 'Número do container: ' ID 
read -sp 'Informe sua senha: ' SENHA
echo ""

mysql -u"CONTAINER0$ID" -p"$SENHA" -h "192.168.102.100" "BD0$ID" <<EOF

-- Tabela Disciplina
INSERT INTO Disciplina(sigla, nomeDisciplina)
SELECT DISTINCT sigladisciplina, nomedisciplina FROM aulas_raw;

-- Tabela Periodo
INSERT INTO Periodo(periodo)
SELECT DISTINCT periodo FROM aulas_raw;

-- Tabela Materia
INSERT INTO BD0$ID.Materia (
  Disciplina_idDisciplina,
  Periodo_idPeriodo,
  diaSemana,
  inicio,
  fim
)
SELECT DISTINCT
  d.idDisciplina,
  p.idPeriodo,
  ar.diaSemana,
  ar.horarioinicio,
  ar.horariofim
FROM
  aulas_raw ar
  INNER JOIN BD0$ID.Disciplina d ON d.nomeDisciplina = ar.nomedisciplina
  INNER JOIN BD0$ID.Periodo p ON p.periodo = ar.periodo;

-- Tabela Aluno
INSERT INTO BD0$ID.Aluno (matriculaAluno, nomeAluno, Periodo_idPeriodo, container )
SELECT DISTINCT ar.matricula, ar.nome, p.idPeriodo, ar.container
FROM aulas_raw ar
INNER JOIN BD0$ID.Periodo p ON p.periodo = ar.periodo
WHERE ar.matricula IS NOT NULL;

-- Tabela Chamada
INSERT INTO BD0$ID.Chamada (
  Materia_idMateria,
  data,
  conteudo,
  Aluno_idAluno,
  entrada,
  saida,
  numAulas
)
SELECT
  (
    SELECT m.idMateria
    FROM BD0$ID.Materia m
    JOIN BD0$ID.Disciplina d ON d.idDisciplina = m.Disciplina_idDisciplina
    JOIN BD0$ID.Periodo p ON p.idPeriodo = m.Periodo_idPeriodo
    WHERE d.sigla = ar.sigladisciplina
      AND p.periodo = ar.periodo
    LIMIT 1
  ),
  ar.data,
  LEFT(ar.conteudo, 45),
  (
    SELECT al.idAluno
    FROM BD0$ID.Aluno al
    JOIN BD0$ID.Periodo p ON p.idPeriodo = al.Periodo_idPeriodo
    WHERE al.matriculaAluno = ar.matricula
      AND al.container = ar.container
      AND p.periodo = ar.periodo
    LIMIT 1
  ),
  TIME(ar.marcacaoentrada),
  TIME(ar.marcacaosaida),
  ar.numaulas
FROM aulas_raw ar
WHERE ar.sigladisciplina IS NOT NULL;

EOF
