USE happy_hidro;
GO

/*
Consulta 1:
Cultivos que se encuentran actualmente en progreso,
indicando especie, torre, fecha de inicio y cantidad de plantas.
*/
select id_cultivo, id_especie, id_torre, fecha_inicio, cantidad_plantas
from cultivos
where estado = 'EN PROGRESO';
GO

/*
Consulta 2:
Lista de empleados ordenados primero por apellido,
indicando nombre y apellido.
*/
select nombre, apellido
from empleado
order by apellido, nombre;
GO

/*
Consulta 3:
Cultivos que se encuentran actualmente en el invernadero
(en progreso, o en mantenimiento), indicando la especie,
y la ubicacion fisica de la torre (torre, lote y rack).
Se dejan afuera los cosechados y muertos porque ya no ocupan la torre.
Ordenado por ubicacion para recorrer el invernadero en orden.
*/
select c.id_cultivo, e.nombre as especie, t.id_torre as torre, t.ubicacion_lote as lote, t.ubicacion_rack as rack, c.cantidad_plantas, c.estado, c.fecha_inicio
from cultivos c
join especie e on c.id_especie = e.id_especie
join sistema_torre t on c.id_torre = t.id_torre
where c.estado in ('EN PROGRESO', 'MANTENIMIENTO')
order by lote, rack;
GO

/*
Consulta 4:
Cantidad de cultivos y total de plantas por cada estado
(en progreso, cosechado, muerto, mantenimiento).
Ordenado de mayor a menor cantidad de cultivos.
*/
select estado, count(*) as cultivos, sum(cantidad_plantas) as plantas
from cultivos
group by estado
order by cultivos desc;
GO

/*
Consulta 5:
Tareas finalizadas, indicando la torre, empleado que la realizo,
el tipo de tarea con su descripcion, la fecha de ejecucion y observaciones.
Ordenado de la mas reciente a la mas antigua.
*/
select t.id_tarea, t.id_torre, e.nombre as nombre_empleado, e.apellido as apellido_empleado, x.nombre as tarea, x.descripcion as tarea_descripcion, t.fecha_ejecutada, t.observaciones
from tareas t
join tipo_tareas as x on t.id_tipo_tarea = x.id_tipo_tarea
join empleado as e on t.id_empleado = e.id_empleado
where t.estado = 'FINALIZADA'
order by t.fecha_ejecutada desc;
GO

/*
Consulta 6:
Lotes del invernadero que tienen mas de 3 torres,
indicando la cantidad de torres en las que se encuentran.
*/
select ubicacion_lote as lote, count(*) as torres
from sistema_torre
group by ubicacion_lote
having count(*) > 3;
GO

/*
Consulta 7: Ocupación de torres
Muestra la capacidad máxima de cada torre,
la cantidad total de plantas activas y los
lugares disponibles para nuevos cultivos.
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
Consulta 8: Tareas por empleado
Muestra cada empleado junto con la cantidad
total de tareas asignadas y las finalizadas.
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
Consulta 9: Duracion hasta COSECHA
Cultivos que ya fueron cosechados, indicando su especie,
la fecha de inicio, la fecha de cosecha y la cantidad
de dias que transcurrieron entre ambas fechas.
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
Consulta 10: Torres con nivel de agua es inferior al 50%.
Permite identificar las torres que necesitan
una reposicion de agua.
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
