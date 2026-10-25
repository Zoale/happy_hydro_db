USE happy_hidro;
GO

/*
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
        FROM sistema_torre st
        INNER JOIN inserted i
            ON st.id_torre = i.id_torre
        WHERE (
            SELECT ISNULL(SUM(c.cantidad_plantas), 0)
            FROM cultivos c
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
