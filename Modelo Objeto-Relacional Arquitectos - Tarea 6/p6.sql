

START TRANSACTION;

CREATE TABLE figura (
  cod_figura integer NOT NULL,
  nombre varchar NOT NULL,
  color varchar NOT NULL,
  cod_plano integer NOT NULL
) ;

CREATE TABLE jefeProyecto (
  cod_jefeProyecto integer NOT NULL,
  nombre varchar NOT NULL,
  direccion varchar NOT NULL,
  telefono integer NOT NULL,
  cod_proyecto integer DEFAULT NULL
) ;


CREATE TABLE linea (
  id_linea integer NOT NULL,
  longitud integer NOT NULL,
  puntos integer NOT NULL
) ;



CREATE TABLE plano (
  cod_plano integer NOT NULL,
  fecha_entrega date NOT NULL,
  arquitectos varchar NOT NULL,
  dibujo_plano integer ,
  num_figuras integer DEFAULT NULL
) ;


CREATE TABLE poligono (
  num_lineas integer NOT NULL,
  id_linea integer DEFAULT NULL
) ;

CREATE TABLE proyecto (
  cod_proyecto integer NOT NULL,
  nombre varchar NOT NULL,
  cod_jefeProyecto integer NOT NULL,
  cod_plano integer NOT NULL
) ;


CREATE TABLE relacionLineaPoligono (
  id_linea integer NOT NULL,
  num_lineas integer NOT NULL
) ;


ALTER TABLE figura
  ADD constraint PRIMARY KEY (cod_figura),
  ADD constraint UNIQUE KEY cod_plano_2 (cod_plano),
  ADD constraint KEY cod_plano (cod_plano);


ALTER TABLE jefeProyecto
  ADD PRIMARY KEY (cod_jefeProyecto),
  ADD KEY cod_proyecto (cod_proyecto);


ALTER TABLE linea
  ADD PRIMARY KEY (id_linea);


ALTER TABLE plano
  ADD PRIMARY KEY (cod_plano),
  ADD KEY num_figuras (num_figuras);


ALTER TABLE poligono
  ADD PRIMARY KEY (num_lineas),
  ADD KEY id_linea (id_linea);


ALTER TABLE proyecto
  ADD PRIMARY KEY (cod_proyecto),
  ADD UNIQUE KEY cod_jefeProyecto_2 (cod_jefeProyecto),
  ADD KEY cod_jefeProyecto (cod_jefeProyecto,cod_plano),
  ADD KEY plano (cod_plano);


ALTER TABLE relacionLineaPoligono
  ADD PRIMARY KEY (id_linea,num_lineas),
  ADD KEY id_linea (id_linea,num_lineas),
  ADD KEY poligono (num_lineas);


ALTER TABLE jefeProyecto
  ADD CONSTRAinteger jefeproyecto_ibfk_1 FOREIGN KEY (cod_jefeProyecto) REFERENCES proyecto (cod_jefeProyecto) ON DELETE NO ACTION ON UPDATE NO ACTION;


ALTER TABLE linea
  ADD CONSTRAinteger linea_ibfk_1 FOREIGN KEY (id_linea) REFERENCES relacionLineaPoligono (id_linea) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE plano
  ADD CONSTRAinteger plano_ibfk_1 FOREIGN KEY (cod_plano) REFERENCES figura (cod_plano) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE proyecto
  ADD CONSTRAinteger jefe FOREIGN KEY (cod_jefeProyecto) REFERENCES jefeProyecto (cod_jefeProyecto) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAinteger plano FOREIGN KEY (cod_plano) REFERENCES plano (cod_plano) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE relacionLineaPoligono
  ADD CONSTRAinteger linea FOREIGN KEY (id_linea) REFERENCES linea (id_linea) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAinteger poligono FOREIGN KEY (num_lineas) REFERENCES poligono (num_lineas) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;

START TRANSACTION;
INSERT INTO `figura` (`cod_figura`, `nombre`, `color`, `cod_plano`) VALUES ('1', 'circulo', 'amarillo', '2'), ('2', 'corazon', 'rojo', '3');
INSERT INTO `plano` (`cod_plano`, `fecha_entrega`, `arquitectos`, `dibujo_plano`, `num_figuras`) VALUES ('2', '2022-01-11', 'Adrián\r\nCarles\r\nJosé', 6, '2');
INSERT INTO `plano` (`cod_plano`, `fecha_entrega`, `arquitectos`, `dibujo_plano`, `num_figuras`) VALUES ('3', '2022-01-11', 'Juan Maria y Carles', '4', '4');
INSERT INTO `jefeProyecto` (`cod_jefeProyecto`, `nombre`, `direccion`, `telefono`, `cod_proyecto`) VALUES ('1', 'Juan Carlos', 'Calle radazul 78', '788778877', '1');
INSERT INTO `linea` (`id_linea`, `longitud`, `puntos`) VALUES ('1', '3', '2'), ('2', '2', '3');
INSERT INTO `poligono` (`num_lineas`, `id_linea`) VALUES ('3', '2'), ('2', '3');
INSERT INTO `proyecto` (`cod_proyecto`, `nombre`, `cod_jefeProyecto`, `cod_plano`) VALUES ('1', 'En Valencia', '1', '2');
INSERT INTO `relacionLineaPoligono` (`id_linea`, `num_lineas`) VALUES ('2', '2'), ('3', '2');
COMMIT;