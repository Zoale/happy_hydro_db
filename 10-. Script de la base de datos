/* Creación de la base de datos happy_hidro */
CREATE DATABASE happy_hidro;
GO
/* Uso de base de datos creada*/

USE happy_hidro;
GO
/*
sistema_torre
Torre donde se plantan los cultivos, cada torre tiene un limite de agua y capacidad de plantas.
ubicacion_lote y ubicacion_rack son para identificar la torre en el invernadero.
agua_actual es la cantidad de agua que hay actualmente en la torre, no puede ser negativa ni superar max_agua.
*/
CREATE TABLE sistema_torre (
    id_torre INT IDENTITY(1,1) PRIMARY KEY,
    max_agua DECIMAL(4) NOT NULL,
    capacidad_planta INT NOT NULL,
    ubicacion_lote VARCHAR(2) NOT NULL,
    ubicacion_rack VARCHAR(1) NOT NULL,
    agua_actual INT NOT NULL DEFAULT 0,
    CONSTRAINT CHK_agua_positivo CHECK (agua_actual >= 0),
    CONSTRAINT CHK_agua_max CHECK (agua_actual <= max_agua)
);
GO

/*
especie
Cada tipo de planta que se puede cultivar.
nombre debe ser unico, no puede haber dos especies con el mismo nombre.
*/
CREATE TABLE especie (
    id_especie INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_especie_nombre UNIQUE (nombre)
);
GO

/*
etapa
Cada una de las etapas por las que atraviesa un cultivo durante su ciclo
orden indica la posicion de la etapa dentro del ciclo, empezando en 1.
No puede haber dos etapas con el mismo nombre ni con el mismo orden.
*/
CREATE TABLE etapa (
    id_etapa INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    orden INT NOT NULL,
    CONSTRAINT UQ_etapa_nombre UNIQUE (nombre),
    CONSTRAINT UQ_etapa_orden UNIQUE (orden),
    CONSTRAINT CHK_etapa_orden CHECK (orden > 0)
);
GO

/*
especie_etapa
Define cuanto dura una etapa en su ciclo y rangos optimos de pH, EC y temp del agua para cada especie.
La clave primaria es compuesta (id_especie, id_etapa).
Una especie no puede tener dos veces la misma etapa.
Los rangos pueden ser null, pero si se cargan, el minimo no puede ser mayor que el maximo.
*/
CREATE TABLE especie_etapa (
    id_especie INT NOT NULL,
    id_etapa INT NOT NULL,
    dias_duracion INT NOT NULL,
    ph_min DECIMAL(3,1) NULL,
    ph_max DECIMAL(3,1) NULL,
    ec_min DECIMAL(4,2) NULL,
    ec_max DECIMAL(4,2) NULL,
    temp_min DECIMAL(3,1) NULL,
    temp_max DECIMAL(3,1) NULL,
    CONSTRAINT PK_especie_etapa PRIMARY KEY (id_especie, id_etapa),
    CONSTRAINT FK_ee_especie FOREIGN KEY (id_especie) REFERENCES especie(id_especie),
    CONSTRAINT FK_ee_etapa FOREIGN KEY (id_etapa) REFERENCES etapa(id_etapa),
    CONSTRAINT CHK_ee_dias CHECK (dias_duracion > 0),
    CONSTRAINT CHK_ee_ph CHECK (ph_min <= ph_max),
    CONSTRAINT CHK_ee_ec CHECK (ec_min <= ec_max),
    CONSTRAINT CHK_ee_temp CHECK (temp_min <= temp_max)
);
GO

/*
sensor
Dispositivo instalado en una torre que registra mediciones del agua.
Cada torre puede tener varios sensores.
activo indica si el sensor esta en funcionamiento; un sensor nuevo se registra como activo.
*/
CREATE TABLE sensor (
    id_sensor INT IDENTITY(1,1) PRIMARY KEY,
    id_torre INT NOT NULL,
    modelo VARCHAR(50) NULL,
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_sensor_torre FOREIGN KEY (id_torre) REFERENCES sistema_torre(id_torre)
);
GO

/*
medicion
Registro de los valores de pH, EC y temp del agua tomados por un sensor en fecha y hora determinadas.
Los valores pueden ser null si el sensor no mide alguno de ellos.
*/
CREATE TABLE medicion (
    id_medicion INT IDENTITY(1,1) PRIMARY KEY,
    id_sensor INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT GETDATE(),
    ph DECIMAL(3,1) NULL,
    ec DECIMAL(4,2) NULL,
    temp_agua DECIMAL(3,1) NULL,
    CONSTRAINT FK_medicion_sensor FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
);
GO

/*
cultivos
Cultivo activo en una torre.
fecha_cosecha es null mientras no se haya cosechado.
estado: EN PROGRESO, COSECHADO o MUERTO.
*/
CREATE TABLE cultivos (
    id_cultivo INT IDENTITY(1,1) PRIMARY KEY,
    id_especie INT NOT NULL,
    id_torre INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cosecha DATE NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'EN PROGRESO',
    cantidad_plantas INT NULL,
    CONSTRAINT FK_cultivo_especie FOREIGN KEY (id_especie) REFERENCES especie(id_especie),
    CONSTRAINT FK_cultivo_torre FOREIGN KEY (id_torre) REFERENCES sistema_torre(id_torre),
    CONSTRAINT CHK_estado_cultivo CHECK (estado IN ('EN PROGRESO', 'COSECHADO', 'MUERTO')),
    CONSTRAINT CHK_plantas CHECK (cantidad_plantas IS NULL OR cantidad_plantas > 0),
    CONSTRAINT CHK_fecha_cosecha CHECK (fecha_cosecha IS NULL OR fecha_cosecha >= fecha_inicio)
);
GO

/*
empleado
Identifica a un empleado que puede ejecutar tareas sobre los cultivos o las torres.
estado indica si el empleado esta activo "boolean".
*/
CREATE TABLE empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    estado BIT NOT NULL
);
GO

/*
tipo_tareas
Identifica los tipos de tareas que se pueden realizar sobre los cultivos o las torres,
solo se puede crear un tipo de tarea con un nombre unico, la descripcion es opcional.
*/
CREATE TABLE tipo_tareas (
    id_tipo_tarea INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NULL,
    CONSTRAINT UQ_tipo_tarea UNIQUE (nombre)
);
GO

/*
tareas
Identifica una tarea concreta que se debe realizar sobre un cultivo, asignada a un empleado.
Es determinada por un tipo de tarea, y puede tener una fecha programada y una fecha ejecutada.
Tiene un estado_tarea que puede ser PENDIENTE, ASIGNADA, EN PROGRESO, FINALIZADA o CANCELADA.
id_cultivo es opcional. Chequeo de integridad: si el estado_tarea es ASIGNADA, EN PROGRESO o FINALIZADA, debe tener una fecha programada.
*/
CREATE TABLE tareas (
    id_tarea INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo_tarea INT NOT NULL,
    id_cultivo INT NULL,
    id_empleado INT NOT NULL,
    fecha_programada DATE NULL,
    fecha_ejecutada DATE NULL,
    estado_tarea VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    observaciones VARCHAR(255) NULL,
    CONSTRAINT FK_tarea_tipo FOREIGN KEY (id_tipo_tarea) REFERENCES tipo_tareas(id_tipo_tarea),
    CONSTRAINT FK_tarea_cultivo FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo),
    CONSTRAINT FK_tarea_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    CONSTRAINT CHK_estado_tarea CHECK (estado_tarea IN ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO', 'FINALIZADA', 'CANCELADA')),
    CONSTRAINT CHK_fecha_prog CHECK (
        estado_tarea NOT IN ('ASIGNADA', 'EN PROGRESO', 'FINALIZADA')
        OR fecha_programada IS NOT NULL
    ),
    CONSTRAINT CHK_fecha_ejec CHECK (
        estado_tarea <> 'FINALIZADA'
        OR fecha_ejecutada IS NOT NULL
    ),
    CONSTRAINT CHK_orden_fechas CHECK (
        fecha_ejecutada IS NULL
        OR fecha_programada IS NULL
        OR fecha_ejecutada >= fecha_programada
    )
);
GO

USE happy_hidro;
GO

--Usamos la función SET IDENTITY_INSERT 'nombre de table' ON/OFF; Para ajustar de manera manual,
--la inserción de todos los ids, por lo menos los primeros agregados y así evitarnos errores,
--y así mejorar el manejo de los datos agregados de manera masiva como lo haremos en esta ocasión:

-- 1. SISTEMA_TORRE (30 registros)

SET IDENTITY_INSERT sistema_torre ON;
INSERT INTO sistema_torre (id_torre, max_agua, capacidad_planta, ubicacion_lote, ubicacion_rack, agua_actual) VALUES
(1, 50.00, 20, 'A', '1', 40), (2, 50.00, 20, 'A', '2', 45), (3, 60.00, 24, 'A', '3', 50), (4, 60.00, 24, 'A', '4', 30),
(5, 50.00, 20, 'B', '1', 48), (6, 50.00, 20, 'B', '2', 25), (7, 60.00, 24, 'B', '3', 55), (8, 60.00, 24, 'B', '4', 60),
(9, 40.00, 16, 'C', '1', 35), (10, 40.00, 16, 'C', '2', 20), (11, 50.00, 20, 'C', '3', 40), (12, 50.00, 20, 'C', '4', 15),
(13, 70.00, 30, 'D', '1', 65), (14, 70.00, 30, 'D', '2', 70), (15, 70.00, 30, 'D', '3', 50), (16, 70.00, 30, 'D', '4', 45),
(17, 50.00, 20, 'E', '1', 50), (18, 50.00, 20, 'E', '2', 30), (19, 60.00, 24, 'E', '3', 40), (20, 60.00, 24, 'E', '4', 25),
(21, 40.00, 16, 'F', '1', 35), (22, 40.00, 16, 'F', '2', 38), (23, 50.00, 20, 'F', '3', 20), (24, 50.00, 20, 'F', '4', 45),
(25, 80.00, 36, 'G', '1', 75), (26, 80.00, 36, 'G', '2', 60), (27, 80.00, 36, 'G', '3', 80), (28, 80.00, 36, 'G', '4', 50),
(29, 50.00, 20, 'H', '1', 40), (30, 50.00, 20, 'H', '2', 30);
SET IDENTITY_INSERT sistema_torre OFF;
GO


-- 2. ESPECIE (30 registros)

SET IDENTITY_INSERT especie ON;
INSERT INTO especie (id_especie, nombre) VALUES
(1, 'Lechuga Capuchina'), (2, 'Lechuga Criolla'), (3, 'Albahaca Genovesa'),
(4, 'Acelga Verde'), (5, 'Espinaca Baby'), (6, 'Rucula Salvaje'),
(7, 'Perejil Liso'), (8, 'Cilantro'), (9, 'Menta Piperita'),
(10, 'Tomate Cherry'), (11, 'Morron Rojo'), (12, 'Frutilla San Andreas'),
(13, 'Berenjena'), (14, 'Ciboulette'), (15, 'Orégano'),
(16, 'Tomillo'), (17, 'Romero'), (18, 'Verdeo'),
(19, 'Brocoli Mini'), (20, 'Coliflor Mini'), (21, 'Lechuga Roja'),
(22, 'Radicheta'), (23, 'Kale'), (24, 'Hinojo'),
(25, 'Apio'), (26, 'Pak Choi'), (27, 'Tatsoi'),
(28, 'Salvia'), (29, 'Melisa'), (30, 'Estevia');
SET IDENTITY_INSERT especie OFF;
GO

-- 3. ETAPA (5 registros)

SET IDENTITY_INSERT etapa ON;
INSERT INTO etapa (id_etapa, nombre, orden) VALUES
(1, 'Germinacion', 1),
(2, 'Plantula', 2),
(3, 'Crecimiento Vegetativo', 3),
(4, 'Floracion', 4),
(5, 'Cosecha', 5);
SET IDENTITY_INSERT etapa OFF;
GO

-- 4. ESPECIE_ETAPA (30 registros)

INSERT INTO especie_etapa (id_especie, id_etapa, dias_duracion, ph_min, ph_max, ec_min, ec_max, temp_min, temp_max) VALUES
(1, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (2, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(3, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (4, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(5, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (6, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(7, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (8, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(9, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (10, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(11, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (12, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(13, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (14, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(15, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (16, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(17, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (18, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(19, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (20, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(21, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (22, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(23, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (24, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(25, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (26, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(27, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (28, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(29, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (30, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0);
GO

-- 5. SENSOR (30 registros)

SET IDENTITY_INSERT sensor ON;
INSERT INTO sensor (id_sensor, id_torre, modelo, activo) VALUES
(1, 1, NULL, 1), (2, 2, NULL, 1), (3, 3, NULL, 1), (4, 4, NULL, 1), (5, 5, NULL, 1),
(6, 6, NULL, 1), (7, 7, NULL, 1), (8, 8, NULL, 1), (9, 9, NULL, 1), (10, 10, NULL, 1),
(11, 11, NULL, 1), (12, 12, NULL, 1), (13, 13, NULL, 1), (14, 14, NULL, 1), (15, 15, NULL, 1),
(16, 16, NULL, 1), (17, 17, NULL, 1), (18, 18, NULL, 1), (19, 19, NULL, 1), (20, 20, NULL, 1),
(21, 21, NULL, 1), (22, 22, NULL, 1), (23, 23, NULL, 1), (24, 24, NULL, 1), (25, 25, NULL, 1),
(26, 26, NULL, 1), (27, 27, NULL, 1), (28, 28, NULL, 1), (29, 29, NULL, 1), (30, 30, NULL, 1);
SET IDENTITY_INSERT sensor OFF;
GO

-- 6. MEDICION (30 registros)

INSERT INTO medicion (id_sensor, fecha_hora, ph, ec, temp_agua) VALUES
(1, '2026-01-05T08:00:00', 6.1, 1.2, 20.2),
(1, '2026-01-10T08:00:00', 6.0, 1.3, 20.4),
(2, '2026-01-12T09:30:00', 6.2, 1.3, 19.8),
(2, '2026-01-18T10:00:00', 6.3, 1.4, 20.1),
(3, '2026-01-15T08:15:00', 6.5, 1.6, 21.9),
(3, '2026-01-20T08:15:00', 6.4, 1.5, 22.0),
(4, '2026-01-22T09:00:00', 6.7, 1.7, 19.2),
(4, '2026-01-25T09:00:00', 6.8, 1.8, 19.5),
(5, '2026-01-28T07:45:00', 6.3, 1.5, 18.1),
(6, '2026-02-01T11:00:00', 6.0, 1.1, 21.2),
(7, '2026-02-05T08:30:00', 6.5, 1.4, 20.0),
(8, '2026-02-10T08:30:00', 6.6, 1.5, 22.1),
(9, '2026-02-14T09:00:00', 6.0, 1.5, 21.0),
(10, '2026-02-16T10:00:00', 6.2, 2.1, 22.8),
(11, '2026-02-18T08:00:00', 6.4, 2.0, 22.0),
(12, '2026-02-20T08:00:00', 5.8, 1.5, 19.0),
(13, '2026-02-22T09:00:00', 6.2, 2.2, 23.9),
(14, '2026-02-24T10:30:00', 6.5, 1.3, 18.5),
(15, '2026-02-28T08:00:00', 7.0, 1.4, 20.4),
(16, '2026-03-02T08:00:00', 6.5, 1.3, 21.0),
(17, '2026-03-05T09:00:00', 6.8, 1.2, 21.8),
(18, '2026-03-07T08:00:00', 6.5, 1.6, 19.0),
(19, '2026-03-10T08:00:00', 6.5, 2.0, 17.5),
(20, '2026-03-12T08:00:00', 6.7, 2.1, 18.0),
(21, '2026-03-14T09:00:00', 6.0, 1.2, 20.1),
(22, '2026-03-16T08:00:00', 6.2, 1.4, 19.0),
(23, '2026-03-20T08:00:00', 6.5, 1.8, 17.0),
(24, '2026-03-22T08:00:00', 6.4, 1.7, 20.0),
(25, '2026-03-25T09:00:00', 6.5, 1.9, 19.0),
(26, '2026-03-28T08:00:00', 6.3, 1.6, 21.0),
(27, '2026-03-30T08:00:00', 6.4, 1.6, 20.5),
(28, '2026-04-01T08:00:00', 6.6, 1.7, 21.2),
(29, '2026-04-03T09:00:00', 6.2, 1.4, 19.8),
(30, '2026-04-05T08:00:00', 6.5, 1.5, 20.9);
GO


-- 7. CULTIVOS (30 registros)

SET IDENTITY_INSERT cultivos ON;
INSERT INTO cultivos (id_cultivo, id_especie, id_torre, fecha_inicio, fecha_cosecha, estado, cantidad_plantas) VALUES
(1, 1, 1, '2026-01-01', '2026-02-15', 'COSECHADO', 18), (2, 2, 2, '2026-01-05', '2026-02-20', 'COSECHADO', 20),
(3, 3, 3, '2026-01-10', NULL, 'EN PROGRESO', 22), (4, 4, 4, '2026-01-15', NULL, 'EN PROGRESO', 20),
(5, 5, 5, '2026-01-20', '2026-03-01', 'COSECHADO', 15), (6, 6, 6, '2026-01-25', NULL, 'MUERTO', 10),
(7, 7, 7, '2026-02-01', NULL, 'EN PROGRESO', 24), (8, 8, 8, '2026-02-05', NULL, 'EN PROGRESO', 24),
(9, 9, 9, '2026-02-10', NULL, 'EN PROGRESO', 15), (10, 10, 10, '2026-02-12', NULL, 'EN PROGRESO', 12),
(11, 11, 11, '2026-02-15', NULL, 'EN PROGRESO', 18), (12, 12, 12, '2026-02-18', NULL, 'EN PROGRESO', 16),
(13, 13, 13, '2026-02-20', NULL, 'EN PROGRESO', 25), (14, 14, 14, '2026-02-22', NULL, 'EN PROGRESO', 28),
(15, 15, 15, '2026-02-25', NULL, 'EN PROGRESO', 20), (16, 16, 16, '2026-03-01', NULL, 'EN PROGRESO', 18),
(17, 17, 17, '2026-03-03', NULL, 'EN PROGRESO', 20), (18, 18, 18, '2026-03-05', NULL, 'EN PROGRESO', 19),
(19, 19, 19, '2026-03-08', NULL, 'EN PROGRESO', 22), (20, 20, 20, '2026-03-10', NULL, 'EN PROGRESO', 21),
(21, 21, 21, '2026-03-12', NULL, 'EN PROGRESO', 15), (22, 22, 22, '2026-03-15', NULL, 'EN PROGRESO', 14),
(23, 23, 23, '2026-03-18', NULL, 'EN PROGRESO', 20), (24, 24, 24, '2026-03-20', NULL, 'EN PROGRESO', 18),
(25, 25, 25, '2026-03-22', NULL, 'EN PROGRESO', 30), (26, 26, 26, '2026-03-25', NULL, 'EN PROGRESO', 28),
(27, 27, 27, '2026-03-28', NULL, 'EN PROGRESO', 25), (28, 28, 28, '2026-04-01', NULL, 'EN PROGRESO', 15),
(29, 29, 29, '2026-04-03', NULL, 'EN PROGRESO', 18), (30, 30, 30, '2026-04-05', NULL, 'EN PROGRESO', 20);
SET IDENTITY_INSERT cultivos OFF;
GO

-- 8. EMPLEADO (30 registros)

SET IDENTITY_INSERT empleado ON;
INSERT INTO empleado (id_empleado, nombre, apellido, estado) VALUES
(1, 'Carlos', 'Gomez', 1), (2, 'Maria', 'Perez', 1), (3, 'Juan', 'Rodríguez', 1), (4, 'Ana', 'López', 1),
(5, 'Lucas', 'Martínez', 1), (6, 'Sofía', 'Fernández', 1), (7, 'Mateo', 'García', 1), (8, 'Valentina', 'González', 1),
(9, 'Diego', 'Hernández', 1), (10, 'Camila', 'Martín', 1), (11, 'Joaquín', 'Ruiz', 1), (12, 'Lucía', 'Díaz', 1),
(13, 'Gabriel', 'Álvarez', 1), (14, 'Martina', 'Moreno', 1), (15, 'Federico', 'Muñoz', 1), (16, 'Florencia', 'Rojas', 1),
(17, 'Agustín', 'Navarro', 1), (18, 'Victoria', 'Torres', 1), (19, 'Ignacio', 'Domínguez', 1), (20, 'Catalina', 'Vázquez', 1),
(21, 'Nicolás', 'Ramos', 1), (22, 'Julieta', 'Gil', 1), (23, 'Tomás', 'Serrano', 1), (24, 'Renata', 'Blanco', 1),
(25, 'Emiliano', 'Molina', 1), (26, 'Antonella', 'Morales', 1), (27, 'Bautista', 'Suárez', 1), (28, 'Mía', 'Ortega', 1),
(29, 'Benjamín', 'Castro', 1), (30, 'Abigail', 'Rubio', 1);
SET IDENTITY_INSERT empleado OFF;
GO


-- 9. TIPO_TAREAS (30 registros)

SET IDENTITY_INSERT tipo_tareas ON;
INSERT INTO tipo_tareas (id_tipo_tarea, nombre, descripcion) VALUES
(1, 'Medicion de pH', 'Control diario de acidez del agua en torre'),
(2, 'Medicion de EC', 'Revision de electroconductividad y nutrientes'),
(3, 'Limpieza de Tanque', 'Desinfeccion y vaciado parcial de deposito'),
(4, 'Calibracion de Sensores', 'Calibracion de sondas de temperatura y pH'),
(5, 'Siembra', 'Colocacion de germinados en alveolos'),
(6, 'Cosecha', 'Recoleccion de plantas adultas listas'),
(7, 'Poda de Raices', 'Mantenimiento preventivo del sistema radicular'),
(8, 'Recambio de Solucion Nutritiva', 'Sustitucion completa del agua con nutrientes'),
(9, 'Control de Plagas', 'Inspeccion visual y aplicacion organica preventiva'),
(10, 'Revision de Bombas', 'Verificacion de caudal y presion de agua'),
(11, 'Limpieza de Boquillas', 'Destapado de chupones de riego por goteo'),
(12, 'Mantenimiento de Iluminacion', 'Reemplazo de paneles LED quemados'),
(13, 'Control de Temperatura', 'Verificacion de climatizacion del invernadero'),
(14, 'Monitoreo de Oxigeno', 'Medicion de oxigeno disuelto en agua'),
(15, 'Desinfeccion de Racks', 'Limpieza profunda de estructuras metalicas'),
(16, 'Ajuste de Niveles de Agua', 'Rellenado por evaporacion'),
(17, 'Rotacion de Cultivos', 'Cambio de ubicacion de bandejas'),
(18, 'Descarte de Plantas Muertas', 'Retiro de ejemplares no viables'),
(19, 'Revision Electrica', 'Control de tableros y disyuntores'),
(20, 'Calibracion de EC', 'Ajuste especifico del medidor de conductividad'),
(21, 'Aplicacion de Calcio', 'Suplemento foliar preventivo'),
(22, 'Monitoreo de Humedad', 'Control higrometrico del ambiente'),
(23, 'Saneamiento General', 'Limpieza de pisos y desagües del sector'),
(24, 'Cambio de Filtros', 'Reemplazo de cartuchos de filtrado de agua'),
(25, 'Test de Germinacion', 'Control de tasa de salida en semillero'),
(26, 'Podado de Hojas Secas', 'Mantenimiento estetico y sanitario'),
(27, 'Verificacion de Valvulas', 'Prueba de apertura y cierre de paso'),
(28, 'Control de CO2', 'Medicion de gases en ambiente cerrado'),
(29, 'Auditoria de Stock', 'Conteo de insumos y nutrientes en deposito'),
(30, 'Capacitacion de Personal', 'Induccion operativa sobre nuevas normas');
SET IDENTITY_INSERT tipo_tareas OFF;
GO

-- 10. TAREAS (30 registros)
-- Validaciones aplicadas: Fechas coherentes con los estados.
-- id_torre eliminado: la torre de una tarea se obtiene a traves de id_cultivo.

SET IDENTITY_INSERT tareas ON;
INSERT INTO tareas (id_tarea, id_tipo_tarea, id_cultivo, id_empleado, fecha_programada, fecha_ejecutada, estado_tarea, observaciones) VALUES
(1, 1, 1, 1, '2026-01-02', '2026-01-02', 'FINALIZADA', 'Medicion inicial dentro de parametros optimos'),
(2, 2, 2, 2, '2026-01-06', '2026-01-06', 'FINALIZADA', 'EC estable en torre 2'),
(3, 3, 3, 3, '2026-01-12', '2026-01-13', 'FINALIZADA', 'Limpieza profunda realizada con exito'),
(4, 4, 4, 4, '2026-01-16', NULL, 'ASIGNADA', 'Pendiente de calibracion general'),
(5, 5, 5, 5, '2026-01-21', '2026-01-21', 'FINALIZADA', 'Siembra completada sin novedades'),
(6, 6, 1, 6, '2026-02-15', '2026-02-15', 'FINALIZADA', 'Cosecha exitosa de lechugas capuchinas'),
(7, 7, 6, 7, '2026-01-26', NULL, 'PENDIENTE', 'Requiere revision urgente'),
(8, 8, 7, 8, '2026-02-02', '2026-02-02', 'FINALIZADA', 'Recambio de agua con solucion B'),
(9, 9, 8, 9, '2026-02-06', NULL, 'EN PROGRESO', 'Aplicando control biologico preventivo'),
(10, 10, 9, 10, '2026-02-11', '2026-02-11', 'FINALIZADA', 'Bomba principal funcionando correctamente'),
(11, 11, 10, 11, '2026-02-13', NULL, 'CANCELADA', 'Se pospuso por falta de insumos'),
(12, 12, 11, 12, '2026-02-16', '2026-02-16', 'FINALIZADA', 'Paneles LED reemplazados'),
(13, 13, 12, 13, '2026-02-19', NULL, 'ASIGNADA', 'Ajuste programado de temperatura'),
(14, 14, 13, 14, '2026-02-21', '2026-02-21', 'FINALIZADA', 'Oxigenacion optima registrada'),
(15, 15, 14, 15, '2026-02-23', NULL, 'PENDIENTE', 'Limpieza de sector D'),
(16, 16, 15, 16, '2026-02-26', '2026-02-26', 'FINALIZADA', 'Niveles de agua restablecidos'),
(17, 17, 16, 17, '2026-03-02', NULL, 'EN PROGRESO', 'Rotando bandejas de cultivo'),
(18, 18, 6, 18, '2026-01-30', '2026-01-30', 'FINALIZADA', 'Retiro de plantas muertas en torre 6'),
(19, 19, 17, 19, '2026-03-04', '2026-03-04', 'FINALIZADA', 'Tablero electrico verificado'),
(20, 20, 18, 20, '2026-03-06', NULL, 'ASIGNADA', 'Calibracion pendiente de sonda EC'),
(21, 21, 19, 21, '2026-03-09', '2026-03-09', 'FINALIZADA', 'Suplemento de calcio aplicado'),
(22, 22, 20, 22, '2026-03-11', NULL, 'PENDIENTE', 'Control de humedad ambiental'),
(23, 23, 21, 23, '2026-03-13', '2026-03-13', 'FINALIZADA', 'Saneamiento completado en sector F'),
(24, 24, 22, 24, '2026-03-16', '2026-03-16', 'FINALIZADA', 'Filtros de agua reemplazados'),
(25, 25, 23, 25, '2026-03-19', NULL, 'ASIGNADA', 'Test de germinacion programado'),
(26, 26, 24, 26, '2026-03-21', '2026-03-21', 'FINALIZADA', 'Podado estético realizado'),
(27, 27, 25, 27, '2026-03-23', NULL, 'EN PROGRESO', 'Prueba de valvulas hidraulicas'),
(28, 28, 26, 28, '2026-03-26', '2026-03-26', 'FINALIZADA', 'Medicion de CO2 dentro del rango'),
(29, 29, 27, 29, '2026-03-29', '2026-03-29', 'FINALIZADA', 'Auditoria trimestral completada'),
(30, 30, 28, 30, '2026-04-02', '2026-04-02', 'FINALIZADA', 'Capacitacion de personal operativo efectuada');
SET IDENTITY_INSERT tareas OFF;
GO

-- Función #1 (fn_EvaluarValor):
-- Compara un valor contra un rango, sin tablas, lo usamos para comprar revisar las mediciones de pH, EC y temperatura contra los rangos óptimos de cada especie.
CREATE FUNCTION fn_EvaluarValor (
    @valor DECIMAL(10,2),
    @min   DECIMAL(10,2),
    @max   DECIMAL(10,2)
)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN
        CASE
            WHEN @valor IS NULL THEN 'SIN DATO'
            WHEN @min IS NULL OR @max IS NULL THEN 'SIN RANGO'
            WHEN @valor < @min THEN 'BAJO'
            WHEN @valor > @max THEN 'ALTO'
            ELSE 'OK'
        END
END;
GO

-- Ejemplo de uso:
/*
Lo usamos en la view: vw_MedicionesEvaluadas*/
SELECT * FROM vw_MedicionesEvaluadas
WHERE estado_ph <> 'OK' OR estado_ec <> 'OK' OR estado_temp <> 'OK';
GO

-- Función #2 (fn_CapacidadDisponible):
-- La función calcula cuántas plantas más caben en una torre. Hace la resta entre su capacidad máxima y las plantas que ya están ocupadas por cultivos activos.
CREATE FUNCTION fn_CapacidadDisponible (@id_torre INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT st.capacidad_planta - ISNULL(SUM(c.cantidad_plantas), 0)
        FROM sistema_torre AS st
        LEFT JOIN cultivos AS c
            ON  c.id_torre = st.id_torre
            AND c.estado = 'EN PROGRESO'
        WHERE st.id_torre = @id_torre
        GROUP BY st.capacidad_planta
    );
END;
GO
-- Ejemplo de uso:
/* 
La función calcula cuántas plantas más caben en una torre. Hace la resta entre su capacidad máxima y las plantas que ya están ocupadas por cultivos activos.*/
SELECT id_torre, capacidad_planta,
       dbo.fn_CapacidadDisponible(id_torre) AS disponible
FROM sistema_torre;
GO
-- Función #3 (fn_DiasCultivo):
-- La función calcula cuántos días pasaron entre la fecha de inicio y la de cosecha, o entre la de inicio y hoy si todavía no se cosechó.
CREATE FUNCTION fn_DiasCultivo (@id_cultivo INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT CONVERT(INT, ISNULL(CONVERT(DATETIME, c.fecha_cosecha), GETDATE()))
             - CONVERT(INT, CONVERT(DATETIME, c.fecha_inicio))
        FROM cultivos AS c
        WHERE c.id_cultivo = @id_cultivo
    );   -- El NULL se usa si el cultivo no existe
END;
GO
-- Ejemplo de uso:
/*
La función se puede usar para revisar primero los cultivos más viejos, que son los que están más cerca de la cosecha.
*/
SELECT id_cultivo, id_torre, fecha_inicio,
       dbo.fn_DiasCultivo(id_cultivo) AS dias
FROM cultivos
WHERE estado = 'EN PROGRESO'
ORDER BY dias DESC;
GO

/*
 * Función: fn_FechaCosechaEstimada
 * Devuelve la fecha estimada de cosecha de un cultivo:
 * fecha de inicio + suma de las duraciones de todas las etapas de su especie.
 */
CREATE OR ALTER FUNCTION fn_FechaCosechaEstimada (@id_cultivo INT)
RETURNS DATE
AS
BEGIN
    DECLARE @id_especie INT, @fecha_inicio DATE, @estado VARCHAR(20), @fecha_real DATE, @total_dias INT;
    SELECT @id_especie   = id_especie,
           @fecha_inicio = fecha_inicio,
           @estado       = estado,
           @fecha_real   = fecha_cosecha
    FROM cultivos
    WHERE id_cultivo = @id_cultivo;

    IF @id_especie IS NULL OR @estado = 'MUERTO'
        RETURN NULL;

    IF @estado = 'COSECHADO'
        RETURN @fecha_real;

    -- Total de días de todas las etapas de la especie
    SELECT @total_dias = SUM(dias_duracion)
    FROM especie_etapa
    WHERE id_especie = @id_especie;

    
    RETURN DATEADD(DAY, @total_dias, @fecha_inicio);
END;
GO

SELECT c.id_cultivo, c.estado, c.fecha_inicio,
       dbo.fn_FechaCosechaEstimada(c.id_cultivo) AS cosecha_estimada
FROM cultivos c;
GO
/*
fn_UltimaMedicion
Objetivo: Conocer la medicion mas reciente de una torre, para controlar el agua.
Parametros: @id_torre (INT), la torre donde buscar.
Tipo de retorno: TABLE, una fila con el sensor, la fecha y hora, el ph, la ec y la temperatura del agua.
Logica: Junta mediciones con los sensores de la torre, las ordena por las nuevas y se queda con la primera.
Si la torre no tiene mediciones devuelve una tabla vacia.
Ejemplo de utilizacion: select * from dbo.fn_UltimaMedicion(1);
*/
create function fn_UltimaMedicion (@id_torre int)
returns table
as
return (
    select top 1 m.id_sensor, m.fecha_hora, m.ph, m.ec, m.temp_agua
    from medicion m
    join sensor s on m.id_sensor = s.id_sensor
    where s.id_torre = @id_torre
    order by m.fecha_hora desc
);
GO

/*
fn_PromedioMediciones
Objetivo: Conocer los valores promedio del agua de una torre en un periodo.
Parametros: @id_torre (INT), la torre donde buscar.
@desde (DATE) y @hasta (DATE), el periodo a consultar, ambos dias incluidos.
Tipo de retorno: TABLE, una fila con la cantidad de mediciones y el promedio de ph, ec y temperatura del agua.
Logica: Junta mediciones con los sensores de la torre y promedia las que estan dentro del periodo.
Se compara contra el dia siguiente a @hasta para incluir las mediciones de ese dia.
Si no hay mediciones en el periodo devuelve cantidad 0 y los promedios en null.
Ejemplo de utilizacion: select * from dbo.fn_PromedioMediciones(2, '2026-01-01', '2026-01-15');
*/
create function fn_PromedioMediciones (@id_torre int, @desde date, @hasta date)
returns table
as
return (
    select count(*) as cantidad_mediciones, avg(m.ph) as ph_promedio, avg(m.ec) as ec_promedio, avg(m.temp_agua) as temp_promedio
    from medicion m
    join sensor s on m.id_sensor = s.id_sensor
    where s.id_torre = @id_torre and m.fecha_hora >= @desde and m.fecha_hora < dateadd(day, 1, @hasta)
);
GO

/*
fn_TareasEmpleado
Objetivo: Ver todas las tareas de un empleado, para controlar su carga laboral y cosas pendientes.
Parametros: @id_empleado (INT), el empleado a consultar.
Tipo de retorno: TABLE, una fila por tarea con tipo, cultivo, torre, fechas, estado y observaciones.
Logica: Busca las tareas del empleado y les agrega el tipo de tarea y la torre.
Se usa left join con cultivos porque id_cultivo es opcional, asi no se pierden las tareas sin cultivo.
Si el empleado no tiene tareas devuelve una tabla vacia.
Ejemplo de utilizacion: select * from dbo.fn_TareasEmpleado(1) order by fecha_programada;
*/
create function fn_TareasEmpleado (@id_empleado int)
returns table
as
return (
    select t.id_tarea, x.nombre as tarea, t.id_cultivo, c.id_torre, t.fecha_programada, t.fecha_ejecutada, t.estado_tarea, t.observaciones
    from tareas t
    join tipo_tareas x on t.id_tipo_tarea = x.id_tipo_tarea
    left join cultivos c on t.id_cultivo = c.id_cultivo
    where t.id_empleado = @id_empleado
);
GO

/*
Vista 3:
Muestra los las tareas asignadas a los empleados
 
*/

CREATE OR ALTER VIEW v_tareas_pendientes AS
SELECT t2.descripcion, e.nombre, st.id_torre, c.cantidad_plantas
from tareas as t
JOIN tipo_tareas as t2
	ON t.id_tarea = t2.id_tipo_tarea
JOIN empleado as e 
	ON t.id_empleado = e.id_empleado
join cultivos as c
    on c.id_cultivo= t.id_cultivo
join  sistema_torre as st
ON st.id_torre=c.id_cultivo

WHERE t.estado_tarea = 'ASIGNADA'
GO

--select * from v_tareas_pendientes;

/*
Vista 4:
 muestra las torres que tienen bajo nivel de agua y las de estado normal.
 */

CREATE VIEW vw_torres_bajo_agua_2 AS
SELECT
    id_torre,
    ubicacion_lote,
    ubicacion_rack,
    CASE
        WHEN agua_actual * 100.0 / max_agua < 30 THEN 'CRITICO'
        WHEN agua_actual * 100.0 / max_agua < 50 THEN 'BAJO'
        ELSE 'NORMAL'
    END AS estado
FROM sistema_torre;
GO


 /*
Vista 1:
Muestra los cultivos que se encuentran en estado "EN PROGRESO"
devuelve, id_torrre, estado , agua , especie que contiene , lote y rack
*/

CREATE OR ALTER VIEW v_mantenimientos_pendientes AS
SELECT c.id_torre, c.estado , s.agua_actual , e.nombre AS especie ,  s.ubicacion_lote , s.ubicacion_rack
FROM cultivos as c
JOIN sistema_torre as s ON s.id_torre= c.id_torre
JOIN especie as e ON e.id_especie = c.id_especie
WHERE c.estado = 'EN PROGRESO';
GO

/*
Vista 2:
Muestra en una vista que señale las tareas en estado “ASIGNADA”, ordenadas por fecha más próxima, e incluya para cada tarea: id_torre,ubicacion_lote,ubicacion_rack y el nombre del empleado que fue asignado.
*/

CREATE VIEW vw_tareas_asignadas_2 AS
SELECT
    t.id_tarea,
    st.id_torre,
    st.ubicacion_lote,
    st.ubicacion_rack,
    e.nombre + ' ' + e.apellido AS nombre_empleado,
    t.fecha_programada,
    t.observaciones,
    t.estado_tarea
FROM cultivos AS c
INNER JOIN sistema_torre AS st 
    ON st.id_torre = c.id_torre
INNER JOIN tareas AS t 
    ON t.id_cultivo = c.id_cultivo  
INNER JOIN empleado AS e 
    ON e.id_empleado = t.id_empleado
WHERE t.estado_tarea = 'ASIGNADA';
GO

/*Vista 3:
Revisa automáticamente cada medición de pH, EC y temperatura del agua y la clasifica según el rango óptimo de la especie que se está cultivando en esa torre haciendo uso de la función: fn_EvaluarValor. 
Cada medición queda marcada como OK, BAJO, ALTO, SIN DATO o SIN RANGO,
para que el personal vea de un vistazo si algo requiere atención.
*/
CREATE VIEW vw_MedicionesEvaluadas AS
SELECT
    m.id_medicion, s.id_torre, m.fecha_hora,
    m.ph,      dbo.fn_EvaluarValor(m.ph,ee.ph_min,ee.ph_max) AS estado_ph,
    m.ec,      dbo.fn_EvaluarValor(m.ec,ee.ec_min,ee.ec_max) AS estado_ec,
    m.temp_agua, dbo.fn_EvaluarValor(m.temp_agua, ee.temp_min, ee.temp_max) AS estado_temp
FROM medicion AS m
JOIN sensor AS s ON s.id_sensor = m.id_sensor
JOIN cultivos AS c ON c.id_torre = s.id_torre AND c.estado = 'EN PROGRESO'
JOIN especie_etapa AS ee ON ee.id_especie = c.id_especie AND ee.id_etapa = 3;
GO

USE happy_hidro;
GO

/*
 * Procedimiento: SP_RegistrarCultivo
 *
 * Permite registrar un nuevo cultivo en el sistema hidropónico.
 * Recibe la especie, la torre y la cantidad de plantas.
 * Inserta el cultivo con la fecha actual y el estado EN PROGRESO.
 *
 * Objetivo: facilitar el registro de nuevos cultivos.
 */
CREATE OR ALTER PROCEDURE SP_RegistrarCultivo
    @id_especie INT,
    @id_torre INT,
    @cantidad_plantas INT
AS
BEGIN
    INSERT INTO cultivos (
        id_especie,
        id_torre,
        fecha_inicio,
        cantidad_plantas,
        estado
    )
    VALUES (
        @id_especie,
        @id_torre,
        GETDATE(),
        @cantidad_plantas,
        'EN PROGRESO'
    );
END;
GO


/*
 * Procedimiento: SP_FinalizarTarea
 *
 * Permite finalizar una tarea existente.
 * Verifica que se encuentre EN PROGRESO
 * y que su fecha programada no sea posterior a la actual.
 * Actualiza su estado a FINALIZADA y registra la fecha de ejecución.
 *
 * Objetivo: automatizar la finalización de tareas.
 */
CREATE OR ALTER PROCEDURE SP_FinalizarTarea
    @id_tarea INT
AS
BEGIN
    UPDATE tareas
    SET estado_tarea = 'FINALIZADA',
        fecha_ejecutada = GETDATE()
    WHERE id_tarea = @id_tarea
      AND estado_tarea = 'EN PROGRESO'
      AND fecha_programada <= GETDATE();
END;
GO

/*
 * Procedimiento: SP_CultivoMuerto
 *
 * Cambiar el estado de un cultivo "EN PROGRESO" a "MUERTO" por perdida del mismo
 *
 * Objetivo: automatizar la finalización de tareas.
 */
CREATE OR ALTER PROCEDURE SP_CultivoMuerto
    @id_cultivo INT
AS
BEGIN
    UPDATE cultivos
    SET estado = 'MUERTO'
    WHERE id_cultivo = @id_cultivo AND estado = 'EN PROGRESO';
END;
GO


/*
 * Procedimiento: SP_CultivoCosechado
 *
 * Cambiar el estado de un cultivo "EN PROGRESO" a "COSECHADO" al finalizar el mismo
 * registrando fecha de cosecha
 * Objetivo: automatizar la finalización de tareas.
 */
CREATE OR ALTER PROCEDURE SP_CultivoCosechado
    @id_cultivo INT
AS
BEGIN
    UPDATE cultivos
    SET estado = 'COSECHADO', fecha_cosecha = GETDATE()
    WHERE id_cultivo = @id_cultivo AND estado = 'EN PROGRESO';
END;
GO

/*
 * Procedimiento: SP_SensorReporte
 *
 * Actulizar la medicion del PH, EC , TEMP y Nivel de agua de una torre
 * reportada por la API del sensor
 *
 */
CREATE OR ALTER PROCEDURE SP_SensorReporte
    @id_sensor INT,
    @ph decimal(3,1),
    @ec decimal(3,1),
    @temp_agua decimal(4,2)
AS
BEGIN
    INSERT INTO medicion(
        id_sensor,
        fecha_hora,
        ph,
        ec,
        temp_agua
    )
    VALUES (
        @id_sensor,
        GETDATE(),
        @ph,
        @ec,
        @temp_agua
    );
END;
GO

/*
 * Procedimiento: SP_altaEmpleados
 *
 * Da de alta la nomina de empleados
 *
 */
CREATE OR ALTER PROCEDURE SP_altaEmpleados
    @nombre varchar(15),
    @apellido varchar(15)
AS
BEGIN
    INSERT INTO empleado(
        nombre,
        apellido
    )
    VALUES (
       @nombre,
       @apellido
    );
END;
GO

/*
 * SP_Sensor_Insertar
 *
 * Registra un sensor nuevo en una torre existente. Valida que la torre exista
 * y devuelve el id del sensor creado. El sensor se registra como activo.
 */
CREATE OR ALTER PROCEDURE SP_Sensor_Insertar
    @id_torre   INT,
    @modelo     VARCHAR(50) = NULL,
    @id_sensor  INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sistema_torre WHERE id_torre = @id_torre)
        THROW 50001, 'La torre no existe.', 1;

    -- Un sensor nuevo se registra como activo
    INSERT INTO sensor (id_torre, modelo, activo)
    VALUES (@id_torre, @modelo, 1);

    SET @id_sensor = SCOPE_IDENTITY();
END;
GO

/*
 * SP_Sensor_Actualizar
 *
 * Modifica la torre, el modelo y el estado de un sensor.
 */
CREATE OR ALTER PROCEDURE SP_Sensor_Actualizar
    @id_sensor  INT,
    @id_torre   INT,
    @modelo     VARCHAR(50),
    @activo     BIT
AS
BEGIN
    UPDATE sensor
    SET id_torre = @id_torre,
        modelo   = @modelo,
        activo   = @activo
    WHERE id_sensor = @id_sensor;
END;
GO

-- Ver el sensor antes del cambio
SELECT * FROM sensor WHERE id_sensor = 1;

-- Cambiar la torre, el modelo y el estado del sensor 1
EXEC dbo.SP_Sensor_Actualizar
    @id_sensor = 1,
    @id_torre  = 2,
    @modelo    = 'pH-EC Multiparametro',
    @activo    = 1;

-- Ver el resultado
SELECT * FROM sensor WHERE id_sensor = 1;
GO

USE happy_hidro;
GO

/* =====================================================================
 * LIMPIEZA DE TRIGGERS VIEJOS
 * =====================================================================
 * - TR_ValidarTorreTarea: usaba tareas.id_torre, columna que ya no existe.
 *   Ya no se puede crear y, si quedó en la base, rompe cualquier INSERT/UPDATE en tareas.
 * - tr_cultivos_cancelar: versión anterior de tr_cultivos_cancelar_tareas
 *   (mismo código con otro nombre). Si quedan los dos, la regla se ejecuta dos veces.
 */
DROP TRIGGER IF EXISTS TR_ValidarTorreTarea;
DROP TRIGGER IF EXISTS tr_cultivos_cancelar;
GO


/*
 * Trigger: TR_ValidarCapacidadTorre
 *
 * Se ejecuta al insertar o actualizar un cultivo.
 * Comprueba que la cantidad total de plantas activas
 * no supere la capacidad máxima de la torre.
 * Si se supera el límite, cancela la operación.
 *
 * Objetivo: evitar que una torre exceda su capacidad.
 */
CREATE OR ALTER TRIGGER TR_ValidarCapacidadTorre
ON cultivos
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM sistema_torre AS st
        INNER JOIN inserted AS i
            ON st.id_torre = i.id_torre
        WHERE (
            SELECT ISNULL(SUM(c.cantidad_plantas), 0)
            FROM cultivos AS c
            WHERE c.id_torre = st.id_torre
              AND c.estado = 'EN PROGRESO'
        ) > st.capacidad_planta
    )
    BEGIN
        PRINT 'La torre supera su capacidad maxima.';
        ROLLBACK TRANSACTION;
    END;
END;
GO


/*
 * Trigger: tr_cultivos_capacidad
 *
 * Impide agregar más plantas de la capacidad que tiene una torre.
 */
CREATE OR ALTER TRIGGER tr_cultivos_capacidad
ON cultivos
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM sistema_torre t
        JOIN cultivos c ON c.id_torre = t.id_torre
        WHERE c.estado = 'EN PROGRESO'
          AND t.id_torre IN (SELECT id_torre FROM inserted)   -- solo las torres tocadas
        GROUP BY t.id_torre, t.capacidad_planta
        HAVING SUM(c.cantidad_plantas) > t.capacidad_planta
    )
        THROW 50020, 'La torre supera su capacidad de plantas.', 1;
END;
GO


/*
 * TRG_cultivos_set_fecha_cosecha
 *
 * Cuando un cultivo pasa a estado COSECHADO y fecha_cosecha todavía es NULL,
 * se completa automáticamente con la fecha actual.
 * Si ya existe una fecha de cosecha, no se pisa.
 */
CREATE OR ALTER TRIGGER TRG_cultivos_set_fecha_cosecha
ON cultivos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET c.fecha_cosecha = CAST(GETDATE() AS DATE)
    FROM cultivos c
    INNER JOIN inserted i ON i.id_cultivo = c.id_cultivo
    INNER JOIN deleted d  ON d.id_cultivo = c.id_cultivo
    WHERE i.estado = 'COSECHADO'
      AND d.estado <> 'COSECHADO'
      AND i.fecha_cosecha IS NULL;
END;
GO


/*
 * Trigger: tr_cultivos_cancelar_tareas
 *
 * Cancela las tareas abiertas cuando un cultivo pasa a MUERTO o COSECHADO.
 */
CREATE OR ALTER TRIGGER tr_cultivos_cancelar_tareas
ON cultivos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE t
    SET t.estado_tarea = 'CANCELADA'
    FROM tareas t
    JOIN inserted i ON t.id_cultivo = i.id_cultivo
    JOIN deleted d  ON d.id_cultivo = i.id_cultivo
    WHERE i.estado IN ('MUERTO', 'COSECHADO')
      AND d.estado = 'EN PROGRESO'
      AND t.estado_tarea IN ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO');
END;
GO


/*
 * TRG_tareas_set_fecha_ejecutada
 *
 * Cuando una tarea pasa a estado FINALIZADA y fecha_ejecutada todavía es NULL,
 * se completa automáticamente.
 * Si fecha_programada es futura (caso raro: tarea programada para después de hoy
 * pero cerrada ahora), se usa fecha_programada para no violar CHK_orden_fechas;
 * en el caso normal se usa la fecha actual.
 */
CREATE OR ALTER TRIGGER TRG_tareas_set_fecha_ejecutada
ON tareas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE t
    SET t.fecha_ejecutada = CASE
            WHEN t.fecha_programada > CAST(GETDATE() AS DATE) THEN t.fecha_programada
            ELSE CAST(GETDATE() AS DATE)
        END
    FROM tareas t
    INNER JOIN inserted i ON i.id_tarea = t.id_tarea
    INNER JOIN deleted d  ON d.id_tarea = t.id_tarea
    WHERE i.estado_tarea = 'FINALIZADA'
      AND d.estado_tarea <> 'FINALIZADA'
      AND i.fecha_ejecutada IS NULL;
END;
GO


/*
 * tr_tareas_empleado_activo
 *
 * Objetivo: no asignar tareas a empleados que ya no trabajan.
 * Se ejecuta al insertar una tarea o al cambiar su empleado.
 * Si el empleado está inactivo (estado = 0), cancela la operación.
 * Solo revisa cuando se carga o cambia el empleado.
 */
CREATE OR ALTER TRIGGER tr_tareas_empleado_activo
ON tareas
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(id_empleado) AND EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN empleado AS e
            ON i.id_empleado = e.id_empleado
        WHERE e.estado = 0
    )
    BEGIN
        THROW 50003, 'No se puede asignar la tarea a un empleado inactivo.', 1;
    END;
END;
GO


/*
 * tr_empleado_desactivar
 *
 * Objetivo: que ningún empleado quede dado de baja con tareas abiertas.
 * Se ejecuta al actualizar un empleado.
 * Si el empleado pasa de activo a inactivo (estado de 1 a 0) y tiene tareas
 * abiertas, cancela la operación.
 * Usa deleted para saber el estado anterior e inserted para el nuevo.
 */
CREATE OR ALTER TRIGGER tr_empleado_desactivar
ON empleado
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN deleted AS d
            ON i.id_empleado = d.id_empleado
        INNER JOIN tareas AS t
            ON t.id_empleado = i.id_empleado
        WHERE d.estado = 1
          AND i.estado = 0
          AND t.estado_tarea IN ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO')
    )
    BEGIN
        THROW 50004, 'El empleado tiene tareas abiertas, reasignelas antes de darlo de baja.', 1;
    END;
END;
GO


/*
 * tr_medicion_valores_validos
 *
 * Objetivo: proteger los datos aunque falle el sensor.
 * Se ejecuta al insertar una medición.
 * Comprueba que los valores sean físicamente posibles:
 *   - pH entre 0 y 14, EC no negativa y temperatura del agua entre 0 y 50.
 *   - Si algún valor está fuera de rango, cancela la operación.
 * Los valores NULL se aceptan porque el sensor puede no medir alguno.
 */
CREATE OR ALTER TRIGGER tr_medicion_valores_validos
ON medicion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ph < 0 OR ph > 14
           OR ec < 0
           OR temp_agua < 0 OR temp_agua > 50
    )
    BEGIN
        THROW 50001, 'La medicion tiene valores fisicamente imposibles.', 1;
    END;
END;
GO


/*
 * tr_medicion_sensor_activo
 *
 * Objetivo: no guardar lecturas de sensores que ya no están en funcionamiento.
 * Se ejecuta al insertar una medición.
 * Si el sensor fue dado de baja (activo = 0), cancela la operación.
 */
CREATE OR ALTER TRIGGER tr_medicion_sensor_activo
ON medicion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN sensor AS s
            ON i.id_sensor = s.id_sensor
        WHERE s.activo = 0
    )
    BEGIN
        THROW 50002, 'La medicion pertenece a un sensor inactivo.', 1;
    END;
END;
GO


/*
 * tr_sensor_unico_activo
 *
 * Objetivo: que cada torre tenga un solo sensor activo.
 * Se ejecuta al insertar o actualizar un sensor.
 * Si una torre queda con dos o más sensores activos, cancela la operación.
 * Para instalar uno nuevo, primero hay que dar de baja el anterior.
 */
CREATE OR ALTER TRIGGER tr_sensor_unico_activo
ON sensor
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM sensor AS s
        WHERE s.activo = 1
          AND s.id_torre IN (SELECT id_torre FROM inserted)
        GROUP BY s.id_torre
        HAVING COUNT(*) > 1
    )
    BEGIN
        THROW 50005, 'La torre ya tiene un sensor activo, desactivelo antes de agregar otro.', 1;
    END;
END;
GO

/*
Roles de seguridad para happy_hidro.
Se definen permisos por tabla en vez de usar un único usuario con acceso total,
para que la aplicación/empleados se conecten con el rol minimo necesario.
*/
USE happy_hidro;
GO

CREATE ROLE rol_lectura;
CREATE ROLE rol_operador;
CREATE ROLE rol_encargado;
CREATE ROLE rol_admin;
CREATE ROLE rol_sensor;
GO

/*
rol_lectura
Acceso de solo consulta a todas las tablas. Pensado para reportes/dashboards.
*/
GRANT SELECT ON SCHEMA::dbo TO rol_lectura;
GO

/*
rol_operador
Empleado de campo: puede ver todo, cargar mediciones de los sensores
y actualizar el avance de sus propias tareas y el estado de los cultivos
que atiende. No puede borrar nada ni tocar catalogos (especie, etapa, tipo_tareas)
ni la configuracion de torres/sensores/empleados.
*/
GRANT SELECT ON SCHEMA::dbo TO rol_operador;
GRANT UPDATE ON dbo.tareas TO rol_operador;
GRANT UPDATE ON dbo.cultivos TO rol_operador;
GO
  
/*
rol_sensor
Cuenta tecnica para los dispositivos o integraciones que envian mediciones
de pH, EC y temperatura. Solo puede registrar nuevas filas en medicion.
No puede leer datos, modificar ni borrar mediciones existentes, ni tocar
la configuracion de torres, sensores o cultivos.
*/
GRANT INSERT ON dbo.medicion TO rol_sensor; 
GO
  
/*
rol_encargado
Supervisor: hereda los permisos de rol_operador (se agrega como miembro)
y suma la gestion operativa completa: altas/bajas de torres, sensores,
cultivos, tareas, empleados y catalogos.
*/
ALTER ROLE rol_operador ADD MEMBER rol_encargado;
GO

GRANT INSERT, UPDATE, DELETE ON dbo.sistema_torre TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.sensor TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.cultivos TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.tareas TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.empleado TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.especie TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.etapa TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.especie_etapa TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.tipo_tareas TO rol_encargado;
GO

/*
rol_admin
Control total sobre la base (DBA). Se implementa agregandolo como miembro
del rol fijo db_owner.
*/
ALTER ROLE db_owner ADD MEMBER rol_admin;
GO

/*
Ejemplo de uso: crear un login/usuario y asignarlo a un rol.
(Reemplazar 'NombreLogin' y la contraseña por los datos reales.)
*/
-- CREATE LOGIN juan_operador WITH PASSWORD = 'ContraseñaSegura123!';
-- CREATE USER juan_operador FOR LOGIN juan_operador;
-- ALTER ROLE rol_operador ADD MEMBER juan_operador;

USE happy_hidro;
GO

/*
Consulta 1:
Cultivos que se encuentran actualmente en progreso,
indicando especie, torre, fecha de inicio y cantidad de plantas.
*/
select id_cultivo, id_especie, id_torre, fecha_inicio, cantidad_plantas
from cultivos
where estado = 'EN PROGRESO';
GO

/*
Consulta 2:
Lista de empleados ordenados primero por apellido,
indicando nombre y apellido.
*/
select nombre, apellido
from empleado
order by apellido, nombre;
GO

/*
Consulta 3:
Cultivos que se encuentran actualmente en el invernadero
(en progreso, o en mantenimiento), indicando la especie,
y la ubicacion fisica de la torre (torre, lote y rack).
Se dejan afuera los cosechados y muertos porque ya no ocupan la torre.
Ordenado por ubicacion para recorrer el invernadero en orden.
*/
select c.id_cultivo, e.nombre as especie, t.id_torre as torre, t.ubicacion_lote as lote, t.ubicacion_rack as rack, c.cantidad_plantas, c.estado, c.fecha_inicio
from cultivos c
join especie e on c.id_especie = e.id_especie
join sistema_torre t on c.id_torre = t.id_torre
where c.estado in ('EN PROGRESO', 'MANTENIMIENTO')
order by lote, rack;
GO

/*
Consulta 4:
Cantidad de cultivos y total de plantas por cada estado
(en progreso, cosechado, muerto, mantenimiento).
Ordenado de mayor a menor cantidad de cultivos.
*/
select estado, count(*) as cultivos, sum(cantidad_plantas) as plantas
from cultivos
group by estado
order by cultivos desc;
GO

/*
Consulta 5:
Tareas finalizadas, indicando la torre, empleado que la realizo,
el tipo de tarea con su descripcion, la fecha de ejecucion y observaciones.
Ordenado de la mas reciente a la mas antigua.
*/
select t.id_tarea, e.nombre as nombre_empleado, e.apellido as apellido_empleado, x.nombre as tarea, x.descripcion as tarea_descripcion, t.fecha_ejecutada, t.observaciones
from tareas t
join tipo_tareas as x on t.id_tipo_tarea = x.id_tipo_tarea
join empleado as e on t.id_empleado = e.id_empleado
where t.estado_tarea = 'FINALIZADA'
order by t.fecha_ejecutada desc;
GO

/*
Consulta 6:
Lotes del invernadero que tienen mas de 3 torres,
indicando la cantidad de torres en las que se encuentran.
*/
select ubicacion_lote as lote, count(*) as torres
from sistema_torre
group by ubicacion_lote
having count(*) > 3;
GO

/*
Consulta 7: Ocupación de torres
Muestra la capacidad máxima de cada torre,
la cantidad total de plantas activas y los
lugares disponibles para nuevos cultivos.
 */
SELECT
    st.id_torre,
    st.capacidad_planta,
    ISNULL(SUM(c.cantidad_plantas), 0) AS plantas_actuales,
    st.capacidad_planta -
        ISNULL(SUM(c.cantidad_plantas), 0) AS disponibles
FROM sistema_torre AS st
LEFT JOIN cultivos AS c
    ON st.id_torre = c.id_torre
    AND c.estado IN ('EN PROGRESO', 'MANTENIMIENTO')
GROUP BY
    st.id_torre,
    st.capacidad_planta
ORDER BY st.id_torre;


/*
Consulta 8: Tareas por empleado
Muestra cada empleado junto con la cantidad
total de tareas asignadas y las finalizadas.
*/
SELECT
    e.id_empleado,
    e.nombre,
    e.apellido,
    COUNT(t.id_tarea) AS total_tareas,
    SUM(
        CASE
            WHEN t.estado_tarea = 'FINALIZADA' THEN 1
            ELSE 0
        END
    ) AS tareas_finalizadas
FROM empleado AS e
LEFT JOIN tareas AS t
    ON e.id_empleado = t.id_empleado
GROUP BY
    e.id_empleado,
    e.nombre,
    e.apellido
ORDER BY tareas_finalizadas DESC;


/*
Consulta 9: Duracion hasta COSECHA
Cultivos que ya fueron cosechados, indicando su especie,
la fecha de inicio, la fecha de cosecha y la cantidad
de dias que transcurrieron entre ambas fechas.
*/
SELECT
    c.id_cultivo,
    e.nombre AS especie,
    c.fecha_inicio,
    c.fecha_cosecha,
    DATEDIFF(DAY, c.fecha_inicio, c.fecha_cosecha)
        AS dias_produccion
FROM cultivos AS c
INNER JOIN especie AS e
    ON c.id_especie = e.id_especie
WHERE c.estado = 'COSECHADO'
ORDER BY dias_produccion DESC;
GO


/*
Consulta 10: Torres con nivel de agua es inferior al 50%.
Permite identificar las torres que necesitan
una reposicion de agua.
*/
SELECT
    id_torre,
    ubicacion_lote AS lote,
    ubicacion_rack AS rack,
    max_agua,
    agua_actual,
    ROUND(agua_actual * 100.0 / max_agua, 2)
        AS porcentaje_agua
FROM sistema_torre
WHERE agua_actual < max_agua * 0.5
ORDER BY porcentaje_agua ASC;
GO

USE happy_hidro;
GO

/*
Subconsulta 1:
Que se quiere obtener: Los cultivos actuales del invernadero (en progreso o en mantenimiento) que superan el promedio de plantas, para identificar los cultivos principales.
Funcion de la subconsulta: Calcula el promedio de plantas de los cultivos actuales y devuelve un unico valor, que se usa como condicion en la consulta principal.
Por que es adecuada: La cantidad de plantas cambia constantemente, calcular el promedio en el momento garantiza que el resultado este siempre actualizado.
*/
select c.id_cultivo, e.nombre as especie, c.cantidad_plantas
from cultivos c
join especie e on c.id_especie = e.id_especie
where c.estado in ('EN PROGRESO', 'MANTENIMIENTO') and c.cantidad_plantas > (select avg(cantidad_plantas) from cultivos where estado in ('EN PROGRESO', 'MANTENIMIENTO'))
order by c.cantidad_plantas desc;
GO

/*
Subconsulta 2:
Que se quiere obtener: Los empleados que tienen tareas pendientes en el invernadero.
Funcion de la subconsulta: Devuelve la lista de ids de los empleados que tienen tareas con estado pendiente.
Por que es adecuada: Primero se necesita saber quien tiene asignadas tareas pendientes, para luego buscar los datos de esos empleados.
*/
select id_empleado, nombre, apellido
from empleado
where id_empleado in (select id_empleado from tareas where estado_tarea = 'PENDIENTE');
GO

/*
Subconsulta 3:
Que se quiere obtener: Las torres que estan completamente vacias, para planificar como llenarlas.
Funcion de la subconsulta: Devuelve la lista de ids de las torres que tienen cultivos en progreso o en mantenimiento, es decir, las torres que no estan vacias.
Por que es adecuada: Las torres se vacian a medida que los cultivos se cosechan o se descartan, por lo que primero se necesita conocer la informacion actualizada de las torres ocupadas para luego obtener las que no estan en esa lista.
*/
select id_torre, ubicacion_lote as lote, ubicacion_rack as rack, capacidad_planta as capacidad
from sistema_torre
where id_torre not in (select id_torre from cultivos where estado in ('EN PROGRESO', 'MANTENIMIENTO'));
GO

/*
 * Consulta: q_torres_libres
 *
 * Torres sin ningún cultivo EN PROGRESO, disponibles para sembrar.
 */
SELECT t.id_torre,
       t.ubicacion_lote,
       t.ubicacion_rack,
       t.capacidad_planta
FROM sistema_torre t
WHERE NOT EXISTS (
    SELECT 1
    FROM cultivos c
    WHERE c.id_torre = t.id_torre AND c.estado = 'EN PROGRESO'
)
ORDER BY t.ubicacion_lote, t.ubicacion_rack;
