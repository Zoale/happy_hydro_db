USE happy_hidro;
GO

/*
 * Consulta: Ocupación de torres
 *
 * Muestra la capacidad máxima de cada torre,
 * la cantidad total de plantas activas y los
 * lugares disponibles para nuevos cultivos.
 *
 */
SELECT
    st.id_torre,
    st.capacidad_planta,
    ISNULL(SUM(c.cantidad_plantas), 0) AS plantas_actuales,
    st.capacidad_planta -
        ISNULL(SUM(c.cantidad_plantas), 0) AS disponibles
FROM sistema_torre AS st
LEFT JOIN cultivos AS c
    ON st.id_torre = c.id_torre
    AND c.estado IN ('EN PROGRESO', 'MANTENIMIENTO')
GROUP BY
    st.id_torre,
    st.capacidad_planta
ORDER BY st.id_torre;


/*
 * Consulta: Tareas por empleado
 *
 * Muestra cada empleado junto con la cantidad
 * total de tareas asignadas y las finalizadas.
 *
 */
SELECT
    e.id_empleado,
    e.nombre,
    e.apellido,
    COUNT(t.id_tarea) AS total_tareas,
    SUM(
        CASE
            WHEN t.estado = 'FINALIZADA' THEN 1
            ELSE 0
        END
    ) AS tareas_finalizadas
FROM empleado AS e
LEFT JOIN tareas AS t
    ON e.id_empleado = t.id_empleado
GROUP BY
    e.id_empleado,
    e.nombre,
    e.apellido
ORDER BY tareas_finalizadas DESC;


/*
 * Consulta: Duracion hasta COSECHA
 *
 * Cultivos que ya fueron cosechados, indicando su especie,
 * la fecha de inicio, la fecha de cosecha y la cantidad
 * de dias que transcurrieron entre ambas fechas.
 *
 */
SELECT
    c.id_cultivo,
    e.nombre AS especie,
    c.fecha_inicio,
    c.fecha_cosecha,
    DATEDIFF(DAY, c.fecha_inicio, c.fecha_cosecha)
        AS dias_produccion
FROM cultivos AS c
INNER JOIN especie AS e
    ON c.id_especie = e.id_especie
WHERE c.estado = 'COSECHADO'
ORDER BY dias_produccion DESC;
GO


/*
 * Consulta: Torres con nivel de agua es inferior al 50%.
 *
 * Permite identificar las torres que necesitan
 * una reposicion de agua.
 *
 */
SELECT
    id_torre,
    ubicacion_lote AS lote,
    ubicacion_rack AS rack,
    max_agua,
    agua_actual,
    ROUND(agua_actual * 100.0 / max_agua, 2)
        AS porcentaje_agua
FROM sistema_torre
WHERE agua_actual < max_agua * 0.5
ORDER BY porcentaje_agua ASC;
GO
