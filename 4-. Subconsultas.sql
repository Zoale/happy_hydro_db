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
