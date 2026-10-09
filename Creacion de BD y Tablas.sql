/* Creación de la base de datos happy_hidro */
CREATE DATABASE happy_hidro;
GO

USE happy_hidro;
GO

/* Creación de las tablas de happy_hidro */

/* Creación de la tabla "Sistemas" */
CREATE TABLE sistemas (
    id_sistema int IDENTITY PRIMARY KEY,
    tipo varchar(30) NOT NULL,
    capacidad int NOT NULL,
    ubicacion varchar(50) NOT NULL,
    CONSTRAINT chk_tipo CHECK (tipo IN ('NFT', 'raiz flotante', 'aeroponía', 'goteo'))
);
GO

/* Creación de la tabla "Soluciones_nutritivas" */
CREATE TABLE soluciones_nutritivas (
    id_solucion int IDENTITY PRIMARY KEY,
    nombre varchar(50) NOT NULL,
    nitrogeno decimal(3,0) NOT NULL,
    fosforo decimal(3,0) NOT NULL,
    potasio decimal(3,0) NOT NULL,
    conductividad_ec decimal(4,0) NOT NULL   -- EC de la solución
);
GO

/* Creación de la tabla "Especies" */
CREATE TABLE especies (
    id_especie int IDENTITY PRIMARY KEY,
    nombre varchar(50) NOT NULL,
    ph_minimo_idea decimal(2,1) NOT NULL,
    ph_maximo_idea decimal(2,1) NOT NULL,
    dias_hasta_cosecha int NOT NULL
);
GO

/* Creación de la tabla "Cultivos" */
CREATE TABLE cultivos (
    id_cultivo int IDENTITY PRIMARY KEY,
    fecha_siembra date,
    cantidad int NOT NULL,
    estado varchar(50) NOT NULL,
    id_sistema int FOREIGN KEY REFERENCES sistemas(id_sistema),
    id_especie int FOREIGN KEY REFERENCES especies(id_especie)
);
GO

/* Creación de la tabla "Mediciones" */
CREATE TABLE mediciones (
    id_medicion int IDENTITY PRIMARY KEY,
    id_sistema int NOT NULL FOREIGN KEY REFERENCES sistemas(id_sistema),
    fecha_hora datetime2 NOT NULL DEFAULT SYSDATETIME(),
    ph decimal(3,1) NOT NULL,
    ec decimal(4,2) NOT NULL,                 -- mS/cm
    temperatura_agua decimal(4,1) NOT NULL,   -- °C
    oxigeno_disuelto decimal(4,2) NOT NULL    -- mg/L
);
GO

/* Creación de la tabla "Empleado" (propuesta: revisar atributos) */
CREATE TABLE empleado (
    id_empleado int IDENTITY PRIMARY KEY,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    rol varchar(30) NOT NULL,
    email varchar(100) UNIQUE,
    fecha_ingreso date NOT NULL
);
GO

/* Creación de la tabla "Tareas_Empleado" (propuesta: revisar atributos) */
CREATE TABLE tareas_empleado (
    id_tarea int IDENTITY PRIMARY KEY,
    id_empleado int NOT NULL FOREIGN KEY REFERENCES empleado(id_empleado),
    id_sistema int FOREIGN KEY REFERENCES sistemas(id_sistema),
    descripcion varchar(200) NOT NULL,
    fecha_asignacion date NOT NULL,
    fecha_realizacion date,
    estado varchar(20) NOT NULL DEFAULT 'pendiente',
    CONSTRAINT chk_estado_tarea CHECK (estado IN ('pendiente', 'en curso', 'completada'))
);
GO

/* Creación de la tabla "Auditoria_de_base" (propuesta: registro de cambios) */
CREATE TABLE auditoria_de_base (
    id_auditoria int IDENTITY PRIMARY KEY,
    tabla varchar(50) NOT NULL,
    operacion varchar(10) NOT NULL,
    id_registro int,
    usuario varchar(50) NOT NULL DEFAULT SUSER_SNAME(),
    fecha_hora datetime2 NOT NULL DEFAULT SYSDATETIME(),
    detalle varchar(MAX),
    CONSTRAINT chk_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
);
GO