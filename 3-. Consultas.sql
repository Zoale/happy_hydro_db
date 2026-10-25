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
