
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
 * Verifica que se encuentre PROGRAMADA o EN PROGRESO
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
      AND estado_tarea IN ('PROGRAMADA', 'EN PROGRESO')
      AND fecha_programada <= GETDATE();
END;
GO
