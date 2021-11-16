START TRANSACTION;


DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- -----------------------------------------------------
-- Table VIVERO
-- -----------------------------------------------------
DROP TABLE IF EXISTS VIVERO;

CREATE TABLE IF NOT EXISTS VIVERO (
  NOMBRE VARCHAR(30) NOT NULL,
  LOCALIDAD VARCHAR(30) NULL,
  LATITUD FLOAT NULL,
  LONGITUD FLOAT NULL,
  PRIMARY KEY (NOMBRE));


-- -----------------------------------------------------
-- Table ZONA
-- -----------------------------------------------------
DROP TABLE IF EXISTS ZONA;

CREATE TABLE IF NOT EXISTS ZONA (
  NOMBRE VARCHAR(30) NOT NULL,
  VIVERO_NOMBRE VARCHAR(30) NOT NULL,
  PRIMARY KEY (NOMBRE),
  CONSTRAINT fk_ZONA_VIVERO
    FOREIGN KEY (VIVERO_NOMBRE)
    REFERENCES VIVERO (NOMBRE)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table PRODUCTO
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRODUCTO;

CREATE TABLE IF NOT EXISTS PRODUCTO (
  CODIGOPRODUCTO VARCHAR(20) NOT NULL,
  NOMBRE VARCHAR(30) NULL,
  STOCK INT NULL,
  PRECIO FLOAT NULL,
  PRIMARY KEY (CODIGOPRODUCTO));


-- -----------------------------------------------------
-- Table CLIENTE
-- -----------------------------------------------------
DROP TABLE IF EXISTS CLIENTE;

CREATE TABLE IF NOT EXISTS CLIENTE (  
  DNI VARCHAR(9) NOT NULL,
  NOMBRE VARCHAR(30) NOT NULL,
  APELLIDOS VARCHAR(50) NOT NULL,
  BONIFICACION FLOAT NULL,
  TOTAL_MENSUAL INT NULL,
  EMAIL VARCHAR(30),
  MUNICIPIO VARCHAR(50) NOT NULL,
  VIVIENDAS INT,
  PRIMARY KEY (DNI));

-- -----------------------------------------------------
-- Table EMPLEADO
-- -----------------------------------------------------
DROP TABLE IF EXISTS EMPLEADO;

CREATE TABLE IF NOT EXISTS EMPLEADO (
  DNI VARCHAR(9) NOT NULL,
  CSS VARCHAR(12) NULL,
  SUELDO FLOAT NULL,
  ANTIGUEDAD INT NULL,
  FECHA_INI TIMESTAMP NULL,
  FECHA_FIN TIMESTAMP NULL,
  VENTAS INT NULL,
  ZONA_NOMBRE VARCHAR(30) NOT NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT fk_EMPLEADO_ZONA1
    FOREIGN KEY (ZONA_NOMBRE)
    REFERENCES ZONA (NOMBRE)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table PRODUCTO_ZONA
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRODUCTO_ZONA;

CREATE TABLE IF NOT EXISTS PRODUCTO_ZONA (
  ZONA_CODIGOPRODUCTO VARCHAR(20) NOT NULL,
  ZONA_NOMBRE VARCHAR(30) NOT NULL,
  PRIMARY KEY (ZONA_CODIGOPRODUCTO, ZONA_NOMBRE),
  CONSTRAINT fk_PRODUCTO_ZONA_PRODUCTO1
    FOREIGN KEY (ZONA_CODIGOPRODUCTO)
    REFERENCES PRODUCTO (CODIGOPRODUCTO)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_PRODUCTO_ZONA_ZONA1
    FOREIGN KEY (ZONA_NOMBRE)
    REFERENCES ZONA (NOMBRE)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table COMPRA
-- -----------------------------------------------------
DROP TABLE IF EXISTS COMPRA;

CREATE TABLE IF NOT EXISTS COMPRA (
  ZONA_CODIGOPRODUCTO VARCHAR(20) NOT NULL,
  CLIENTE_DNI VARCHAR(9) NOT NULL,
  FECHA TIMESTAMP NOT NULL,
  CANTIDAD INT NULL,
  EMPLEADO_DNI VARCHAR(9) NOT NULL,
  PRIMARY KEY (ZONA_CODIGOPRODUCTO, CLIENTE_DNI, FECHA),
  CONSTRAINT fk_COMPRA_PRODUCTO1
    FOREIGN KEY (ZONA_CODIGOPRODUCTO)
    REFERENCES PRODUCTO (CODIGOPRODUCTO)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_COMPRA_CLIENTE1
    FOREIGN KEY (CLIENTE_DNI)
    REFERENCES CLIENTE (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_COMPRA_EMPLEADO1
    FOREIGN KEY (EMPLEADO_DNI)
    REFERENCES EMPLEADO (DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

COMMIT;

--Disparadaor para comprobar el email
CREATE OR REPLACE FUNCTION crearEmail() returns Trigger AS $email$
    BEGIN
        IF NEW.email IS NULL THEN
            NEW.email := CONCAT(NEW.Nombre, NEW.Apellidos, '@', TG_ARGV[0]);
        ELSIF (NEW.email not like '%@ull.edu.es') THEN
            RAISE EXCEPTION 'El formato del correo no es valido';
        END IF;
    RETURN NEW;
    END
    $email$
    LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS email_trigger ON  cliente;
CREATE  TRIGGER email_trigger BEFORE INSERT ON cliente
FOR EACH ROW EXECUTE PROCEDURE crearEmail('ull.edu.es');

--Disparadaor para comprobar el numero de viviendas
CREATE OR REPLACE FUNCTION comprobar_vivienda() returns Trigger AS   $vivienda$
    BEGIN
 IF NEW.viviendas > 1 THEN 
     RAISE 'ERROR!! No pueden vivir en dos viviendas diferentes en el mismo municipio';
 END IF;
     RETURN NEW;
    END;
    $vivienda$
    LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS comprobar_vivienda_trigger ON  cliente;
CREATE TRIGGER comprobar_vivienda_trigger BEFORE INSERT ON cliente
FOR EACH ROW EXECUTE PROCEDURE comprobar_vivienda();

--Disparadaor para actualizar el stock
CREATE OR REPLACE FUNCTION actualizarStock() returns Trigger AS
    $stock$
    BEGIN     
        UPDATE producto
            SET stock = stock-NEW.cantidad
        WHERE codigoproducto=NEW.zona_codigoproducto;
    RETURN NEW;
    END;
    $stock$
    LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS compraupdate_trigger ON  compra;
CREATE TRIGGER compraupdate_trigger AFTER INSERT ON compra
FOR EACH ROW EXECUTE PROCEDURE actualizarStock();

-- -- -----------------------------------------------------
-- -- Data for table VIVERO
-- -- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO VIVERO (NOMBRE, LOCALIDAD, LATITUD, LONGITUD) VALUES ('Vivero1', 'La Laguna', 167, 83);
  INSERT INTO VIVERO (NOMBRE, LOCALIDAD, LATITUD, LONGITUD) VALUES ('Vivero2', 'Adeje', 98, 293);
  INSERT INTO VIVERO (NOMBRE, LOCALIDAD, LATITUD, LONGITUD) VALUES ('Vivero3', 'Santa Ursula', 172, 628);
COMMIT;


-- -- -----------------------------------------------------
-- -- Data for table ZONA
-- -- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO ZONA (NOMBRE, VIVERO_NOMBRE) VALUES ('Zona1', 'Vivero1');
  INSERT INTO ZONA (NOMBRE, VIVERO_NOMBRE) VALUES ('Zona2', 'Vivero2');
COMMIT;


-- -----------------------------------------------------
-- Data for table PRODUCTO
-- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO PRODUCTO (CODIGOPRODUCTO, NOMBRE, STOCK, PRECIO) VALUES ('1234', 'Margarita', 200, 1.80);
  INSERT INTO PRODUCTO (CODIGOPRODUCTO, NOMBRE, STOCK, PRECIO) VALUES ('5678', 'Rosa', 156, 3.50);
  INSERT INTO PRODUCTO (CODIGOPRODUCTO, NOMBRE, STOCK, PRECIO) VALUES ('3938', 'Clavel', 370, 2.25);
  INSERT INTO PRODUCTO (CODIGOPRODUCTO, NOMBRE, STOCK, PRECIO) VALUES ('2829', 'Tulipan', 90, 4.65);
COMMIT;


-- -----------------------------------------------------
-- Data for table CLIENTE
-- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO CLIENTE (DNI,NOMBRE, APELLIDOS, BONIFICACION, TOTAL_MENSUAL, EMAIL, MUNICIPIO, VIVIENDAS) VALUES ('54678023J', 'Diego', 'Rodriguez', 3, 53, 'diegorodriguez@ull.edu.es','adeje',1);
  INSERT INTO CLIENTE (DNI,NOMBRE, APELLIDOS, BONIFICACION, TOTAL_MENSUAL, EMAIL, MUNICIPIO, VIVIENDAS) VALUES ('57879200P', 'Sergio', 'Pitti', 12, 200, 'sergiopitti@ull.edu.es', 'la laguna',1);
  INSERT INTO CLIENTE (DNI,NOMBRE, APELLIDOS, BONIFICACION, TOTAL_MENSUAL, EMAIL, MUNICIPIO, VIVIENDAS) VALUES ('64639161I', 'Teresa', 'Bonet', 7, 129,NULL,'santa cruz',1);
  INSERT INTO CLIENTE (DNI,NOMBRE, APELLIDOS, BONIFICACION, TOTAL_MENSUAL, EMAIL, MUNICIPIO, VIVIENDAS) VALUES ('51340198F', 'Atonella', 'Perez', 10, 165, NULL,'santa cruz',1);
COMMIT;


-- -- -----------------------------------------------------
-- -- Data for table EMPLEADO
-- -- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO EMPLEADO (DNI, CSS, SUELDO, ANTIGUEDAD, FECHA_INI, FECHA_FIN, VENTAS, ZONA_NOMBRE) VALUES ('59327551K', '198729300174', 1200, 1, '2020-11-01 08:00:00', NULL, 203, 'Zona1');
  INSERT INTO EMPLEADO (DNI, CSS, SUELDO, ANTIGUEDAD, FECHA_INI, FECHA_FIN, VENTAS, ZONA_NOMBRE) VALUES ('42123905L', '630264825283', 1800, 2, '2019-07-01 08:00:00', NULL, 502, 'Zona2');
COMMIT;


-- -- -----------------------------------------------------
-- -- Data for table PRODUCTO_ZONA
-- -- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO PRODUCTO_ZONA (ZONA_CODIGOPRODUCTO, ZONA_NOMBRE) VALUES ('1234', 'Zona1');
  INSERT INTO PRODUCTO_ZONA (ZONA_CODIGOPRODUCTO, ZONA_NOMBRE) VALUES ('3938', 'Zona1');
  INSERT INTO PRODUCTO_ZONA (ZONA_CODIGOPRODUCTO, ZONA_NOMBRE) VALUES ('5678', 'Zona2');
  INSERT INTO PRODUCTO_ZONA (ZONA_CODIGOPRODUCTO, ZONA_NOMBRE) VALUES ('2829', 'Zona2');
COMMIT;


-- -- -----------------------------------------------------
-- -- Data for table COMPRA
-- -- -----------------------------------------------------
START TRANSACTION;
  INSERT INTO COMPRA (ZONA_CODIGOPRODUCTO, CLIENTE_DNI, FECHA, CANTIDAD, EMPLEADO_DNI) VALUES ('1234', '54678023J', '2021-05-17 19:02:21', 14, '59327551K');
  INSERT INTO COMPRA (ZONA_CODIGOPRODUCTO, CLIENTE_DNI, FECHA, CANTIDAD, EMPLEADO_DNI) VALUES ('3938', '54678023J', '2021-05-21 15:42:54', 7, '42123905L');
  INSERT INTO COMPRA (ZONA_CODIGOPRODUCTO, CLIENTE_DNI, FECHA, CANTIDAD, EMPLEADO_DNI) VALUES ('5678', '57879200P', '2021-05-23 11:42:26', 9, '42123905L');
  INSERT INTO COMPRA (ZONA_CODIGOPRODUCTO, CLIENTE_DNI, FECHA, CANTIDAD, EMPLEADO_DNI) VALUES ('2829', '57879200P', '2021-05-23 12:17:40', 25, '59327551K');
COMMIT;