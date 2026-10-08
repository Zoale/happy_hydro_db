create database Universidad
use Universidad
go


create table Carreras (
idcarrera int identity primary key,
nombrecarrera varchar(25) NOT NULL,
duracion int NOT NULL,
modadlidad varchar(25)
constraint chk_duracion_carrera check (duracion LIKE ('2''3''4')),
)

create table Alumnos(
idalumno int identity primary key,
nombre varchar(25) NOT NULL,
apellido varchar(25) NOT NULL,
dni int NOT NULL,
fechanacimiento date,
email varchar(35),
idcarrera int,
constraint FK_carrera_alumno foreign key (idcarrera) references Carreras(idcarrera),
constraint chk_dni check(dni LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')) 
)

create table Materias(
idmateria int identity primary key,
idcarrera int,
nombremateria varchar(25) NOT NULL,
anio int NOT NULL,
carga_horaria int,
constraint FK_carrera_materia foreign key (idcarrera) references Carreras(idcarrera),
constraint chk_anio_materia check (anio between '1' and '5' ),
)

create table Profesores(
idprofesor int identity primary key,
nombre varchar(25) NOT NULL,
apellido varchar(25) NOT NULL,
email varchar(35) NULL,
especialidad varchar(25),
)

create table Cursadas(
idcursada int identity primary key,
idalumno int,
idmateria int NOT NULL,
idprofesor int,
fecha_inicio date NOT NULL,
nota_final float,
estado varchar(25)
constraint FK_cursada_alumno foreign key (idalumno) references Alumnos(idalumno),
constraint FK_cursada_materia foreign key (idmateria) references Materias(idmateria),
constraint FK_cursada_profesor foreign key (idprofesor) references Profesores(idprofesor),
constraint chk_estado_cursada check (estado LIKE ('Aprobada''Reprobada')),
)


SELECT *
from Materias
WHERE carga_horaria between '64' and '128'

SELECT *
from Materias
WHERE anio LIKE ('2''3''4')

SELECT *
FROM Alumnos a
LEFT JOIN Carreras AS c ON (a.idcarrera = c.idcarrera)
where c.nombrecarrera LIKE ('Ingenieria en Informatica')

Select *
from Materias m
LEFT JOIN Cursadas AS c ON (m.idmateria = c.idmateria)
WHERE c.idalumno IS NULL

Select c.nombrecarrera, COUNT(a.fechanacimiento) AS TOTALES
FROM Carreras c
JOIN Materias AS m ON (c.idcarrera = m.idcarrera)
JOIN Alumnos AS a ON (m.idmateria = a.idcarrera)
HAVING COUNT(a.fechanacimiento) > '12/31/2000'


**// Parte 4


Select nombre, apellido, dni
from alumnos 
WHERE apellido LIKE 'Gomez' OR dni BETWEEN ('30000000''40000000')


σ email LIKE "%edu.ar" alumnos