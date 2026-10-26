/*
Vista 1:
Muestra los cultivos que se encuentran en estado "EN PROGRESO"
devuelve, id_cultivo, id_torrre, fecha_inicio, cantidad_plantas
*/


CREATE OR ALTER VIEW v_cultivos_en_progreso AS
SELECT id_cultivo, id_torre, fecha_inicio, cantidad_plantas
FROM cultivos
WHERE estado = 'EN PROGRESO';
GO

SELECT * FROM v_cultivos_en_progreso;

/*
Vista 2:
Muestra los cultivos que se encuentran en estado "MANTENIMIENTO"
devuelve, id_torrre, estado , agua , especie que contiene , lote y rack
*/

CREATE OR ALTER VIEW v_mantenimientos_pendientes AS
SELECT c.id_torre, c.estado , s.agua_actual , e.nombre AS especie ,  s.ubicacion_lote , s.ubicacion_rack
FROM cultivos as c
JOIN sistema_torre as s ON s.id_torre= c.id_torre
JOIN especie as e ON e.id_especie = c.id_especie
WHERE c.estado = 'MANTENIMIENTO';
GO