USE happy_hidro;
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
ALTER TRIGGER TR_ValidarCapacidadTorre
ON cultivos
AFTER INSERT, UPDATE
AS
BEGIN
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
    END
END;
GO
/*
 * Trigger: TR_ValidarTorreTarea
 *
 * Se ejecuta al insertar o actualizar una tarea.
 * Verifica que el cultivo asociado pertenezca
 * a la misma torre indicada en la tarea.
 * Si las torres no coinciden, cancela la operación.
 *
 * Objetivo: mantener la coherencia entre tareas,
 * cultivos y torres.
 */
CREATE TRIGGER TR_ValidarTorreTarea
ON tareas
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN cultivos AS c
            ON i.id_cultivo = c.id_cultivo
        WHERE i.id_torre <> c.id_torre
    )
    BEGIN
        PRINT 'El cultivo no pertenece a la torre indicada.';
        ROLLBACK TRANSACTION;
    END
END;
GO

/*
TRG_cultivos_set_fecha_cosecha
La función de este trigger es que cuando un cultivo pasa a estado COSECHADO y fecha_cosecha todavia es null,
se completa automaticamente con la fecha actual. Si existe una fecha de cosecha, no se pisa.
*/
CREATE TRIGGER TRG_cultivos_set_fecha_cosecha
ON cultivos
AFTER UPDATE
AS
BEGIN

    UPDATE c
    SET c.fecha_cosecha = CAST(GETDATE() AS DATE)
    FROM cultivos c
    INNER JOIN inserted i ON i.id_cultivo = c.id_cultivo
    INNER JOIN deleted d ON d.id_cultivo = c.id_cultivo
    WHERE i.estado = 'COSECHADO'
      AND d.estado <> 'COSECHADO'
      AND i.fecha_cosecha IS NULL;
END
GO

/*
TRG_tareas_set_fecha_ejecutada
La función de este Trigger es que cuando una tarea pasa a estado FINALIZADA y fecha_ejecutada todavia es null, se completa automaticamente. 
Si fecha_programada es futura (caso raro, tarea programada para despues de hoy pero cerrada ahora), 
se usa fecha_programada para no violar CHK_orden_fechas; en el caso normal se usa la fecha actual.
*/
CREATE TRIGGER TRG_tareas_set_fecha_ejecutada
ON tareas
AFTER UPDATE
AS
BEGIN
    UPDATE t
    SET t.fecha_ejecutada = CASE
            WHEN t.fecha_programada > CAST(GETDATE() AS DATE) THEN t.fecha_programada
            ELSE CAST(GETDATE() AS DATE)
        END
    FROM tareas t
    INNER JOIN inserted i ON i.id_tarea = t.id_tarea
    INNER JOIN deleted d ON d.id_tarea = t.id_tarea
    WHERE i.estado_tarea = 'FINALIZADA'
      AND d.estado_tarea <> 'FINALIZADA'
      AND i.fecha_ejecutada IS NULL;
END
GO

/*
tr_medicion_valores_validos
Objetivo: Proteger los datos aunque falle el sensor.
Se ejecuta al insertar una medicion.
Comprueba que los valores sean fisicamente posibles:
    - pH entre 0 y 14, EC no negativa y temperatura del agua entre 0 y 50.
    - Si algun valor esta fuera de rango, cancela la operacion.
Los valores null se aceptan porque el sensor puede no medir alguno.
*/
CREATE TRIGGER tr_medicion_valores_validos
ON medicion
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ph < 0 OR ph > 14
           OR ec < 0
           OR temp_agua < 0 OR temp_agua > 50
    )
    BEGIN
        THROW 50001, 'La medicion tiene valores fisicamente imposibles.', 1;
    END
END;
GO

/*
tr_medicion_sensor_activo
Objetivo: No guardar lecturas de sensores que ya no estan en funcionamiento.
Se ejecuta al insertar una medicion.
Comprueba que el sensor que envia la medicion este activo.
Si el sensor fue dado de baja (activo = 0), cancela la operacion.
*/
CREATE TRIGGER tr_medicion_sensor_activo
ON medicion
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN sensor AS s
            ON i.id_sensor = s.id_sensor
        WHERE s.activo = 0
    )
    BEGIN
        THROW 50002, 'La medicion pertenece a un sensor inactivo.', 1;
    END
END;
GO

/*
tr_tareas_empleado_activo
Objetivo: No asignar tareas a empleados que ya no trabajan.
Se ejecuta al insertar una tarea o al cambiar empleado.
Comprueba que el empleado asignado este activo.
Si el empleado esta inactivo (estado = 0), cancela la operacion.
Solo revisa cuando se carga o cambia el empleado.
*/
CREATE TRIGGER tr_tareas_empleado_activo
ON tareas
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(id_empleado) AND EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN empleado AS e
            ON i.id_empleado = e.id_empleado
        WHERE e.estado = 0
    )
    BEGIN
        THROW 50003, 'No se puede asignar la tarea a un empleado inactivo.', 1;
    END
END;
GO

/*
tr_empleado_desactivar
Objetivo: Que ningun empleado quede dado de baja con tareas abiertas,
Se ejecuta al actualizar un empleado.
Si el empleado pasa de activo a inactivo (estado de 1 a 0) y tiene tareas, cancela la operacion.
Usa deleted para saber el estado anterior e inserted para el nuevo.
*/
CREATE TRIGGER tr_empleado_desactivar
ON empleado
AFTER UPDATE
AS
BEGIN
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
    END
 * Trigger: tr_cultivos_capacidad
 *
 * Limita no agregas mas plantas de la capacidad que tiene una torre
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
tr_sensor_unico_activo
Objetivo: Que cada torre tenga un solo sensor activo,
Se ejecuta al insertar o actualizar un sensor.
Comprueba que las torres afectadas no queden con mas de un sensor activo.
Si una torre queda con dos o mas sensores activos, cancela la operacion.
Para instalar uno nuevo primero hay que dar de baja el anterior.
*/
CREATE TRIGGER tr_sensor_unico_activo
ON sensor
AFTER INSERT, UPDATE
AS
BEGIN
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
    END
END;
GO
 * Trigger: tr_cultivos_cancelar_tareas
 *
 * Cancela tareas cuando un cultivo pasa a MUERTO o COSECHADO.
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
    JOIN deleted d ON d.id_cultivo = i.id_cultivo
    WHERE (i.estado IN ('MUERTO','COSECHADO')) AND 
          (d.estado = 'EN PROGRESO') AND 
          (t.estado_tarea IN ('PENDIENTE','ASIGNADA','EN PROGRESO'));
    END;
    GO

/*
 * Trigger: tr_cultivos_capacidad
 *
 * Limita no agregas mas plantas de la capacidad que tiene una torre
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
 * Trigger: tr_cultivos_cancelar_tareas
 *
 * Cancela tareas cuando un cultivo pasa a MUERTO o COSECHADO.
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
    JOIN deleted d ON d.id_cultivo = i.id_cultivo
    WHERE (i.estado IN ('MUERTO','COSECHADO')) AND 
          (d.estado = 'EN PROGRESO') AND 
          (t.estado_tarea IN ('PENDIENTE','ASIGNADA','EN PROGRESO'));
    END;
    GO
