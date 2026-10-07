# 🌱 Sistema de Gestión Hidropónica — Trabajo Práctico SQL

Trabajo práctico de base de datos que modela la gestión de un sistema de cultivo hidropónico. El proyecto está desarrollado íntegramente en **SQL**, incluyendo el diseño de entidades, triggers y stored procedures.

> ⚠️ Proyecto en desarrollo: la estructura y el contenido de este README se irán actualizando a medida que avance el trabajo.

---

## 📋 Índice

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Modelo de datos](#-modelo-de-datos)
- [Triggers](#-triggers)
- [Stored Procedures](#-stored-procedures)
- [Instalación y ejecución](#-instalación-y-ejecución)
- [Ejemplos de uso](#-ejemplos-de-uso)
- [Integrantes](#-integrantes)

---

## 📖 Descripción

La hidroponía es una técnica de cultivo sin suelo, donde las plantas crecen con sus raíces en una solución de agua y nutrientes. Este TP propone una base de datos para registrar y controlar:

- Los cultivos y las especies de plantas.
- Los sistemas/módulos hidropónicos utilizados.
- Las soluciones nutritivas y su composición.
- Las mediciones de parámetros (pH, conductividad eléctrica, temperatura, etc.).
- Las cosechas y su rendimiento.

**Materia:** _[Nombre de la materia]_
**Institución:** _[Nombre de la institución]_
**Año / Cuatrimestre:** _[2026 – 2° cuatrimestre]_

---

## 🛠 Tecnologías

- **Motor de base de datos:** _[SQL Server / MySQL / PostgreSQL]_
- **Herramienta de gestión:** _[SSMS / MySQL Workbench / DBeaver / pgAdmin]_

---

## 📁 Estructura del repositorio

```
.
├── README.md
├── 01_creacion_base.sql        # Creación de la base de datos
├── 02_tablas.sql               # Definición de entidades y relaciones
├── 03_datos_prueba.sql         # Inserción de datos de ejemplo
├── 04_triggers.sql             # Triggers
├── 05_stored_procedures.sql    # Stored procedures
├── 06_consultas.sql            # Consultas y pruebas
└── docs/
    └── DER.png                 # Diagrama entidad-relación
```

> La estructura es tentativa y puede cambiar.

---

## 🗂 Modelo de datos

### Entidades principales (tentativas)

| Entidad | Descripción |
|---|---|
| `Especie` | Tipo de planta cultivada (lechuga, albahaca, tomate, etc.) y sus parámetros ideales. |
| `SistemaHidroponico` | Módulo o sistema de cultivo (NFT, DWC, goteo, etc.). |
| `Cultivo` | Siembra concreta de una especie en un sistema, con fechas de inicio y estado. |
| `SolucionNutritiva` | Mezcla de nutrientes aplicada a un sistema. |
| `Medicion` | Registro de pH, conductividad (EC), temperatura y nivel de agua. |
| `Cosecha` | Resultado de un cultivo: fecha, cantidad y calidad. |
| `Operario` | Persona responsable de las tareas de mantenimiento. |

### Diagrama Entidad-Relación



## ⚡ Triggers

| Trigger | Tabla | Evento | Descripción |
|---|---|---|---|
| `_[tr_nombre]_` | `_[Tabla]_` | `_[INSERT/UPDATE/DELETE]_` | _[Ej: genera una alerta cuando el pH medido sale del rango ideal de la especie]_ |
| `_[tr_nombre]_` | `_[Tabla]_` | `_[INSERT/UPDATE/DELETE]_` | _[Ej: actualiza el estado del cultivo a "Cosechado" al registrar una cosecha]_ |

---

## 🔧 Stored Procedures

| Procedimiento | Parámetros | Descripción |
|---|---|---|
| `_[sp_nombre]_` | `_[@param1, @param2]_` | _[Ej: registra una nueva medición validando los datos]_ |
| `_[sp_nombre]_` | `_[@param1]_` | _[Ej: devuelve el rendimiento de cosechas por especie en un período]_ |

---

## 🚀 Instalación y ejecución

1. Clonar el repositorio:
```bash
  https://github.com/Zoale/happy_hydro_db.git
```
2. Abrir los scripts en _[herramienta de gestión]_.
3. Ejecutarlos **en orden numérico**:
   1. `01_creacion_base.sql`
   2. `02_tablas.sql`
   3. `03_datos_prueba.sql`
   4. `04_triggers.sql`
   5. `05_stored_procedures.sql`
   6. `06_consultas.sql`

---

## 💡 Ejemplos de uso

```sql
-- Ejemplo: registrar una medición
EXEC sp_RegistrarMedicion @IdSistema = 1, @PH = 6.2, @EC = 1.8, @Temperatura = 21.5;

-- Ejemplo: consultar cultivos activos
SELECT * FROM Cultivo WHERE Estado = 'Activo';
```

> Los ejemplos se actualizarán según la implementación final.

---

## 👥 Integrantes

| Nombre | Legajo | GitHub |
|---|---|---|
| _[Nombre Apellido]_ | _[00000]_ | [@usuario](https://github.com/usuario) |
| _[Nombre Apellido]_ | _[00000]_ | [@usuario](https://github.com/usuario) |

---

## 📄 Licencia

Proyecto con fines académicos.
