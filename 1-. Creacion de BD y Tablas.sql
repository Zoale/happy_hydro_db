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
    CONSTRAINT CHK_estado_cultivo CHECK (estado IN ('EN PROGRESO', 'COSECHADO', 'MUERTO')),
    CONSTRAINT CHK_plantas CHECK (cantidad_plantas IS NULL OR cantidad_plantas > 0),
    CONSTRAINT CHK_fecha_cosecha CHECK (fecha_cosecha IS NULL OR fecha_cosecha >= fecha_inicio)
);
GO

/*
empleado
identifica a un empleado que puede ejecutar tareas sobre los cultivos o las torres
*/
CREATE TABLE empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL
);
GO

/*
tipo_tareas
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

/*
tareas
identifica una tarea concreta que se debe realizar sobre un cultivo o una torre, asignada a un empleado.
es determinada por un tipo de tarea, y puede tener una fecha programada y una fecha ejecutada.
Tiene un estado_tarea que puede ser PENDIENTE, PROGRAMADA, EN PROGRESO, FINALIZADA o CANCELADA.
y siempre hace referencia a una torre y opcionalmente a un cultivo.
Tiene un chequeo de integridad que asegura que si el estado_tarea es PROGRAMADA, EN PROGRESO o FINALIZADA, debe tener una fecha programada.
*/
CREATE TABLE tareas (
    id_tarea INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo_tarea INT NOT NULL,
    id_torre INT NOT NULL,
    id_cultivo INT NULL,
    id_empleado INT NOT NULL,
    fecha_programada DATE NULL,
    fecha_ejecutada DATE NULL,
    estado_tarea VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    observaciones VARCHAR(255) NULL,
    CONSTRAINT FK_tarea_tipo FOREIGN KEY (id_tipo_tarea) REFERENCES tipo_tareas(id_tipo_tarea),
    CONSTRAINT FK_tarea_torre FOREIGN KEY (id_torre) REFERENCES sistema_torre(id_torre),
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
