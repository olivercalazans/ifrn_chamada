-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema BD061
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BD061` DEFAULT CHARACTER SET utf8 ;
USE `BD061` ;

-- -----------------------------------------------------
-- Table `BD061`.`Aluno_v2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Aluno_v2` (
  `idAluno` INT NOT NULL AUTO_INCREMENT,
  `matriculaAluno` VARCHAR(45) NOT NULL,
  `nomeAluno` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAluno`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `BD061`.`Incritos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Incritos` (
  `idIncritos` INT NOT NULL,
  `Materia_idMateria` INT NOT NULL,
  `Aluno_idAluno` INT NOT NULL,
  `container` INT NOT NULL,
  PRIMARY KEY (`idIncritos`),
  INDEX `fk_Incritos_Aluno1_idx` (`Aluno_idAluno` ASC),
  INDEX `fk_Incritos_Materia1_idx` (`Materia_idMateria` ASC),
  CONSTRAINT `fk_Incritos_Aluno1`
    FOREIGN KEY (`Aluno_idAluno`)
    REFERENCES `BD061`.`Aluno_v2` (`idAluno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Incritos_Materia1`
    FOREIGN KEY (`Materia_idMateria`)
    REFERENCES `BD061`.`Materia` (`idMateria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `BD061`.`Chamada_v2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Chamada_v2` (
  `idChamada` INT NOT NULL AUTO_INCREMENT,
  `Incritos_idIncritos` INT NOT NULL,
  `data` DATE NOT NULL,
  `conteudo` VARCHAR(100) NOT NULL,
  `entrada` TIME NULL,
  `saida` TIME NULL,
  `numAulas` INT NOT NULL,
  PRIMARY KEY (`idChamada`),
  INDEX `fk_Chamada_Incritos1_idx` (`Incritos_idIncritos` ASC),
  CONSTRAINT `fk_Chamada_Incritos1`
    FOREIGN KEY (`Incritos_idIncritos`)
    REFERENCES `BD061`.`Incritos` (`idIncritos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- OBS: As tabelas Disciplina, Periodo e Materia já existem e não serão recriadas.

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
