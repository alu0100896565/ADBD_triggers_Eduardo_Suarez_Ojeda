-- MySQL Script generated by MySQL Workbench
-- Sun Nov 15 13:27:09 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Persona` (
  `DNI` VARCHAR(9) NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `fecha nacimiento` DATETIME NULL,
  `Cabeza familia` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`DNI`),
  INDEX `CabezaFamilia_idx` (`Cabeza familia` ASC) VISIBLE,
  CONSTRAINT `CabezaFamilia`
    FOREIGN KEY (`Cabeza familia`)
    REFERENCES `mydb`.`Persona` (`DNI`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Zona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Zona` (
  `Nombre` VARCHAR(45) NOT NULL,
  `Area` DECIMAL(10) NULL,
  `Concejal` VARCHAR(45) NULL,
  PRIMARY KEY (`Nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Calle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Calle` (
  `Nombre` VARCHAR(45) NOT NULL,
  `Longitud` DECIMAL(10) NULL,
  `tipo` VARCHAR(45) NULL,
  `carriles` INT NULL,
  `Zona` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nombre`),
  INDEX `Zona_idx` (`Zona` ASC) VISIBLE,
  CONSTRAINT `Zona`
    FOREIGN KEY (`Zona`)
    REFERENCES `mydb`.`Zona` (`Nombre`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Construccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Construccion` (
  `Area` DECIMAL(10) NULL,
  `Calle` VARCHAR(45) NOT NULL,
  `Numero` INT NOT NULL,
  `CoordenadasGeograficas` VARCHAR(45) NULL,
  PRIMARY KEY (`Numero`, `Calle`),
  INDEX `Calle_idx` (`Calle` ASC) VISIBLE,
  CONSTRAINT `Calle`
    FOREIGN KEY (`Calle`)
    REFERENCES `mydb`.`Calle` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bloques`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bloques` (
  `NumeroPisos` INT NULL,
  `Area` DECIMAL(10) NULL,
  `Calle` VARCHAR(45) NOT NULL,
  `Numero` INT NOT NULL,
  PRIMARY KEY (`Calle`, `Numero`),
  INDEX `Numero_idx` (`Numero` ASC) VISIBLE,
  CONSTRAINT `Numero`
    FOREIGN KEY (`Numero`)
    REFERENCES `mydb`.`Construccion` (`Numero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Calle`
    FOREIGN KEY (`Calle`)
    REFERENCES `mydb`.`Construccion` (`Calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Piso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Piso` (
  `PlantaYLetra` VARCHAR(6) NOT NULL,
  `area` DECIMAL(10) NULL,
  `Propietario` VARCHAR(9) NULL,
  `Numero` INT NOT NULL,
  `Calle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PlantaYLetra`, `Numero`, `Calle`),
  INDEX `Propietario_idx` (`Propietario` ASC) VISIBLE,
  INDEX `Numero_idx` (`Numero` ASC) VISIBLE,
  INDEX `Calle_idx` (`Calle` ASC) VISIBLE,
  CONSTRAINT `Propietario`
    FOREIGN KEY (`Propietario`)
    REFERENCES `mydb`.`Persona` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Numero`
    FOREIGN KEY (`Numero`)
    REFERENCES `mydb`.`Bloques` (`Numero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Calle`
    FOREIGN KEY (`Calle`)
    REFERENCES `mydb`.`Bloques` (`Calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Unifamiliar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Unifamiliar` (
  `Area` DECIMAL(10) NULL,
  `Propietario` VARCHAR(9) NULL,
  `Numero` INT NOT NULL,
  `Calle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Calle`, `Numero`),
  INDEX `Propietario_idx` (`Propietario` ASC) VISIBLE,
  INDEX `Numero_idx` (`Numero` ASC) VISIBLE,
  CONSTRAINT `Propietario`
    FOREIGN KEY (`Propietario`)
    REFERENCES `mydb`.`Persona` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Numero`
    FOREIGN KEY (`Numero`)
    REFERENCES `mydb`.`Construccion` (`Numero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Calle`
    FOREIGN KEY (`Calle`)
    REFERENCES `mydb`.`Construccion` (`Calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PersonaVivePiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PersonaVivePiso` (
  `DNI` VARCHAR(9) NOT NULL,
  `Numero` INT NULL,
  `PlantaYLetra` VARCHAR(6) NULL,
  `Calle` VARCHAR(45) NULL,
  PRIMARY KEY (`DNI`),
  INDEX `Localizacion_idx` (`Numero` ASC, `PlantaYLetra` ASC, `Calle` ASC) VISIBLE,
  CONSTRAINT `DNI`
    FOREIGN KEY (`DNI`)
    REFERENCES `mydb`.`Persona` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Localizacion`
    FOREIGN KEY (`Numero` , `PlantaYLetra` , `Calle`)
    REFERENCES `mydb`.`Piso` (`Numero` , `PlantaYLetra` , `Calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PersonaViveUnifamiliar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PersonaViveUnifamiliar` (
  `DNI` VARCHAR(9) NOT NULL,
  `Numero` INT NULL,
  `Calle` VARCHAR(45) NULL,
  PRIMARY KEY (`DNI`),
  INDEX `Localizacion_idx` (`Numero` ASC, `Calle` ASC) VISIBLE,
  CONSTRAINT `DNI`
    FOREIGN KEY (`DNI`)
    REFERENCES `mydb`.`Persona` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Localizacion`
    FOREIGN KEY (`Numero` , `Calle`)
    REFERENCES `mydb`.`Unifamiliar` (`Numero` , `Calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `mydb`;

DELIMITER $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`PersonaVivePiso_BEFORE_INSERT` BEFORE INSERT ON `PersonaVivePiso` FOR EACH ROW
BEGIN
	IF (NEW.DNI IN (SELECT DNI
		FROM PersonaViveUnifamiliar)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid data';
    END IF;
END$$

USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`PersonaViveUnifamiliar_BEFORE_INSERT` BEFORE INSERT ON `PersonaViveUnifamiliar` FOR EACH ROW
BEGIN
	IF (NEW.DNI IN (SELECT DNI
		FROM PersonaVivePiso)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid data';
    END IF;
END$$


DELIMITER ;
