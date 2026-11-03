
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
CREATE PROCEDURE SP_RegistrarCultivo
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
CREATE PROCEDURE SP_FinalizarTarea
    @id_tarea INT
AS
BEGIN
    UPDATE tareas
    SET estado_tarea = 'FINALIZADA',
        fecha_ejecutada = GETDATE()
    WHERE id_tarea = @id_tarea
      AND estado_tarea IN 'EN PROGRESO'
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

CREATE PROCEDURE SP_CultivoMuerto
@id_cultivo INT
AS
BEGIN 
    UPDATE cultivos
    SET estado  = 'MUERTO'
    WHERE id_cultivo = @id_cultivo AND estado  = 'EN PROGRESO'
    END;
    GO


/*
 * Procedimiento: SP_CultivoMuerto
 *
 * Cambiar el estado de un cultivo "EN PROGRESO" a "COSECHADO" al finalizar el mismo
 * registrando fecha de cosecha
 * Objetivo: automatizar la finalización de tareas.
 */

CREATE PROCEDURE SP_CultivoCosechado
@id_cultivo INT
AS
BEGIN 
    UPDATE cultivos
    SET estado  = 'COSECHADO', fecha_cosecha = GETDATE();
    WHERE id_cultivo = @id_cultivo AND estado  = 'EN PROGRESO'
    END;
    GO

/*
 * Procedimiento: SP_SensorReporte
 *
 * Actulizar la medicion del PH, EC , TEMP y Nivel de agua de una torre
 * reportada por la API del sensor
 *
 */

CREATE PROCEDURE SP_SensorReporte
@id_sensor INT
@ph decimal(3,1)
@ec decimal(3,1)
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

ALTER PROCEDURE SP_altaEmpleados
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

USE happy_hidro;
GO

CREATE PROCEDURE SP_Sensor_Insertar
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




/*
 * SP_Sensor_Actualizar
 *
 * Modifica la torre, el modelo y el estado de un sensor.
 */

USE happy_hidro;
GO  
    
CREATE PROCEDURE SP_Sensor_Actualizar
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
    SET @id_sensor = SCOPE_IDENTITY();
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
