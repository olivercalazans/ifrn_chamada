-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BD061` DEFAULT CHARACTER SET utf8 ;
USE `BD061` ;

-- -----------------------------------------------------
-- Table `mydb`.`Semestre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Semestre` (
  `idSemestre` INT NOT NULL,
  `ano` YEAR NOT NULL,
  `semestre` INT(1) NOT NULL,
  PRIMARY KEY (`idSemestre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Aluno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Aluno` (
  `idAluno` INT NOT NULL,
  `matriculaAluno` VARCHAR(45) NOT NULL,
  `Semestre_idSemestre` INT NOT NULL,
  `nomeAluno` VARCHAR(45) NOT NULL,
  `emailAluno` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAluno`),
  INDEX `fk_Aluno_Semestre1_idx` (`Semestre_idSemestre` ASC),
  CONSTRAINT `fk_Aluno_Semestre1`
    FOREIGN KEY (`Semestre_idSemestre`)
    REFERENCES `mydb`.`Semestre` (`idSemestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Disciplina` (
  `idDisciplina` INT NOT NULL,
  `nomeDisciplina` VARCHAR(45) NOT NULL,
  `sigla` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`idDisciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Materia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Materia` (
  `idMateria` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  `Semestre_idSemestre` INT NOT NULL,
  `inicio` TIME NOT NULL,
  `fim` TIME NOT NULL,
  `diaSemana` INT NOT NULL,
  `numeroAulas` INT NOT NULL,
  PRIMARY KEY (`idMateria`),
  INDEX `fk_Materia_Disciplina_idx` (`Disciplina_idDisciplina` ASC),
  INDEX `fk_Materia_Semestre1_idx` (`Semestre_idSemestre` ASC),
  CONSTRAINT `fk_Materia_Disciplina`
    FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `mydb`.`Disciplina` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_Semestre1`
    FOREIGN KEY (`Semestre_idSemestre`)
    REFERENCES `mydb`.`Semestre` (`idSemestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Chamada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD061`.`Chamada` (
  `idChamada` INT NOT NULL,
  `Materia_idMateria` INT NOT NULL,
  `Aluno_idAluno` INT NOT NULL,
  `feriado_ou_sabado` TINYINT(1) NOT NULL,
  `conteudo` VARCHAR(45) NOT NULL,
  `data` DATE NOT NULL,
  `entrada` TIME NULL,
  `saida` TIME NULL,
  PRIMARY KEY (`idChamada`),
  INDEX `fk_Chamada_Materia1_idx` (`Materia_idMateria` ASC),
  INDEX `fk_Chamada_Aluno1_idx` (`Aluno_idAluno` ASC),
  CONSTRAINT `fk_Chamada_Materia1`
    FOREIGN KEY (`Materia_idMateria`)
    REFERENCES `mydb`.`Materia` (`idMateria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Chamada_Aluno1`
    FOREIGN KEY (`Aluno_idAluno`)
    REFERENCES `mydb`.`Aluno` (`idAluno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
