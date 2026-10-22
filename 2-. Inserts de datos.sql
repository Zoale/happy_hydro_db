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
INSERT INTO especie (id_especie, nombre, ph_optimo, ec_optimo, temp_agua_optimo) VALUES
(1, 'Lechuga Capuchina', 6.0, 1.2, 20.5), (2, 'Lechuga Criolla', 6.2, 1.3, 20.0), (3, 'Albahaca Genovesa', 6.5, 1.6, 22.0),
(4, 'Acelga Verde', 6.8, 1.8, 19.5), (5, 'Espinaca Baby', 6.3, 1.5, 18.0), (6, 'Rucula Salvaje', 6.0, 1.4, 21.0),
(7, 'Perejil Liso', 6.5, 1.4, 20.0), (8, 'Cilantro', 6.6, 1.5, 22.5), (9, 'Menta Piperita', 6.0, 1.5, 21.0),
(10, 'Tomate Cherry', 6.2, 2.2, 23.0), (11, 'Morron Rojo', 6.4, 2.0, 22.0), (12, 'Frutilla San Andreas', 5.8, 1.5, 19.0),
(13, 'Berenjena', 6.2, 2.3, 24.0), (14, 'Ciboulette', 6.5, 1.3, 18.5), (15, 'Orégano', 7.0, 1.4, 20.5),
(16, 'Tomillo', 6.5, 1.3, 21.0), (17, 'Romero', 6.8, 1.2, 22.0), (18, 'Verdeo', 6.5, 1.6, 19.0),
(19, 'Brocoli Mini', 6.5, 2.0, 17.5), (20, 'Coliflor Mini', 6.7, 2.1, 18.0), (21, 'Lechuga Roja', 6.0, 1.2, 20.0),
(22, 'Radicheta', 6.2, 1.4, 19.0), (23, 'Kale', 6.5, 1.8, 17.0), (24, 'Hinojo', 6.4, 1.7, 20.0),
(25, 'Apio', 6.5, 1.9, 19.0), (26, 'Pak Choi', 6.3, 1.6, 21.0), (27, 'Tatsoi', 6.2, 1.5, 20.5),
(28, 'Salvia', 6.5, 1.3, 21.5), (29, 'Melisa', 6.3, 1.4, 20.0), (30, 'Estevia', 6.8, 1.3, 23.0);
SET IDENTITY_INSERT especie OFF;
GO

 
-- 3. CULTIVOS (30 registros)
 
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

 
-- 4. PARAMETROS (30 registros)
 
SET IDENTITY_INSERT parametros ON;
INSERT INTO parametros (id_parametro, parametro_descripcion, maximo, minimo) VALUES
(1, 'pH del Agua', 7.5, 5.5), (2, 'Electroconductividad (EC)', 3.0, 0.8), (3, 'Temperatura del Agua', 28.0, 15.0),
(4, 'Oxigeno Disuelto', 10.0, 4.0), (5, 'Humedad Relativa Invernadero', 90.0, 40.0), (6, 'Temperatura Ambiente', 35.0, 12.0),
(7, 'Nivel de Nitrogeno (N)', 200.0, 50.0), (8, 'Nivel de Fosforo (P)', 100.0, 20.0), (9, 'Nivel de Potasio (K)', 250.0, 80.0),
(10, 'Calcio (Ca)', 180.0, 40.0), (11, 'Magnesio (Mg)', 90.0, 20.0), (12, 'Hierro (Fe)', 5.0, 0.5),
(13, 'Turbidez del Agua', 15.0, 0.0), (14, 'Luminosidad (PAR)', 1000.0, 200.0), (15, 'CO2 Ambiental', 1200.0, 400.0),
(16, 'Salinidad Total (TDS)', 2000.0, 500.0), (17, 'Flujo de Bombeo', 50.0, 5.0), (18, 'Presion de Linea', 4.0, 1.0),
(19, 'Zinc (Zn)', 2.0, 0.1), (20, 'Manganeso (Mn)', 3.0, 0.2), (21, 'Boro (B)', 1.5, 0.1),
(22, 'Cobre (Cu)', 0.5, 0.02), (23, 'Molibdeno (Mo)', 0.2, 0.01), (24, 'Azufre (S)', 150.0, 20.0),
(25, 'Dureza del Agua', 250.0, 50.0), (26, 'Cloro Libre', 1.0, 0.0), (27, 'Horas de Luz Diaria', 18.0, 8.0),
(28, 'Velocidad de Viento Interno', 5.0, 0.0), (29, 'Democloracion', 0.5, 0.0), (30, 'Bio-indicador de Plagas', 1.0, 0.0);
SET IDENTITY_INSERT parametros OFF;
GO

 
-- 5. PARAMETROS_POR_CULTIVO (30 registros)
 
INSERT INTO parametros_por_cultivo (id_cultivo, id_parametro, ph_actual, ec_actual, temp_agua_actual, fecha_medicion) VALUES
(1, 1, 6.1, 1.2, 20.2, '2026-01-05 08:00:00'), (1, 2, 6.0, 1.3, 20.4, '2026-01-10 08:00:00'),
(2, 1, 6.2, 1.3, 19.8, '2026-01-12 09:30:00'), (2, 3, 6.3, 1.4, 20.1, '2026-01-18 10:00:00'),
(3, 1, 6.5, 1.6, 21.9, '2026-01-15 08:15:00'), (3, 2, 6.4, 1.5, 22.0, '2026-01-20 08:15:00'),
(4, 1, 6.7, 1.7, 19.2, '2026-01-22 09:00:00'), (4, 3, 6.8, 1.8, 19.5, '2026-01-25 09:00:00'),
(5, 1, 6.3, 1.5, 18.1, '2026-01-28 07:45:00'), (6, 2, 6.0, 1.1, 21.2, '2026-02-01 11:00:00'),
(7, 1, 6.5, 1.4, 20.0, '2026-02-05 08:30:00'), (8, 2, 6.6, 1.5, 22.1, '2026-02-10 08:30:00'),
(9, 3, 6.0, 1.5, 21.0, '2026-02-14 09:00:00'), (10, 1, 6.2, 2.1, 22.8, '2026-02-16 10:00:00'),
(11, 2, 6.4, 2.0, 22.0, '2026-02-18 08:00:00'), (12, 1, 5.8, 1.5, 19.0, '2026-02-20 08:00:00'),
(13, 3, 6.2, 2.2, 23.9, '2026-02-22 09:00:00'), (14, 1, 6.5, 1.3, 18.5, '2026-02-24 10:30:00'),
(15, 2, 7.0, 1.4, 20.4, '2026-02-28 08:00:00'), (16, 1, 6.5, 1.3, 21.0, '2026-03-02 08:00:00'),
(17, 3, 6.8, 1.2, 21.8, '2026-03-05 09:00:00'), (18, 1, 6.5, 1.6, 19.0, '2026-03-07 08:00:00'),
(19, 2, 6.5, 2.0, 17.5, '2026-03-10 08:00:00'), (20, 1, 6.7, 2.1, 18.0, '2026-03-12 08:00:00'),
(21, 3, 6.0, 1.2, 20.1, '2026-03-14 09:00:00'), (22, 1, 6.2, 1.4, 19.0, '2026-03-16 08:00:00'),
(23, 2, 6.5, 1.8, 17.0, '2026-03-20 08:00:00'), (24, 1, 6.4, 1.7, 20.0, '2026-03-22 08:00:00'),
(25, 3, 6.5, 1.9, 19.0, '2026-03-25 09:00:00'), (26, 1, 6.3, 1.6, 21.0, '2026-03-28 08:00:00');
GO

 
-- 6. EMPLEADO (30 registros)
 
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


-- 7. TIPO_TAREAS (30 registros)

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

-- 8. TAREAS (30 registros)
-- Validaciones aplicadas: Fechas coherentes con los estados.

SET IDENTITY_INSERT tareas ON;
INSERT INTO tareas (id_tarea, id_tipo_tarea, id_torre, id_cultivo, id_empleado, fecha_programada, fecha_ejecutada, estado, observaciones) VALUES
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