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
CREATE TRIGGER TR_ValidarCapacidadTorre
ON cultivos
AFTER INSERT, UPDATE
AS
BEGIN
    -- Verificamos si alguna torre supera su capacidad.
    IF EXISTS (
        SELECT 1
        FROM sistema_torre AS st
        INNER JOIN inserted AS i
            ON st.id_torre = i.id_torre
        WHERE (
            SELECT ISNULL(SUM(c.cantidad_plantas), 0)
            FROM cultivos AS c
            WHERE c.id_torre = st.id_torre
              AND c.estado IN (
                  'EN PROGRESO',
                  'MANTENIMIENTO'
              )
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
