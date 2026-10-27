# Práctica No. 3: Persistencia de Base de Datos con PostgreSQL y Volúmenes Docker

**Estudiante:** Andrés Gutiérrez  
**Asignatura:** Tendencias Tecnológicas  
**Período:** 2026 – 2027  

---

## 📋 Descripción

Este proyecto documenta y comprueba experimentalmente la persistencia de datos en contenedores Docker utilizando la base de datos relacional **PostgreSQL**, comparando el comportamiento entre:
1. **Un contenedor sin volumen (`server_db1`):** Demostrando la pérdida total e irreversible de datos al eliminar el contenedor.
2. **Un contenedor con volumen administrado (`server_db2` / `pgdata`):** Demostrando la persistencia íntegra de la base de datos `test` y la tabla `customer` tras destruir y recrear el contenedor.

---

## 📁 Estructura del Repositorio

```
.
├── README.md           # Descripción general del proyecto
├── informe.md          # Informe técnico completo de la práctica
├── comandos.sh         # Script Bash automatizado con todos los comandos Docker
├── scripts.sql         # Script SQL con DDL y DML (tablas, inserts, queries)
├── .gitignore          # Archivo de exclusiones de git
└── screenshots/        # Capturas de pantalla de evidencia técnica
```

---

## 🚀 Guía rápida de ejecución

### Prerrequisitos
- Docker Engine o Docker Desktop instalado y corriendo.
- Gestor de base de datos (TablePlus, DBeaver, DataGrip o `psql`).

### Ejecución de la práctica

```bash
# 1. Dar permisos de ejecución al script
chmod +x comandos.sh

# 2. Ejecutar la secuencia completa
./comandos.sh
```

O paso a paso de forma manual:

#### Parte 1: Sin Volumen
```bash
docker run -d --name server_db1 -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
# (Crear base de datos test y registros)
docker stop server_db1 && docker rm server_db1
docker run -d --name server_db1 -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
# (Comprobar que la base test desapareció)
```

#### Parte 2: Con Volumen
```bash
docker volume create pgdata
docker run -d --name server_db2 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgres
# (Crear base de datos test y registros)
docker stop server_db2 && docker rm server_db2
docker run -d --name server_db2 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgres
# (Comprobar que la base test y sus tablas siguen intactas)
```

---

## 📄 Informe Completo

El informe detallado en formato Markdown se encuentra disponible en:  
👉 **[informe.md](./informe.md)**
