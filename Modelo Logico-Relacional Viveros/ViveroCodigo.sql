---------------------------------------------------
-- Table Producto
-- -----------------------------------------------------

START TRANSACTION;

DROP TABLE IF EXISTS Producto ;

CREATE TABLE IF NOT EXISTS Producto (
  Código INT NOT NULL,
  Stock INT NOT NULL,
  Precio FLOAT NOT NULL,
  Nombre VARCHAR(30) NOT NULL,
  PRIMARY KEY (Código))
;


-- -----------------------------------------------------
-- Table Zona
-- -----------------------------------------------------
DROP TABLE IF EXISTS Zona ;

CREATE TABLE IF NOT EXISTS Zona (
  Nombre VARCHAR(30) NOT NULL,
  PRIMARY KEY (Nombre))
;


-- -----------------------------------------------------
-- Table Vivero
-- -----------------------------------------------------
DROP TABLE IF EXISTS Vivero ;

CREATE TABLE IF NOT EXISTS Vivero (
  Localidad VARCHAR(30) NOT NULL,
  Coordendas VARCHAR(45) NOT NULL,
  NombreZona VARCHAR(30) NOT NULL,
  CódigoVivero INT NOT NULL UNIQUE,
  NombreVivero VARCHAR(45) NOT NULL,
  PRIMARY KEY (Coordendas, CódigoVivero),

  CONSTRAINT NombreZona
    FOREIGN KEY (NombreZona)
    REFERENCES Zona (Nombre)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;



-- -----------------------------------------------------
-- Table Cliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS Cliente ;

CREATE TABLE IF NOT EXISTS Cliente (
  DNI INT NOT NULL,
  Bonificación FLOAT NULL,
  GastoMensual FLOAT NULL,
  Nombre VARCHAR(30) NULL,
  PRIMARY KEY (DNI))
;


-- -----------------------------------------------------
-- Table Empleado
-- -----------------------------------------------------
DROP TABLE IF EXISTS Empleado ;

CREATE TABLE IF NOT EXISTS Empleado (
  DNI INT NOT NULL,
  Sueldo INT NOT NULL,
  CSS INT NOT NULL,
  Antigüedad VARCHAR(15) NOT NULL,
  FechaInicio DATE NOT NULL,
  FechaFinal DATE NULL,
  Ventas INT NULL,
  CódigoVivero INT NOT NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT CódigoVivero
    FOREIGN KEY (CódigoVivero)
    REFERENCES Vivero (CódigoVivero)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;



-- -----------------------------------------------------
-- Table Compra
-- -----------------------------------------------------
DROP TABLE IF EXISTS Compra ;

CREATE TABLE IF NOT EXISTS Compra (
  DNICliente INT NOT NULL,
  CódigoProducto INT NOT NULL,
  Cantidad INT NOT NULL,
  Fecha DATE NOT NULL,
  CódigoVivero INT NOT NULL,
  idCompra INT NOT NULL,
  PRIMARY KEY (DNICliente, CódigoProducto, idCompra),
  CONSTRAINT DNICliente
    FOREIGN KEY (DNICliente)
    REFERENCES Cliente (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT CódigoProducto
    FOREIGN KEY (CódigoProducto)
    REFERENCES Producto (Código)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT CódigoVivero
    FOREIGN KEY (CódigoVivero)
    REFERENCES Vivero (CódigoVivero)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

COMMIT;

START TRANSACTION;

INSERT INTO Producto (Código, Stock, Precio, Nombre) VALUES (6723, 139, 1.45, 'Girasoles');
INSERT INTO Producto (Código, Stock, Precio, Nombre) VALUES (5370, 70, 1.20, 'Rosas');
INSERT INTO Producto (Código, Stock, Precio, Nombre) VALUES (4980, 230, 2.50, 'Manzano');
INSERT INTO Producto (Código, Stock, Precio, Nombre) VALUES (3912, 46, 0.70, 'Margaritas');

COMMIT;


-- -----------------------------------------------------
-- Data for table Zona
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO Zona (Nombre) VALUES ('Las Mercedes');
INSERT INTO Zona (Nombre) VALUES ('Adeje');
INSERT INTO Zona (Nombre) VALUES ('Tacoronte');
INSERT INTO Zona (Nombre) VALUES ('El Médano');
INSERT INTO Zona (Nombre) VALUES ('La Orotava');

COMMIT;


-- -----------------------------------------------------
-- Data for table Vivero
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO Vivero (Localidad, Coordendas, NombreZona, CódigoVivero, NombreVivero) VALUES ('San Cristóbal de La Laguna', '120.567', 'Las Mercedes', 3765, 'Flores Antonio');
INSERT INTO Vivero (Localidad, Coordendas, NombreZona, CódigoVivero, NombreVivero) VALUES ('San Isidro', '186.83', 'El Médano', 4892, 'El Jardín de Juan');
INSERT INTO Vivero (Localidad, Coordendas, NombreZona, CódigoVivero, NombreVivero) VALUES ('Tacoronte', '128.356', 'Tacoronte', 6771, 'La flor de Lotto');

COMMIT;


-- -----------------------------------------------------
-- Data for table Cliente
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO Cliente (DNI, Bonificación, GastoMensual, Nombre) VALUES (57987254, 20.67, 30, 'Sergio Pitti');
INSERT INTO Cliente (DNI, Bonificación, GastoMensual, Nombre) VALUES (47484038, 10.43, 15.68, 'Diego Rodríguez');
INSERT INTO Cliente (DNI, Bonificación, GastoMensual, Nombre) VALUES (64829292, 50.80, 73.50, 'Teresa Bonet');
INSERT INTO Cliente (DNI, Bonificación, GastoMensual, Nombre) VALUES (36399282, 17.82, 26.70, 'Antonella García');

COMMIT;


-- -----------------------------------------------------
-- Data for table Empleado
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO Empleado (DNI, Sueldo, CSS, Antigüedad, FechaInicio, FechaFinal, Ventas, CódigoVivero) VALUES (76452313, 1500, 1, '36 Meses', '01-11-2018', NULL, 5982, 3765);
INSERT INTO Empleado (DNI, Sueldo, CSS, Antigüedad, FechaInicio, FechaFinal, Ventas, CódigoVivero) VALUES (56392852, 1700, 2, '10 Meses', '01-11-2018', NULL, 351, 3765);
INSERT INTO Empleado (DNI, Sueldo, CSS, Antigüedad, FechaInicio, FechaFinal, Ventas, CódigoVivero) VALUES (47589393, 1300, 3, '22 Meses', '01-09-2019', NULL, 2559, 6771);
INSERT INTO Empleado (DNI, Sueldo, CSS, Antigüedad, FechaInicio, FechaFinal, Ventas, CódigoVivero) VALUES (57584932, 1800, 4, '4 Meses', '01-07-2021', NULL, 400, 4892);

COMMIT;


-- -----------------------------------------------------
-- Data for table Compra
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO Compra (DNICliente, CódigoProducto, Cantidad, Fecha, CódigoVivero, idCompra) VALUES (57987254, 6723, 10, '01-11-2018', 6771, 345);
INSERT INTO Compra (DNICliente, CódigoProducto, Cantidad, Fecha, CódigoVivero, idCompra) VALUES (64829292, 3912, 30, '01-11-2018', 4892, 357);

COMMIT;

