USE happy_hidro;
GO

/*
Subconsulta 1:
Que se quiere obtener: Los cultivos actuales del invernadero (en progreso o en mantenimiento) que superan el promedio de plantas, para identificar los cultivos principales.
Funcion de la subconsulta: Calcula el promedio de plantas de los cultivos actuales y devuelve un unico valor, que se usa como condicion en la consulta principal.
Por que es adecuada: La cantidad de plantas cambia constantemente, calcular el promedio en el momento garantiza que el resultado este siempre actualizado.
*/
select c.id_cultivo, e.nombre as especie, c.cantidad_plantas
from cultivos c
join especie e on c.id_especie = e.id_especie
where c.estado in ('EN PROGRESO', 'MANTENIMIENTO') and c.cantidad_plantas > (select avg(cantidad_plantas) from cultivos where estado in ('EN PROGRESO', 'MANTENIMIENTO'))
order by c.cantidad_plantas desc;
GO

/*
Subconsulta 2:
Que se quiere obtener: Los empleados que tienen tareas pendientes en el invernadero.
Funcion de la subconsulta: Devuelve la lista de ids de los empleados que tienen tareas con estado pendiente.
Por que es adecuada: Primero se necesita saber quien tiene asignadas tareas pendientes, para luego buscar los datos de esos empleados.
*/
select id_empleado, nombre, apellido
from empleado
where id_empleado in (select id_empleado from tareas where estado = 'PENDIENTE');
GO

/*
Subconsulta 3:
Que se quiere obtener: Las torres que estan completamente vacias, para planificar como llenarlas.
Funcion de la subconsulta: Devuelve la lista de ids de las torres que tienen cultivos en progreso o en mantenimiento, es decir, las torres que no estan vacias.
Por que es adecuada: Las torres se vacian a medida que los cultivos se cosechan o se descartan, por lo que primero se necesita conocer la informacion actualizada de las torres ocupadas para luego obtener las que no estan en esa lista.
*/
select id_torre, ubicacion_lote as lote, ubicacion_rack as rack, capacidad_planta as capacidad
from sistema_torre
where id_torre not in (select id_torre from cultivos where estado in ('EN PROGRESO', 'MANTENIMIENTO'));
GO

/*
Subconsulta 4:
Que se quiere obtener: Cuantos espacios libres y ocupados tiene cada torre, para organizar donde poner plantas nuevas.
Funcion de la subconsulta: Por cada torre, suma la cantidad de plantas de sus cultivos activos (en progreso o en mantenimiento).
Si la torre no tiene activos la suma da null, por eso se usa isnull asi muestra 0.
Los espacios libres se obtienen restando ese resultado a la capacidad de la torre.
Por que es adecuada: Cada torre tiene una cantidad distinta de plantas, por lo que no sirve un unico valor para todas, la subconsulta es correlacionada y se calcula una vez por cada torre usando su id.
*/
select t.id_torre, t.capacidad_planta as capacidad,
isnull((select sum(c.cantidad_plantas) from cultivos c where c.estado in ('EN PROGRESO', 'MANTENIMIENTO') and t.id_torre = c.id_torre), 0) as espacios_ocupados,
t.capacidad_planta - isnull((select sum(c.cantidad_plantas) from cultivos c where c.estado in ('EN PROGRESO', 'MANTENIMIENTO') and t.id_torre = c.id_torre), 0) as espacios_libres
from sistema_torre t
order by espacios_libres desc, t.id_torre;
