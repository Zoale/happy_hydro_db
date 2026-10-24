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
