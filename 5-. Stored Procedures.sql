USE happy_hidro;
GO

/*
 *
 * Permite registrar un nuevo cultivo en el sistema hidropónico.
 * Recibe la especie, la torre y la cantidad de plantas.
 * Inserta el cultivo con la fecha actual y el estado EN PROGRESO.
 *
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
