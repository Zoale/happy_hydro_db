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
