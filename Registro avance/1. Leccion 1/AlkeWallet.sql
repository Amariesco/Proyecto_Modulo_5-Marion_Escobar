-- LECCIÓN 1: crear estructura inicial

-- 1. Crear la base de datos (si esta no existe)
CREATE DATABASE IF NOT EXISTS alkewallet 
    CHARACTER SET utf8mb4 -- Para permitir caracteres asiaticos complejos y emojis
    COLLATE utf8mb4_unicode_ci; -- Para para comparar y ordenar los caracteres de un texto. Con caracteres complejos, estandar internacional unicode y que no se distinga entre mayusculas y minisculas.

-- Usar la base de datos creada
USE alkewallet;

-- Para Verificar que existe la base de datos
-- SHOW DATABASES;

-- 2. Crear la tabla de Usuarios (Entidad principal) solo si no existe con anterioridad.
CREATE TABLE IF NOT EXISTS Usuario (
    user_id INT PRIMARY KEY AUTO_INCREMENT, -- Se establece PK, con valor entero y autoincremental para que el valor sea único.
    nombre VARCHAR(100) NOT NULL, -- Dato de tipo texo, permite hasta 100 caracteres y obliga a que se ingrese un texto.
    correo_electronico VARCHAR(100) UNIQUE NOT NULL, -- Dato de tipo texto, permite hasta 100 caracteres, obliga a que sea unico y que se ingrese texto.
    contrasena VARCHAR(100) NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0.00 -- Dato de tipo decimal, con hasta 15 numeros y 2 decimales, y que parta desde 0.00 si no se ingresa monto inicial.
    -- divisa_id INT NOT NULL, -- Para asignar tipo de Moneda
);

--  Insertar un dato de prueba para verificar
-- INSERT INTO Usuario (nombre, correo_electronico, contrasena, saldo) -- Para ingresar datos a tabla Usuario
-- VALUES ('Ana', 'Ana@email.com', 'clave123', 5000.00); -- Valores de los datos a ingresar, respetar orden de INSERT INTO 

--  Consultar todos los datos para verificar
-- SELECT * FROM Usuario;

-- Para vaciar datos de prueba
-- TRUNCATE TABLE Usuario;
-- SELECT * FROM Usuario; -- consultar tabla vacia