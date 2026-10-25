USE happy_hidro;
GO

--Usamos la función SET IDENTITY_INSERT 'nombre de table' ON/OFF; Para ajustar de manera manual,
--la inserción de todos los ids, por lo menos los primeros agregados y así evitarnos errores,
--y así mejorar el manejo de los datos agregados de manera masiva como lo haremos en esta ocasión:
 
-- 1. SISTEMA_TORRE (30 registros)
 
SET IDENTITY_INSERT sistema_torre ON;
INSERT INTO sistema_torre (id_torre, max_agua, capacidad_planta, ubicacion_lote, ubicacion_rack, agua_actual) VALUES
(1, 50.00, 20, 'A', '1', 40), (2, 50.00, 20, 'A', '2', 45), (3, 60.00, 24, 'A', '3', 50), (4, 60.00, 24, 'A', '4', 30),
(5, 50.00, 20, 'B', '1', 48), (6, 50.00, 20, 'B', '2', 25), (7, 60.00, 24, 'B', '3', 55), (8, 60.00, 24, 'B', '4', 60),
(9, 40.00, 16, 'C', '1', 35), (10, 40.00, 16, 'C', '2', 20), (11, 50.00, 20, 'C', '3', 40), (12, 50.00, 20, 'C', '4', 15),
(13, 70.00, 30, 'D', '1', 65), (14, 70.00, 30, 'D', '2', 70), (15, 70.00, 30, 'D', '3', 50), (16, 70.00, 30, 'D', '4', 45),
(17, 50.00, 20, 'E', '1', 50), (18, 50.00, 20, 'E', '2', 30), (19, 60.00, 24, 'E', '3', 40), (20, 60.00, 24, 'E', '4', 25),
(21, 40.00, 16, 'F', '1', 35), (22, 40.00, 16, 'F', '2', 38), (23, 50.00, 20, 'F', '3', 20), (24, 50.00, 20, 'F', '4', 45),
(25, 80.00, 36, 'G', '1', 75), (26, 80.00, 36, 'G', '2', 60), (27, 80.00, 36, 'G', '3', 80), (28, 80.00, 36, 'G', '4', 50),
(29, 50.00, 20, 'H', '1', 40), (30, 50.00, 20, 'H', '2', 30);
SET IDENTITY_INSERT sistema_torre OFF;
GO

 
-- 2. ESPECIE (30 registros)

SET IDENTITY_INSERT especie ON;
INSERT INTO especie (id_especie, nombre) VALUES
(1, 'Lechuga Capuchina'), (2, 'Lechuga Criolla'), (3, 'Albahaca Genovesa'),
(4, 'Acelga Verde'), (5, 'Espinaca Baby'), (6, 'Rucula Salvaje'),
(7, 'Perejil Liso'), (8, 'Cilantro'), (9, 'Menta Piperita'),
(10, 'Tomate Cherry'), (11, 'Morron Rojo'), (12, 'Frutilla San Andreas'),
(13, 'Berenjena'), (14, 'Ciboulette'), (15, 'Orégano'),
(16, 'Tomillo'), (17, 'Romero'), (18, 'Verdeo'),
(19, 'Brocoli Mini'), (20, 'Coliflor Mini'), (21, 'Lechuga Roja'),
(22, 'Radicheta'), (23, 'Kale'), (24, 'Hinojo'),
(25, 'Apio'), (26, 'Pak Choi'), (27, 'Tatsoi'),
(28, 'Salvia'), (29, 'Melisa'), (30, 'Estevia');
SET IDENTITY_INSERT especie OFF;
GO

-- 3. ETAPA (5 registros)

SET IDENTITY_INSERT etapa ON;
INSERT INTO etapa (id_etapa, nombre, orden) VALUES
(1, 'Germinacion', 1),
(2, 'Plantula', 2),
(3, 'Crecimiento Vegetativo', 3),
(4, 'Floracion', 4),
(5, 'Cosecha', 5);
SET IDENTITY_INSERT etapa OFF;
GO

-- 4. ESPECIE_ETAPA (30 registros)

INSERT INTO especie_etapa (id_especie, id_etapa, dias_duracion, ph_min, ph_max, ec_min, ec_max, temp_min, temp_max) VALUES
(1, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (2, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(3, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (4, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(5, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (6, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(7, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (8, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(9, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (10, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(11, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (12, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(13, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (14, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(15, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (16, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(17, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (18, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(19, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (20, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(21, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (22, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(23, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (24, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(25, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (26, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(27, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (28, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0),
(29, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0), (30, 3, 30, 5.5, 7.5, 0.80, 3.00, 15.0, 28.0);
GO

-- 5. SENSOR (30 registros)

SET IDENTITY_INSERT sensor ON;
INSERT INTO sensor (id_sensor, id_torre, modelo, activo) VALUES
(1, 1, NULL, 1), (2, 2, NULL, 1), (3, 3, NULL, 1), (4, 4, NULL, 1), (5, 5, NULL, 1),
(6, 6, NULL, 1), (7, 7, NULL, 1), (8, 8, NULL, 1), (9, 9, NULL, 1), (10, 10, NULL, 1),
(11, 11, NULL, 1), (12, 12, NULL, 1), (13, 13, NULL, 1), (14, 14, NULL, 1), (15, 15, NULL, 1),
(16, 16, NULL, 1), (17, 17, NULL, 1), (18, 18, NULL, 1), (19, 19, NULL, 1), (20, 20, NULL, 1),
(21, 21, NULL, 1), (22, 22, NULL, 1), (23, 23, NULL, 1), (24, 24, NULL, 1), (25, 25, NULL, 1),
(26, 26, NULL, 1), (27, 27, NULL, 1), (28, 28, NULL, 1), (29, 29, NULL, 1), (30, 30, NULL, 1);
SET IDENTITY_INSERT sensor OFF;
GO

-- 6. MEDICION (30 registros)

INSERT INTO medicion (id_sensor, fecha_hora, ph, ec, temp_agua) VALUES
(1, '2026-01-05 08:00:00', 6.1, 1.2, 20.2), (1, '2026-01-10 08:00:00', 6.0, 1.3, 20.4),
(2, '2026-01-12 09:30:00', 6.2, 1.3, 19.8), (2, '2026-01-18 10:00:00', 6.3, 1.4, 20.1),
(3, '2026-01-15 08:15:00', 6.5, 1.6, 21.9), (3, '2026-01-20 08:15:00', 6.4, 1.5, 22.0),
(4, '2026-01-22 09:00:00', 6.7, 1.7, 19.2), (4, '2026-01-25 09:00:00', 6.8, 1.8, 19.5),
(5, '2026-01-28 07:45:00', 6.3, 1.5, 18.1), (6, '2026-02-01 11:00:00', 6.0, 1.1, 21.2),
(7, '2026-02-05 08:30:00', 6.5, 1.4, 20.0), (8, '2026-02-10 08:30:00', 6.6, 1.5, 22.1),
(9, '2026-02-14 09:00:00', 6.0, 1.5, 21.0), (10, '2026-02-16 10:00:00', 6.2, 2.1, 22.8),
(11, '2026-02-18 08:00:00', 6.4, 2.0, 22.0), (12, '2026-02-20 08:00:00', 5.8, 1.5, 19.0),
(13, '2026-02-22 09:00:00', 6.2, 2.2, 23.9), (14, '2026-02-24 10:30:00', 6.5, 1.3, 18.5),
(15, '2026-02-28 08:00:00', 7.0, 1.4, 20.4), (16, '2026-03-02 08:00:00', 6.5, 1.3, 21.0),
(17, '2026-03-05 09:00:00', 6.8, 1.2, 21.8), (18, '2026-03-07 08:00:00', 6.5, 1.6, 19.0),
(19, '2026-03-10 08:00:00', 6.5, 2.0, 17.5), (20, '2026-03-12 08:00:00', 6.7, 2.1, 18.0),
(21, '2026-03-14 09:00:00', 6.0, 1.2, 20.1), (22, '2026-03-16 08:00:00', 6.2, 1.4, 19.0),
(23, '2026-03-20 08:00:00', 6.5, 1.8, 17.0), (24, '2026-03-22 08:00:00', 6.4, 1.7, 20.0),
(25, '2026-03-25 09:00:00', 6.5, 1.9, 19.0), (26, '2026-03-28 08:00:00', 6.3, 1.6, 21.0);
GO

 
-- 7. CULTIVOS (30 registros)
 
SET IDENTITY_INSERT cultivos ON;
INSERT INTO cultivos (id_cultivo, id_especie, id_torre, fecha_inicio, fecha_cosecha, estado, cantidad_plantas) VALUES
(1, 1, 1, '2026-01-01', '2026-02-15', 'COSECHADO', 18), (2, 2, 2, '2026-01-05', '2026-02-20', 'COSECHADO', 20),
(3, 3, 3, '2026-01-10', NULL, 'EN PROGRESO', 22), (4, 4, 4, '2026-01-15', NULL, 'EN PROGRESO', 20),
(5, 5, 5, '2026-01-20', '2026-03-01', 'COSECHADO', 15), (6, 6, 6, '2026-01-25', NULL, 'MUERTO', 10),
(7, 7, 7, '2026-02-01', NULL, 'EN PROGRESO', 24), (8, 8, 8, '2026-02-05', NULL, 'EN PROGRESO', 24),
(9, 9, 9, '2026-02-10', NULL, 'EN PROGRESO', 15), (10, 10, 10, '2026-02-12', NULL, 'EN PROGRESO', 12),
(11, 11, 11, '2026-02-15', NULL, 'EN PROGRESO', 18), (12, 12, 12, '2026-02-18', NULL, 'EN PROGRESO', 16),
(13, 13, 13, '2026-02-20', NULL, 'EN PROGRESO', 25), (14, 14, 14, '2026-02-22', NULL, 'EN PROGRESO', 28),
(15, 15, 15, '2026-02-25', NULL, 'EN PROGRESO', 20), (16, 16, 16, '2026-03-01', NULL, 'EN PROGRESO', 18),
(17, 17, 17, '2026-03-03', NULL, 'EN PROGRESO', 20), (18, 18, 18, '2026-03-05', NULL, 'EN PROGRESO', 19),
(19, 19, 19, '2026-03-08', NULL, 'EN PROGRESO', 22), (20, 20, 20, '2026-03-10', NULL, 'EN PROGRESO', 21),
(21, 21, 21, '2026-03-12', NULL, 'EN PROGRESO', 15), (22, 22, 22, '2026-03-15', NULL, 'EN PROGRESO', 14),
(23, 23, 23, '2026-03-18', NULL, 'EN PROGRESO', 20), (24, 24, 24, '2026-03-20', NULL, 'EN PROGRESO', 18),
(25, 25, 25, '2026-03-22', NULL, 'EN PROGRESO', 30), (26, 26, 26, '2026-03-25', NULL, 'EN PROGRESO', 28),
(27, 27, 27, '2026-03-28', NULL, 'EN PROGRESO', 25), (28, 28, 28, '2026-04-01', NULL, 'MANTENIMIENTO', 15),
(29, 29, 29, '2026-04-03', NULL, 'EN PROGRESO', 18), (30, 30, 30, '2026-04-05', NULL, 'EN PROGRESO', 20);
SET IDENTITY_INSERT cultivos OFF;
GO

-- 8. EMPLEADO (30 registros)
 
SET IDENTITY_INSERT empleado ON;
INSERT INTO empleado (id_empleado, nombre, apellido) VALUES
(1, 'Carlos', 'Gomez'), (2, 'Maria', 'Perez'), (3, 'Juan', 'Rodríguez'), (4, 'Ana', 'López'),
(5, 'Lucas', 'Martínez'), (6, 'Sofía', 'Fernández'), (7, 'Mateo', 'García'), (8, 'Valentina', 'González'),
(9, 'Diego', 'Hernández'), (10, 'Camila', 'Martín'), (11, 'Joaquín', 'Ruiz'), (12, 'Lucía', 'Díaz'),
(13, 'Gabriel', 'Álvarez'), (14, 'Martina', 'Moreno'), (15, 'Federico', 'Muñoz'), (16, 'Florencia', 'Rojas'),
(17, 'Agustín', 'Navarro'), (18, 'Victoria', 'Torres'), (19, 'Ignacio', 'Domínguez'), (20, 'Catalina', 'Vázquez'),
(21, 'Nicolás', 'Ramos'), (22, 'Julieta', 'Gil'), (23, 'Tomás', 'Serrano'), (24, 'Renata', 'Blanco'),
(25, 'Emiliano', 'Molina'), (26, 'Antonella', 'Morales'), (27, 'Bautista', 'Suárez'), (28, 'Mía', 'Ortega'),
(29, 'Benjamín', 'Castro'), (30, 'Abigail', 'Rubio');
SET IDENTITY_INSERT empleado OFF;
GO


-- 9. TIPO_TAREAS (30 registros)

SET IDENTITY_INSERT tipo_tareas ON;
INSERT INTO tipo_tareas (id_tipo_tarea, nombre, descripcion) VALUES
(1, 'Medicion de pH', 'Control diario de acidez del agua en torre'),
(2, 'Medicion de EC', 'Revision de electroconductividad y nutrientes'),
(3, 'Limpieza de Tanque', 'Desinfeccion y vaciado parcial de deposito'),
(4, 'Calibracion de Sensores', 'Calibracion de sondas de temperatura y pH'),
(5, 'Siembra', 'Colocacion de germinados en alveolos'),
(6, 'Cosecha', 'Recoleccion de plantas adultas listas'),
(7, 'Poda de Raices', 'Mantenimiento preventivo del sistema radicular'),
(8, 'Recambio de Solucion Nutritiva', 'Sustitucion completa del agua con nutrientes'),
(9, 'Control de Plagas', 'Inspeccion visual y aplicacion organica preventiva'),
(10, 'Revision de Bombas', 'Verificacion de caudal y presion de agua'),
(11, 'Limpieza de Boquillas', 'Destapado de chupones de riego por goteo'),
(12, 'Mantenimiento de Iluminacion', 'Reemplazo de paneles LED quemados'),
(13, 'Control de Temperatura', 'Verificacion de climatizacion del invernadero'),
(14, 'Monitoreo de Oxigeno', 'Medicion de oxigeno disuelto en agua'),
(15, 'Desinfeccion de Racks', 'Limpieza profunda de estructuras metalicas'),
(16, 'Ajuste de Niveles de Agua', 'Rellenado por evaporacion'),
(17, 'Rotacion de Cultivos', 'Cambio de ubicacion de bandejas'),
(18, 'Descarte de Plantas Muertas', 'Retiro de ejemplares no viables'),
(19, 'Revision Electrica', 'Control de tableros y disyuntores'),
(20, 'Calibracion de EC', 'Ajuste especifico del medidor de conductividad'),
(21, 'Aplicacion de Calcio', 'Suplemento foliar preventivo'),
(22, 'Monitoreo de Humedad', 'Control higrometrico del ambiente'),
(23, 'Saneamiento General', 'Limpieza de pisos y desagües del sector'),
(24, 'Cambio de Filtros', 'Reemplazo de cartuchos de filtrado de agua'),
(25, 'Test de Germinacion', 'Control de tasa de salida en semillero'),
(26, 'Podado de Hojas Secas', 'Mantenimiento estetico y sanitario'),
(27, 'Verificacion de Valvulas', 'Prueba de apertura y cierre de paso'),
(28, 'Control de CO2', 'Medicion de gases en ambiente cerrado'),
(29, 'Auditoria de Stock', 'Conteo de insumos y nutrientes en deposito'),
(30, 'Capacitacion de Personal', 'Induccion operativa sobre nuevas normas');
SET IDENTITY_INSERT tipo_tareas OFF;
GO

-- 10. TAREAS (30 registros)
-- Validaciones aplicadas: Fechas coherentes con los estados.

SET IDENTITY_INSERT tareas ON;
INSERT INTO tareas (id_tarea, id_tipo_tarea, id_torre, id_cultivo, id_empleado, fecha_programada, fecha_ejecutada, estado_tarea, observaciones) VALUES
(1, 1, 1, 1, 1, '2026-01-02', '2026-01-02', 'FINALIZADA', 'Medicion inicial dentro de parametros optimos'),
(2, 2, 2, 2, 2, '2026-01-06', '2026-01-06', 'FINALIZADA', 'EC estable en torre 2'),
(3, 3, 3, 3, 3, '2026-01-12', '2026-01-13', 'FINALIZADA', 'Limpieza profunda realizada con exito'),
(4, 4, 4, 4, 4, '2026-01-16', NULL, 'PROGRAMADA', 'Pendiente de calibracion general'),
(5, 5, 5, 5, 5, '2026-01-21', '2026-01-21', 'FINALIZADA', 'Siembra completada sin novedades'),
(6, 6, 1, 1, 6, '2026-02-15', '2026-02-15', 'FINALIZADA', 'Cosecha exitosa de lechugas capuchinas'),
(7, 7, 6, 6, 7, '2026-01-26', NULL, 'PENDIENTE', 'Requiere revision urgente'),
(8, 8, 7, 7, 8, '2026-02-02', '2026-02-02', 'FINALIZADA', 'Recambio de agua con solucion B'),
(9, 9, 8, 8, 9, '2026-02-06', NULL, 'EN PROGRESO', 'Aplicando control biologico preventivo'),
(10, 10, 9, 9, 10, '2026-02-11', '2026-02-11', 'FINALIZADA', 'Bomba principal funcionando correctamente'),
(11, 11, 10, 10, 11, '2026-02-13', NULL, 'CANCELADA', 'Se pospuso por falta de insumos'),
(12, 12, 11, 11, 12, '2026-02-16', '2026-02-16', 'FINALIZADA', 'Paneles LED reemplazados'),
(13, 13, 12, 12, 13, '2026-02-19', NULL, 'PROGRAMADA', 'Ajuste programado de temperatura'),
(14, 14, 13, 13, 14, '2026-02-21', '2026-02-21', 'FINALIZADA', 'Oxigenacion optima registrada'),
(15, 15, 14, 14, 15, '2026-02-23', NULL, 'PENDIENTE', 'Limpieza de sector D'),
(16, 16, 15, 15, 16, '2026-02-26', '2026-02-26', 'FINALIZADA', 'Niveles de agua restablecidos'),
(17, 17, 16, 16, 17, '2026-03-02', NULL, 'EN PROGRESO', 'Rotando bandejas de cultivo'),
(18, 18, 6, 6, 18, '2026-01-30', '2026-01-30', 'FINALIZADA', 'Retiro de plantas muertas en torre 6'),
(19, 19, 17, 17, 19, '2026-03-04', '2026-03-04', 'FINALIZADA', 'Tablero electrico verificado'),
(20, 20, 18, 18, 20, '2026-03-06', NULL, 'PROGRAMADA', 'Calibracion pendiente de sonda EC'),
(21, 21, 19, 19, 21, '2026-03-09', '2026-03-09', 'FINALIZADA', 'Suplemento de calcio aplicado'),
(22, 22, 20, 20, 22, '2026-03-11', NULL, 'PENDIENTE', 'Control de humedad ambiental'),
(23, 23, 21, 21, 23, '2026-03-13', '2026-03-13', 'FINALIZADA', 'Saneamiento completado en sector F'),
(24, 24, 22, 22, 24, '2026-03-16', '2026-03-16', 'FINALIZADA', 'Filtros de agua reemplazados'),
(25, 25, 23, 23, 25, '2026-03-19', NULL, 'PROGRAMADA', 'Test de germinacion programado'),
(26, 26, 24, 24, 26, '2026-03-21', '2026-03-21', 'FINALIZADA', 'Podado estético realizado'),
(27, 27, 25, 25, 27, '2026-03-23', NULL, 'EN PROGRESO', 'Prueba de valvulas hidraulicas'),
(28, 28, 26, 26, 28, '2026-03-26', '2026-03-26', 'FINALIZADA', 'Medicion de CO2 dentro del rango'),
(29, 29, 27, 27, 29, '2026-03-29', '2026-03-29', 'FINALIZADA', 'Auditoria trimestral completada'),
(30, 30, 28, 28, 30, '2026-04-02', '2026-04-02', 'FINALIZADA', 'Capacitacion de personal operativo efectuada');
SET IDENTITY_INSERT tareas OFF;
GO
