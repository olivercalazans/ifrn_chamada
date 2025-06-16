#!/bin/bash

read -p 'Número do container: ' ID
read -sp 'Informe sua senha: ' SENHA
echo ""

mysql -u"CONTAINER0$ID" -p"$SENHA" -h "192.168.102.100" <<EOF

-- Configurações iniciais
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- Criação do schema
CREATE SCHEMA IF NOT EXISTS BD0$ID DEFAULT CHARACTER SET utf8;
USE BD0$ID;

-- Tabela Periodo
CREATE TABLE IF NOT EXISTS Periodo (
  idPeriodo INT NOT NULL AUTO_INCREMENT,
  periodo VARCHAR(6) NOT NULL,
  PRIMARY KEY (idPeriodo)
) ENGINE=InnoDB;

-- Tabela Aluno
CREATE TABLE IF NOT EXISTS Aluno (
  idAluno INT NOT NULL AUTO_INCREMENT,
  matriculaAluno VARCHAR(45) NOT NULL,
  Periodo_idPeriodo INT NOT NULL,
  nomeAluno VARCHAR(45) NOT NULL,
  container VARCHAR(15) NOT NULL,
  PRIMARY KEY (idAluno),
  INDEX fk_Aluno_Periodo1_idx (Periodo_idPeriodo ASC),
  CONSTRAINT fk_Aluno_Periodo1
    FOREIGN KEY (Periodo_idPeriodo)
    REFERENCES Periodo (idPeriodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela Disciplina
CREATE TABLE IF NOT EXISTS Disciplina (
  idDisciplina INT NOT NULL AUTO_INCREMENT,
  nomeDisciplina VARCHAR(50) NOT NULL,
  sigla VARCHAR(10) NOT NULL,
  PRIMARY KEY (idDisciplina)
) ENGINE=InnoDB;

-- Tabela Materia
CREATE TABLE IF NOT EXISTS Materia (
  idMateria INT NOT NULL AUTO_INCREMENT,
  Disciplina_idDisciplina INT NOT NULL,
  Periodo_idPeriodo INT NOT NULL,
  diaSemana INT NOT NULL,
  inicio TIME NULL,
  fim TIME NULL,
  PRIMARY KEY (idMateria),
  INDEX fk_Materia_Disciplina_idx (Disciplina_idDisciplina ASC),
  INDEX fk_Materia_Periodo1_idx (Periodo_idPeriodo ASC),
  CONSTRAINT fk_Materia_Disciplina
    FOREIGN KEY (Disciplina_idDisciplina)
    REFERENCES Disciplina (idDisciplina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Materia_Periodo1
    FOREIGN KEY (Periodo_idPeriodo)
    REFERENCES Periodo (idPeriodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Tabela Chamada
CREATE TABLE IF NOT EXISTS Chamada (
  idChamada INT NOT NULL AUTO_INCREMENT,
  Materia_idMateria INT NOT NULL,
  data DATE NOT NULL,
  conteudo VARCHAR(100) NOT NULL,
  Aluno_idAluno INT NULL,
  entrada TIME NULL,
  saida TIME NULL,
  numAulas INT NOT NULL,
  PRIMARY KEY (idChamada),
  INDEX fk_Chamada_Materia1_idx (Materia_idMateria ASC),
  INDEX fk_Chamada_Aluno1_idx (Aluno_idAluno ASC),
  CONSTRAINT fk_Chamada_Materia1
    FOREIGN KEY (Materia_idMateria)
    REFERENCES Materia (idMateria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Chamada_Aluno1
    FOREIGN KEY (Aluno_idAluno)
    REFERENCES Aluno (idAluno)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- Restaurando configurações
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

EOF
