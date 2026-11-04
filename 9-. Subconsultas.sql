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
where id_empleado in (select id_empleado from tareas where estado_tarea = 'PENDIENTE');
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
 * Consulta: q_torres_libres
 *
 * Torres sin ningún cultivo EN PROGRESO, disponibles para sembrar.
 */
SELECT t.id_torre,
       t.ubicacion_lote,
       t.ubicacion_rack,
       t.capacidad_planta
FROM sistema_torre t
WHERE NOT EXISTS (
    SELECT 1
    FROM cultivos c
    WHERE c.id_torre = t.id_torre AND c.estado = 'EN PROGRESO'
)
ORDER BY t.ubicacion_lote, t.ubicacion_rack;
