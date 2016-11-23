CREATE SCHEMA `gas-emissions` ;

CREATE TABLE `gas-emissions`.`h_year` (
  `id_year` INT NOT NULL,
  PRIMARY KEY (`id_year`))
COMMENT = 'years';

INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1990');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1991');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1992');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1993');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1994');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1995');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1996');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1997');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1998');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('1999');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2000');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2001');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2002');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2003');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2004');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2005');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2006');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2007');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2008');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2009');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2010');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2011');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2012');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2013');
INSERT INTO `gas-emissions`.`h_year` (`id_year`) VALUES ('2014');

CREATE TABLE `gas-emissions`.`h_gas` (
  `id_gas` VARCHAR(3) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_gas`));

INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('CH4', 'CH4');
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('CO2', 'CO2');                                              
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('HFC', 'HFCs - (CO2 equivalent)');
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('N2O', 'N2O');                                                
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('NF3', 'NF3 - (CO2 equivalent)');
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('PFC', 'PFCs - (CO2 equivalent)');                            
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('SF6', 'SF6 - (CO2 equivalent)');
INSERT INTO `gas-emissions`.`h_gas` (`id_gas`, `name`) VALUES ('Uns', 'Unspecified mix of HFCs and PFCs - (CO2 equivalent)');

CREATE TABLE `gas-emissions`.`h_country` (
  `id_country` VARCHAR(4) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_country`));

CREATE TABLE `gas-emissions`.`h_sector` (
  `id_sector` VARCHAR(20) NOT NULL,
  `name` VARCHAR(350) NOT NULL,
  PRIMARY KEY (`id_sector`));


ALTER TABLE `gas-emissions`.`h_sector` 
ADD COLUMN `id_ancestor` VARCHAR(20) NULL AFTER `name`;



/*Before, Execute R Which inserts al h_sectors*/

CREATE TABLE `gas-emissions`.`fact_emission` (
  `id_emission` INT NOT NULL AUTO_INCREMENT,
  `quantity` DOUBLE NOT NULL,
  `id_sector` VARCHAR(20) NOT NULL,
  `id_country` VARCHAR(4) NOT NULL,
  `id_gas` VARCHAR(3) NOT NULL,
  `id_year` INT NOT NULL,
  PRIMARY KEY (`id_emission`),
  INDEX `id_sector_idx` (`id_sector` ASC),
  INDEX `id_country_idx` (`id_country` ASC),
  INDEX `id_gas_idx` (`id_gas` ASC),
  INDEX `id_year_idx` (`id_year` ASC),
  CONSTRAINT `id_sector`
    FOREIGN KEY (`id_sector`)
    REFERENCES `gas-emissions`.`h_sector` (`id_sector`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `id_country`
    FOREIGN KEY (`id_country`)
    REFERENCES `gas-emissions`.`h_country` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_gas`
    FOREIGN KEY (`id_gas`)
    REFERENCES `gas-emissions`.`h_gas` (`id_gas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_year`
    FOREIGN KEY (`id_year`)
    REFERENCES `gas-emissions`.`h_year` (`id_year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `gas-emissions`.`sector_relation` (
  `id_sector` VARCHAR(20) NULL,
  `id_ancestor` VARCHAR(20) NULL,
  `distance` INT NULL);

CREATE UNIQUE INDEX sector_closure_pk ON sector_relation (
   id_sector,
   id_ancestor);
CREATE INDEX sector_closure_emp ON sector_relation (
   id_sector);

UPDATE `gas-emissions`.`h_sector` SET `name`='Household sector' WHERE `id_sector`='1.A.4';
UPDATE `gas-emissions`.`h_sector` SET `name`='Other Sectors' WHERE `id_sector`='1.A.5';


DELETE FROM `gas-emissions`.`h_country` WHERE `id_country`='EUA';
DELETE FROM `gas-emissions`.`h_country` WHERE `id_country`='EUC';
UPDATE `gas-emissions`.`h_country` SET `name`='United Kingdom' WHERE `id_country`='UK';


ALTER TABLE `gas-emissions`.`h_country` 
ADD COLUMN `nb_inhabitants` INT NULL AFTER `name`;


/*insert nb_inhabitants in counries*/

UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='8700471' WHERE `id_country`='AT';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='11289853' WHERE `id_country`='BE';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='7153784' WHERE `id_country`='BG';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='8325194' WHERE `id_country`='CH';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='848319' WHERE `id_country`='CY';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='10553843' WHERE `id_country`='CZ';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='82162000' WHERE `id_country`='DE';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='5707251' WHERE `id_country`='DK';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='1315944' WHERE `id_country`='EE';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='46438422' WHERE `id_country`='ES';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='5487308' WHERE `id_country`='FI';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='66661621' WHERE `id_country`='FR';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='10793526' WHERE `id_country`='GR';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`=' 4190669' WHERE `id_country`='HR';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='9830485' WHERE `id_country`='HU';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='4658530' WHERE `id_country`='IE';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='332529' WHERE `id_country`='IS';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='60665551' WHERE `id_country`='IT';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='37622' WHERE `id_country`='LI';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='2888558' WHERE `id_country`='LT';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='576249' WHERE `id_country`='LU';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='1968957' WHERE `id_country`='LV';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='434403' WHERE `id_country`='MT';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='16979120' WHERE `id_country`='NL';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='5213985' WHERE `id_country`='NO';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='37967209' WHERE `id_country`='PL';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='10341330' WHERE `id_country`='PT';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='19759968' WHERE `id_country`='RO';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='9851017' WHERE `id_country`='SE';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='2064188' WHERE `id_country`='SI';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='5426252' WHERE `id_country`='SK';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='78741053' WHERE `id_country`='TR';
UPDATE `gas-emissions`.`h_country` SET `nb_inhabitants`='65341183' WHERE `id_country`='UK';

