USE happy_hidro;
GO

/*
Funcion 1: fn_PlantasActivas
Objetivo: Saber cuantas plantas hay actualmente en una torre.
Parametros: @id_torre (INT), la torre donde buscar.
Tipo de retorno: INT, la cantidad de plantas activas.
Logica: Suma las plantas 'EN PROGRESO' de la torre.
Se usa isnull para devolver 0 si la torre no tiene cultivos activos.
Ejemplo de uso: select dbo.fn_PlantasActivas(1);
*/
create function fn_PlantasActivas (@id_torre int)
returns int
as
begin
    declare @plantas int;
    select @plantas = isnull(sum(cantidad_plantas), 0)
    from cultivos
    where id_torre = @id_torre and estado = 'EN PROGRESO';
    return @plantas;
end;
GO
