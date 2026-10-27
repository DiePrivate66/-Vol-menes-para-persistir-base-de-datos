#!/bin/bash
# ==============================================================================
# Práctica No. 3: Persistencia de datos en PostgreSQL con Volúmenes Docker
# Estudiante: Andrés Gutiérrez
# Asignatura: Tendencias Tecnológicas
# ==============================================================================

echo "======================================================================"
echo "PARTE 1: BASE DE DATOS SIN VOLUMEN (Demostración de pérdida de datos)"
echo "======================================================================"

# 1. Crear contenedor PostgreSQL sin volumen
echo ">> Creando contenedor server_db1 en puerto 5432..."
docker run -d \
  --name server_db1 \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres

# 2. Verificar que esté corriendo
docker ps

# 3. Crear base de datos 'test', tabla 'customer' e insertar datos mediante psql dentro del contenedor
echo ">> Creando base de datos 'test'..."
docker exec -i server_db1 psql -U postgres -c "CREATE DATABASE test;"

echo ">> Creando tabla 'customer' e insertando registro..."
docker exec -i server_db1 psql -U postgres -d test -c "
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100),
    status VARCHAR(20)
);
INSERT INTO customer (fullname, status) VALUES ('Andrés Gutiérrez', 'ACTIVE');
SELECT * FROM customer;
"

# 4. Detener y eliminar el contenedor server_db1
echo ">> Deteniendo y eliminando server_db1..."
docker stop server_db1
docker rm server_db1

# 5. Volver a crear el contenedor con el mismo nombre y puerto
echo ">> Volviendo a crear server_db1 (sin volumen)..."
docker run -d \
  --name server_db1 \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres

sleep 3

# 6. Comprobar si la base de datos 'test' existe
echo ">> Verificando bases de datos existentes en server_db1..."
docker exec -i server_db1 psql -U postgres -c "\l"

echo ">> Notarás que la base de datos 'test' YA NO EXISTE (datos perdidos)."

# Limpiar contenedor de la parte 1
docker stop server_db1
docker rm server_db1


echo ""
echo "======================================================================"
echo "PARTE 2: BASE DE DATOS CON VOLUMEN DOCKER (Persistencia garantizada)"
echo "======================================================================"

# 1. Crear volumen Docker gestionado
echo ">> Creando volumen Docker 'pgdata'..."
docker volume create pgdata

# Inspeccionar el volumen creado
docker volume ls
docker volume inspect pgdata

# 2. Crear contenedor server_db2 asociando el volumen al directorio de datos de PostgreSQL
echo ">> Creando contenedor server_db2 con volumen pgdata..."
docker run -d \
  --name server_db2 \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres

sleep 3

# 3. Crear base de datos 'test', tabla 'customer' e insertar datos
echo ">> Creando base de datos 'test' en server_db2..."
docker exec -i server_db2 psql -U postgres -c "CREATE DATABASE test;"

echo ">> Creando tabla e insertando registros..."
docker exec -i server_db2 psql -U postgres -d test -c "
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100),
    status VARCHAR(20)
);
INSERT INTO customer (fullname, status) VALUES ('Andrés Gutiérrez', 'ACTIVE'), ('Carlos Mendoza', 'ACTIVE');
SELECT * FROM customer;
"

# 4. Detener y eliminar el contenedor server_db2
echo ">> Deteniendo y eliminando server_db2..."
docker stop server_db2
docker rm server_db2

# 5. Volver a crear el contenedor server_db2 vinculando el mismo volumen pgdata
echo ">> Recreando server_db2 con el volumen persistente 'pgdata'..."
docker run -d \
  --name server_db2 \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres

sleep 3

# 6. Verificar que la base de datos y los datos PERSISTIERON
echo ">> Comprobando persistencia en el nuevo contenedor..."
docker exec -i server_db2 psql -U postgres -d test -c "SELECT * FROM customer;"

echo "======================================================================"
echo ">> ¡ÉXITO! Los datos persistieron correctamente a pesar de eliminar el contenedor."
echo "======================================================================"
