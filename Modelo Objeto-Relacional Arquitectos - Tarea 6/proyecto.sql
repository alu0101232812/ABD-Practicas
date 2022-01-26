-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 26-01-2022 a las 17:17:43
-- Versión del servidor: 10.4.21-MariaDB
-- Versión de PHP: 8.0.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `figura`
--

CREATE TABLE `figura` (
  `cod_figura` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `color` text NOT NULL,
  `cod_plano` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jefeProyecto`
--

CREATE TABLE `jefeProyecto` (
  `cod_jefeProyecto` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `direccion` text NOT NULL,
  `telefono` int(11) NOT NULL,
  `cod_proyecto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `linea`
--

CREATE TABLE `linea` (
  `id_linea` int(11) NOT NULL,
  `longitud` int(11) NOT NULL,
  `puntos` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plano`
--

CREATE TABLE `plano` (
  `cod_plano` int(11) NOT NULL,
  `fecha_entrega` date NOT NULL,
  `arquitectos` text NOT NULL,
  `dibujo_plano` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`dibujo_plano`)),
  `num_figuras` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `poligono`
--

CREATE TABLE `poligono` (
  `num_lineas` int(11) NOT NULL,
  `id_linea` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `cod_proyecto` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `cod_jefeProyecto` int(11) NOT NULL,
  `cod_plano` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relacionLineaPoligono`
--

CREATE TABLE `relacionLineaPoligono` (
  `id_linea` int(11) NOT NULL,
  `num_lineas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `figura`
--
ALTER TABLE `figura`
  ADD PRIMARY KEY (`cod_figura`),
  ADD UNIQUE KEY `cod_plano_2` (`cod_plano`),
  ADD KEY `cod_plano` (`cod_plano`);

--
-- Indices de la tabla `jefeProyecto`
--
ALTER TABLE `jefeProyecto`
  ADD PRIMARY KEY (`cod_jefeProyecto`),
  ADD KEY `cod_proyecto` (`cod_proyecto`);

--
-- Indices de la tabla `linea`
--
ALTER TABLE `linea`
  ADD PRIMARY KEY (`id_linea`);

--
-- Indices de la tabla `plano`
--
ALTER TABLE `plano`
  ADD PRIMARY KEY (`cod_plano`),
  ADD KEY `num_figuras` (`num_figuras`);

--
-- Indices de la tabla `poligono`
--
ALTER TABLE `poligono`
  ADD PRIMARY KEY (`num_lineas`),
  ADD KEY `id_linea` (`id_linea`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`cod_proyecto`),
  ADD UNIQUE KEY `cod_jefeProyecto_2` (`cod_jefeProyecto`),
  ADD KEY `cod_jefeProyecto` (`cod_jefeProyecto`,`cod_plano`),
  ADD KEY `plano` (`cod_plano`);

--
-- Indices de la tabla `relacionLineaPoligono`
--
ALTER TABLE `relacionLineaPoligono`
  ADD PRIMARY KEY (`id_linea`,`num_lineas`),
  ADD KEY `id_linea` (`id_linea`,`num_lineas`),
  ADD KEY `poligono` (`num_lineas`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `jefeProyecto`
--
ALTER TABLE `jefeProyecto`
  ADD CONSTRAINT `jefeproyecto_ibfk_1` FOREIGN KEY (`cod_jefeProyecto`) REFERENCES `proyecto` (`cod_jefeProyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `linea`
--
ALTER TABLE `linea`
  ADD CONSTRAINT `linea_ibfk_1` FOREIGN KEY (`id_linea`) REFERENCES `relacionLineaPoligono` (`id_linea`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `plano`
--
ALTER TABLE `plano`
  ADD CONSTRAINT `plano_ibfk_1` FOREIGN KEY (`cod_plano`) REFERENCES `figura` (`cod_plano`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `jefe` FOREIGN KEY (`cod_jefeProyecto`) REFERENCES `jefeProyecto` (`cod_jefeProyecto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `plano` FOREIGN KEY (`cod_plano`) REFERENCES `plano` (`cod_plano`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `relacionLineaPoligono`
--
ALTER TABLE `relacionLineaPoligono`
  ADD CONSTRAINT `linea` FOREIGN KEY (`id_linea`) REFERENCES `linea` (`id_linea`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `poligono` FOREIGN KEY (`num_lineas`) REFERENCES `poligono` (`num_lineas`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
