-- ============================================================
-- PRÁCTICA NO. 3: PERSISTENCIA DE DATOS CON POSTGRESQL Y DOCKER
-- Estudiante: Andrés Gutiérrez
-- ============================================================

-- 1. Crear la base de datos (ejecutar conectado a la base por defecto 'postgres')
CREATE DATABASE test;

-- Conectarse a la base de datos 'test' antes de ejecutar lo siguiente:
-- \c test;

-- 2. Crear la tabla 'customer' con los campos solicitados
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- 3. Insertar registros de prueba
INSERT INTO customer (fullname, status) VALUES 
('Andrés Gutiérrez', 'ACTIVE'),
('Carlos Mendoza', 'ACTIVE'),
('Lucía Fernández', 'INACTIVE');

-- 4. Consultar registros para verificación
SELECT * FROM customer;
