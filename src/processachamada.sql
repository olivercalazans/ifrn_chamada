DELIMITER $$

CREATE PROCEDURE processachamada(
    IN container INT,
    IN acao INT,
    IN ipusr VARCHAR(40)
)
BEGIN
    DECLARE retorno INT DEFAULT 0;
    DECLARE mensagem TEXT DEFAULT '';
    DECLARE hoje DATE;
    DECLARE agora TIME;
    DECLARE idAluno INT DEFAULT NULL;
    DECLARE idMateria INT DEFAULT NULL;
    DECLARE siglaTurma VARCHAR(10);
    DECLARE inicioChamada TIME;
    DECLARE fimChamada TIME;
    DECLARE fimTolerancia TIME;
    DECLARE existeEntrada TIME;
    DECLARE existeSaida TIME;

    SET hoje = CURDATE();
    SET agora = CURTIME();

    START TRANSACTION;

    -- Localiza aluno
    SELECT A.idAluno INTO idAluno
    FROM Aluno A
    WHERE A.container = CAST(container AS CHAR)
    LIMIT 1;

    IF idAluno IS NULL THEN
        SET retorno = 99;
        SET mensagem = 'Aluno não encontrado para o container informado.';
        SELECT retorno, mensagem;
        ROLLBACK;
    ELSE

        -- Ação 0: consulta se há aula no horário
        IF acao = 0 THEN
            SELECT
                M.idMateria, D.sigla, M.inicio, M.fim,
                ADDTIME(M.fim, '00:15:00'),
                C.entrada, C.saida
            INTO
                idMateria, siglaTurma, inicioChamada, fimChamada, fimTolerancia,
                existeEntrada, existeSaida
            FROM Chamada C
            JOIN Materia M ON C.Materia_idMateria = M.idMateria
            JOIN Disciplina D ON M.Disciplina_idDisciplina = D.idDisciplina
            WHERE C.data = hoje
              AND C.Aluno_idAluno = idAluno
              AND agora BETWEEN M.inicio AND ADDTIME(M.fim, '00:15:00')
            LIMIT 1;

            IF idMateria IS NULL THEN
                SET retorno = 0;
                SET mensagem = 'Nenhuma aula em andamento encontrada.';
                SELECT retorno, mensagem;
            ELSE
                IF existeEntrada IS NULL THEN
                    SET retorno = 1;
                    SET mensagem = 'Marcação de entrada disponível.';
                ELSEIF existeSaida IS NULL AND agora <= fimTolerancia THEN
                    SET retorno = 2;
                    SET mensagem = 'Marcação de saída disponível.';
                ELSE
                    SET retorno = 0;
                    SET mensagem = 'Aula já registrada ou fora do horário.';
                END IF;

                SELECT retorno, mensagem, siglaTurma AS turmachamada, inicioChamada, fimChamada, fimTolerancia;
            END IF;

            COMMIT;

        -- Ação 1: marcar entrada
        ELSEIF acao = 1 THEN
            UPDATE Chamada C
            JOIN Materia M ON C.Materia_idMateria = M.idMateria
            SET C.entrada = agora
            WHERE C.data = hoje
              AND C.Aluno_idAluno = idAluno
              AND C.entrada IS NULL
              AND agora BETWEEN M.inicio AND M.fim;

            IF ROW_COUNT() > 0 THEN
                SET retorno = 1;
                SET mensagem = 'Entrada registrada com sucesso.';
            ELSE
                SET retorno = 0;
                SET mensagem = 'Erro: entrada não registrada.';
            END IF;

            SELECT retorno, mensagem;
            COMMIT;

        -- Ação 2: marcar saída
        ELSEIF acao = 2 THEN
            UPDATE Chamada C
            JOIN Materia M ON C.Materia_idMateria = M.idMateria
            SET C.saida = agora
            WHERE C.data = hoje
              AND C.Aluno_idAluno = idAluno
              AND C.entrada IS NOT NULL
              AND C.saida IS NULL
              AND agora <= ADDTIME(M.fim, '00:15:00');

            IF ROW_COUNT() > 0 THEN
                SET retorno = 1;
                SET mensagem = 'Saída registrada com sucesso.';
            ELSE
                SET retorno = 0;
                SET mensagem = 'Erro: saída não registrada.';
            END IF;

            SELECT retorno, mensagem;
            COMMIT;

        -- Ação 3: relatório
        ELSEIF acao = 3 THEN
            SELECT
                C.data AS DataAula,
                C.numAulas AS NumAulas,
                CASE DAYOFWEEK(C.data)
                    WHEN 1 THEN 'Domingo'
                    WHEN 2 THEN 'Segunda-feira'
                    WHEN 3 THEN 'Terça-feira'
                    WHEN 4 THEN 'Quarta-feira'
                    WHEN 5 THEN 'Quinta-feira'
                    WHEN 6 THEN 'Sexta-feira'
                    WHEN 7 THEN 'Sábado'
                END AS DiaSemana,
                C.conteudo AS Conteudo,
                M.inicio AS Inicio,
                M.fim AS Fim,
                IF(C.entrada IS NOT NULL, 1, 0) AS Presencas,
                IF(C.entrada IS NULL, 1, 0) AS Faltas,
                0 AS retorno,
                'Relatório gerado com sucesso.' AS mensagem
            FROM Chamada C
            JOIN Materia M ON C.Materia_idMateria = M.idMateria
            WHERE C.Aluno_idAluno = idAluno
            ORDER BY C.data;

            COMMIT;

        -- Ação inválida
        ELSE
            SET retorno = 100;
            SET mensagem = 'Ação não reconhecida.';
            SELECT retorno, mensagem;
            ROLLBACK;
        END IF;

    END IF;

END$$

DELIMITER ;
