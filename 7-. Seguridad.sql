/*
Roles de seguridad para happy_hidro.
Se definen permisos por tabla en vez de usar un único usuario con acceso total,
para que la aplicación/empleados se conecten con el rol minimo necesario.
*/
USE happy_hidro;
GO

CREATE ROLE rol_lectura;
CREATE ROLE rol_operador;
CREATE ROLE rol_encargado;
CREATE ROLE rol_admin;
CREATE ROLE rol_sensor;
GO

/*
rol_lectura
Acceso de solo consulta a todas las tablas. Pensado para reportes/dashboards.
*/
GRANT SELECT ON SCHEMA::dbo TO rol_lectura;
GO

/*
rol_operador
Empleado de campo: puede ver todo, cargar mediciones de los sensores
y actualizar el avance de sus propias tareas y el estado de los cultivos
que atiende. No puede borrar nada ni tocar catalogos (especie, etapa, tipo_tareas)
ni la configuracion de torres/sensores/empleados.
*/
GRANT SELECT ON SCHEMA::dbo TO rol_operador;
GRANT UPDATE ON dbo.tareas TO rol_operador;
GRANT UPDATE ON dbo.cultivos TO rol_operador;
GO
  
/*
rol_sensor
Cuenta tecnica para los dispositivos o integraciones que envian mediciones
de pH, EC y temperatura. Solo puede registrar nuevas filas en medicion.
No puede leer datos, modificar ni borrar mediciones existentes, ni tocar
la configuracion de torres, sensores o cultivos.
*/
GRANT INSERT ON dbo.medicion TO rol_sensor; 
GO
  
/*
rol_encargado
Supervisor: hereda los permisos de rol_operador (se agrega como miembro)
y suma la gestion operativa completa: altas/bajas de torres, sensores,
cultivos, tareas, empleados y catalogos.
*/
ALTER ROLE rol_operador ADD MEMBER rol_encargado;
GO

GRANT INSERT, UPDATE, DELETE ON dbo.sistema_torre TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.sensor TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.cultivos TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.tareas TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.empleado TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.especie TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.etapa TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.especie_etapa TO rol_encargado;
GRANT INSERT, UPDATE, DELETE ON dbo.tipo_tareas TO rol_encargado;
GO

/*
rol_admin
Control total sobre la base (DBA). Se implementa agregandolo como miembro
del rol fijo db_owner.
*/
ALTER ROLE db_owner ADD MEMBER rol_admin;
GO

/*
Ejemplo de uso: crear un login/usuario y asignarlo a un rol.
(Reemplazar 'NombreLogin' y la contraseña por los datos reales.)
*/
-- CREATE LOGIN juan_operador WITH PASSWORD = 'ContraseñaSegura123!';
-- CREATE USER juan_operador FOR LOGIN juan_operador;
-- ALTER ROLE rol_operador ADD MEMBER juan_operador;
