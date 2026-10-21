USE master;
GO
/* sistema_torre:
Torre donde se plantan los cultivos, cada torre tiene un limite de agua y capacidad de plantas.
Y, ubicacion_lote y ubicacion_rack son para identificar la torre en el invernadero.
 agua_actual es la cantidad de agua que hay actualmente en la torre, no puede ser negativa ni superar max_agua.
*/
CREATE TABLE sistema_torre (
	id_torre INT IDENTITY(1,1) PRIMARY KEY,
	max_agua DECIMAL(6,2) NOT NULL,
	capacidad_planta INT NOT NULL,
	ubicacion_lote VARCHAR(2) NOT NULL,
	ubicacion_rack VARCHAR(1) NOT NULL,
	agua_actual INT NOT NULL DEFAULT 0,
	CONSTRAINT CHK_agua_positivo CHECK (agua_actual >= 0),
	CONSTRAINT CHK_agua_max CHECK (agua_actual <= max_agua)
);
GO
/*
Especie
cada tipo de planta que se puede cultivar, con sus parametros optimos de pH, EC y temperatura de agua.
nombre debe ser unico, no puede haber dos especies con el mismo nombre.
ph_optimo, ec_optimo y temp_agua_optimo pueden ser null si no se conoce el valor optimo para esa especie.
*/
CREATE TABLE especie (
	id_especie INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	ph_optimo DECIMAL(3,1) NULL,
	ec_optimo DECIMAL(4,2) NULL,
	temp_agua_optimo DECIMAL(3,1) NULL,
	CONSTRAINT UQ_especie_nombre UNIQUE (nombre)
);
GO


/* 
Cultivos
cultivo activo en una torre
fecha_cosecha es null mientras no se haya cosechado
estado: EN PROGRESO, COSECHADO, MUERTO o MANTENIMIENTO
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
	CONSTRAINT CHK_estado_cultivo CHECK (estado IN ('EN PROGRESO', 'COSECHADO', 'MUERTO', 'MANTENIMIENTO')),
	CONSTRAINT CHK_plantas CHECK (cantidad_plantas IS NULL OR cantidad_plantas > 0),
	CONSTRAINT CHK_fecha_cosecha CHECK (fecha_cosecha IS NULL OR fecha_cosecha >= fecha_inicio)
);
GO

/* parametros:
define los parametros que se miden (pH, EC, temperatura...)
*/
CREATE TABLE parametros (
	id_parametro INT IDENTITY(1,1) PRIMARY KEY,
	parametro_descripcion VARCHAR(50) NOT NULL,
	maximo DECIMAL(6,2) NULL,
	minimo DECIMAL(6,2) NULL
);
GO
/* parametros por cultivo:
medicion concreta de un parametro para un cultivo
*/
CREATE TABLE parametros_por_cultivo (
	id_cultivo INT NOT NULL,
	id_parametro INT NOT NULL,
	ph_actual DECIMAL(3,1) NULL,
	ec_actual DECIMAL(4,2) NULL,
	temp_agua_actual DECIMAL(3,1) NULL,
	fecha_medicion DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_parametros_cultivo PRIMARY KEY (id_cultivo, id_parametro, fecha_medicion),
	CONSTRAINT FK_pc_cultivo FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo),
	CONSTRAINT FK_pc_parametro FOREIGN KEY (id_parametro) REFERENCES parametros(id_parametro)
);
GO
/* empleado:
identifica a un empleado que puede ejecutar tareas sobre los cultivos o las torres
*/
CREATE TABLE empleado (
	id_empleado INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL
);
GO
/* tipo_tareas:
identifica los tipos de tareas que se pueden realizar sobre los cultivos o las torres,
solo se puede crear un tipo de tarea con un nombre unico, la descripcion es opcional.
*/
CREATE TABLE tipo_tareas (
	id_tipo_tarea INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(100) NULL,
	CONSTRAINT UQ_tipo_tarea UNIQUE (nombre)
);
GO

/* tareas:
identifica una tarea concreta que se debe realizar sobre un cultivo o una torre, asignada a un empleado.
es determinada por un tipo de tarea, y puede tener una fecha programada y una fecha ejecutada.
Tiene un estado que puede ser PENDIENTE, PROGRAMADA, EN PROGRESO, FINALIZADA o CANCELADA.
y hace referencia a un cultivo o a una torre, pero no necesariamente a ambos.
Tiene un chequeo de integridad que asegura que si el estado es PROGRAMADA, EN PROGRESO o FINALIZADA, debe tener una fecha programada.
*/
CREATE TABLE tareas (
	id_tarea INT IDENTITY(1,1) PRIMARY KEY,
	id_tipo_tarea INT NOT NULL,
	id_torre INT NOT NULL,
	id_cultivo INT NULL,
	id_empleado INT NOT NULL,
	fecha_programada DATE NULL,
	fecha_ejecutada DATE NULL,
	estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
	observaciones VARCHAR(255) NULL,
	CONSTRAINT FK_tarea_tipo FOREIGN KEY (id_tipo_tarea) REFERENCES tipo_tareas(id_tipo_tarea),
	CONSTRAINT FK_tarea_torre FOREIGN KEY (id_torre) REFERENCES sistema_torre(id_torre),
	CONSTRAINT FK_tarea_cultivo FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo),
	CONSTRAINT FK_tarea_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
	CONSTRAINT CHK_estado CHECK (estado IN ('PENDIENTE', 'PROGRAMADA', 'EN PROGRESO', 'FINALIZADA', 'CANCELADA')),
	CONSTRAINT CHK_fecha_prog CHECK (
		estado NOT IN ('PROGRAMADA', 'EN PROGRESO', 'FINALIZADA')
		OR fecha_programada IS NOT NULL
	),
	CONSTRAINT CHK_fecha_ejec CHECK (
		estado <> 'FINALIZADA'
		OR fecha_ejecutada IS NOT NULL
	),
	CONSTRAINT CHK_orden_fechas CHECK (
		fecha_ejecutada IS NULL
		OR fecha_programada IS NULL
		OR fecha_ejecutada >= fecha_programada
	)
);
GO
