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

