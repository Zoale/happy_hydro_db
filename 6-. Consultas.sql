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
FROM sistema_torre st
LEFT JOIN cultivos c
    ON st.id_torre = c.id_torre
    AND c.estado IN ('EN PROGRESO', 'MANTENIMIENTO')
GROUP BY
    st.id_torre,
    st.capacidad_planta
ORDER BY st.id_torre;
