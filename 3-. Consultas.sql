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
