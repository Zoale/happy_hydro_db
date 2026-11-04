# 🌱 Sistema de Gestión Hidropónica — TP SQL - GRUPO 7

Trabajo práctico de base de datos que modela la gestión de un sistema de cultivo hidropónico. El proyecto está desarrollado íntegramente en **SQL**, incluyendo el diseño de entidades, triggers, stored proceduresy vistas.


## 📋 Índice

- [Contexto](#-contexto)
- [Tecnologías](#-tecnologías)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Modelo de datos](#-modelo-de-datos)
- [Integrantes](#-integrantes)

## Contexto

La hidroponía es una técnica de cultivo sin suelo en la que las plantas crecen con sus raíces en una solución de agua y nutrientes, dentro de un ambiente controlado como un invernadero, para que el cultivo prospere, es necesario mantener estables una serie de parámetros ambientales, proveer sales de nutrición a las plantas y llevar un seguimiento detallado de cada etapa de la planta.

## Problemática

La hidroponía es una técnica de cultivo sin suelo en la que las plantas crecen con sus raíces en una solución de agua y nutrientes, dentro de un ambiente controlado como un invernadero. Para que el cultivo prospere, es necesario mantener estables una serie de parámetros ambientales y llevar un seguimiento detallado de cada etapa de la planta.
A partir del relevamiento realizado con una persona que gestiona un cultivo, se identificó que actualmente los invernaderos son administrados mediante tareas manuales. Las personas a cargo deben controlar de forma periódica parámetros como la temperatura, la humedad, los nutrientes, la iluminación y la ventilación. A esto se suma el registro de la fase en la que se encuentra cada planta (vegetación o floración), las fechas de plantación y de cosecha, y el tiempo de curado. Además, como las torres de hidroponias llevan agua, y el agua se evapora, el empleado responsable de controlar el agua debe verificarlo a ojo, es decir, debe ir a cada torre e identificar si falta agua o no con lo que observa en la maceta.
El encendido y apagado de las luces se controla mediante timers que deben configurarse manualmente, y toda la información del cultivo se asienta en un cuaderno. Este método resulta rutinario y poco eficiente: depende de la constancia de quien registra, dificulta detectar a tiempo valores fuera de lo normal y no permite consultar el historial de forma ágil.


**Materia:** Ingeniería de Datos I
**Institución:** UADE
**Año / Cuatrimestre:** 2026 – 2° cuatrimestre

## 🛠 Tecnologías

- **Motor de base de datos:** SQL Server
- **Herramienta de gestión:** SSMS

## 📁 Estructura del repositorio

```
.
├── README.md
├── 1-. Creacion de BD y Tablas.sql   # Creación de la base, tablas y restricciones
├── 2-. Inserts de datos.sql          # Datos de prueba
├── 3-. Funciones.sql                 # Funciones definidas por el usuario
├── 4-. Vistas.sql                    # Vistas
├── 5-. Stored Procedures.sql         # Stored procedures
├── 6-. Triggers.sql                  # Triggers
├── 7-. Seguridad.sql                 # Usuarios, roles y permisos
├── 8-. Consultas.sql                 # Consultas SQL
├── 9-. Subconsultas.sql              # Consultas con subconsultas
└── docs/
    └── DER.png                       # Diagrama entidad-relación
```


## 🗂 Modelo de datos

### Entidades principales 

| Entidad         | Descripción                                                                                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `Especie`       | Tipo de planta cultivada (lechuga, albahaca, tomate, etc.) y sus parámetros ideales.                                    |
| `Sistema_Torre` | Cada torre pose parametros como ubicacion y agua, donde se cultivaran las plantas                                       |
| `Cultivos`      | Siembra concreta de una especie en un sistema, con fechas de inicio y estado.                                           |
| `Tareas`        | Tareas que se deben realizar en base a los estados de las torres hidroponicas                                           |
| `Tipo_tareas`   | Descripción de cada tarea que se debe realizar                                                                          |
| `Sensor`        | Para medir los valores de las torres, se deben colocar sensores que registran las mediciones. Cada torre tiene sensores |
| `Etapa`         | Descripcion de las etapas que atraviesa un cultivo                                                                      |
| `Especie_etapa` | Se registra la etapa de cada especie con el valor de sus nutrientes                                                     |
| `Medicion`      | Valores obtenidos de cada sensor                                                                                        |
| `Empleado`      | Persona responsable de las tareas de mantenimiento.                                                                     |

### Diagrama Entidad-Relación

![DER](docs/DER.png)


## 🚀 Instalación y ejecución

1. Clonar el repositorio:

```bash
git clone https://github.com/Zoale/happy_hydro_db.git
```

2. Abrir los scripts en _[SSMS]_.
3. Ejecutarlos **en orden numérico**, del `1-.` al `9-.`.

## 💡 Ejemplos de uso

```sql
-- Ejemplo: registrar un nuevo cultivo
EXEC SP_RegistrarCultivo @id_especie = 1, @id_torre = 1, @cantidad_plantas = 15;

-- Ejemplo: consultar cultivos activos
SELECT * FROM cultivos WHERE estado = 'EN PROGRESO';
```

> Los ejemplos se actualizarán según la implementación final.


Trello

```bash
https://trello.com/b/atc55BkM/tp-ing-datos-i
```

## 👥 Integrantes

| Integrantes — Grupo 7  |
| ---------------------- |
| Alejandro Zoilo Guzman |
| Diego Rua              |
| Macarena Molina        |
| Nicolas Puegher        |
| Guido Botta            |

## 📄 Licencia

Proyecto con fines académicos.
