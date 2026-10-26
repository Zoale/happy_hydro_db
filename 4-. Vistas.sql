/*
Vista 3:
Muestra los las tareas asignadas a los empleados
 
*/

CREATE OR ALTER VIEW v_tareas_pendientes AS
SELECT t2.descripcion, st.id_torre,e.nombre
from tareas as t
JOIN tipo_tareas as t2
	ON t.id_tarea = t2.id_tipo_tarea
JOIN empleado as e 
	ON t.id_empleado = e.id_empleado
join sistema_torre as st
	on st.id_torre = t.id_torre
WHERE t.estado_tarea = 'ASIGNADA'
GO

/*
Vista 4:
 muestra las torres que tienen bajo nivel de agua y las de estado normal.
*/

CREATE VIEW vw_torres_bajo_agua AS
SELECT
    id_torre,
    ubicacion_lote,
    ubicacion_rack,
    CASE
        WHEN agua_actual * 100.0 / max_agua < 30 THEN 'CRITICO'
        WHEN agua_actual * 100.0 / max_agua < 50 THEN 'BAJO'
        ELSE 'NORMAL'
    END AS estado
FROM sistema_torre;
GO

Vista 1:
Muestra los cultivos que se encuentran en estado "EN PROGRESO"
devuelve, id_torrre, estado , agua , especie que contiene , lote y rack
*/

CREATE OR ALTER VIEW v_mantenimientos_pendientes AS
SELECT c.id_torre, c.estado , s.agua_actual , e.nombre AS especie ,  s.ubicacion_lote , s.ubicacion_rack
FROM cultivos as c
JOIN sistema_torre as s ON s.id_torre= c.id_torre
JOIN especie as e ON e.id_especie = c.id_especie
WHERE c.estado = 'EN PROGRESO';
GO

/*
Vista 2:
Muestra en una vista que señale las tareas en estado “ASIGNADA”, ordenadas por fecha más próxima, e incluya para cada tarea: id_torre,ubicacion_lote,ubicacion_rack y el nombre del empleado que fue asignado.
*/

CREATE VIEW vw_tareas_asignadas AS
SELECT
    t.id_tarea,
    t.id_torre,
    st.ubicacion_lote,
    st.ubicacion_rack,
    e.nombre + ' ' + e.apellido AS nombre_empleado,
    t.fecha_programada,
    t.observaciones
FROM tareas t
INNER JOIN sistema_torre st ON st.id_torre = t.id_torre
INNER JOIN empleado e ON e.id_empleado = t.id_empleado
WHERE t.estado_tarea = 'ASIGNADA';
GO
