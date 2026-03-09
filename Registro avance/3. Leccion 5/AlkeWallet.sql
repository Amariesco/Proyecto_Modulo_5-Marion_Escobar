-- LECCIÓN 1: crear estructura inicial

-- 1. Crear la base de datos (si esta no existe)
CREATE DATABASE IF NOT EXISTS alkewallet 
    CHARACTER SET utf8mb4 -- Para permitir caracteres asiaticos complejos y emojis
    COLLATE utf8mb4_unicode_ci; -- Para para comparar y ordenar los caracteres de un texto. Con caracteres complejos, estandar internacional unicode y que no se distinga entre mayusculas y minisculas.

-- Usar la base de datos creada
USE alkewallet;
-- Eliminar tablas para evitar conflictos al volver a ejecutar el script, el orden es para evitar errores de claves foráneas.
DROP TABLE IF EXISTS Transaccion;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Moneda;

-- LECCIÓN 4: definir tablas y relaciones

-- 1. Tabla Moneda (Debe existir antes que Usuario por dependencia)
CREATE TABLE IF NOT EXISTS Moneda (
    currency_id INT PRIMARY KEY AUTO_INCREMENT, -- Se establece PK, con valor entero y autoincremental para que el valor sea único.
    currency_name VARCHAR(50) NOT NULL UNIQUE,  -- Diferente a currency_symbol para evitar confusión, y que sea único para evitar duplicación (ej: Dolar, Peso)
    currency_symbol VARCHAR(10) NOT NULL, 		-- Símbolo de la moneda (ej: $, €, ¥), no es único porque puede haber monedas con el mismo símbolo.
    currency_abrev VARCHAR(5) NOT NULL UNIQUE,     -- Abreviación de la moneda (ej: USD, EUR, JPY), debe ser única para evitar confusión.
    tipo_moneda VARCHAR(20) DEFAULT 'Fiduciaria' -- En categoria Fiducidiario por si despues agregamos tipo de moneda Cripto o Digital
);

-- 2. Tabla Usuario (Con relación a Moneda)
CREATE TABLE IF NOT EXISTS Usuario (
    user_id INT PRIMARY KEY AUTO_INCREMENT, -- Se establece PK, con valor entero y autoincremental para que el valor sea único.
    nombre VARCHAR(100) NOT NULL, -- Dato de tipo texo, permite hasta 100 caracteres y obliga a que se ingrese un texto.
    correo_electronico VARCHAR(100) NOT NULL UNIQUE, -- Dato de tipo texto, permite hasta 100 caracteres, obliga a que sea unico y que se ingrese texto.
    contrasena VARCHAR(255) NOT NULL, -- Para almacenar la contraseña de forma segura. Aumentamos a 255 para soportar hashes largos y seguros
    saldo DECIMAL(15, 2) DEFAULT 0.00 NOT NULL CHECK (saldo >= 0), -- Dato de tipo decimal, con hasta 15 numeros y 2 decimales, y que parta desde 0.00 si no se ingresa monto inicial.
    currency_id INT, -- Clave Foránea para relacionar con la tabla Moneda
    FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id) -- Establece la relación entre Usuario y Moneda, asegurando que cada usuario tenga una moneda válida.
);

-- 3. Tabla Transaccion (Relaciona dos usuarios entre sí)
CREATE TABLE IF NOT EXISTS Transaccion (
    transaccion_id INT PRIMARY KEY AUTO_INCREMENT, -- Se establece PK, con valor entero y autoincremental para que el valor sea único.
    usuario_envio_id INT, -- ID de usuario que envía
    usuario_recepcion_id INT, -- ID de usuario que recibe
    importe DECIMAL(15, 2) NOT NULL, -- Dato de tipo decimal, con hasta 15 numeros y 2 decimales, y que no permita valores nulos.
    transaccion_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora de la transacción, con valor por defecto de la fecha y hora actual.
    FOREIGN KEY (usuario_envio_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (usuario_recepcion_id) REFERENCES Usuario(user_id)
);

-- Insertar datos de prueba a tabla Moneda (3)
INSERT INTO Moneda (currency_name, currency_symbol, currency_abrev)
VALUES  ('Peso Chileno','$', 'CLP'),
        ('Dólar Americano', '$', 'USD'),
        ('Euro', '€', 'EUR');

-- Insertar datos de prueba a tabla Usuarios (3) (contraseñas hasheadas usando SHA2 para mayor seguridad)
INSERT INTO Usuario (nombre, correo_electronico, contrasena, saldo, currency_id) 
VALUES  ('Ana Torres', 'ana@mail.com', SHA2('clave123', 256), 150000.00, 1),
        ('Bruno Salinas', 'bruno@mail.com', SHA2('clave456', 256),    500.00, 2),
        ('Carla Muñoz', 'carla@mail.com', SHA2('clave789', 256),    350.00, 3);

-- Insertar datos de prueba a tabla transacciones (5) (IDs de usuario basados en los insertados previamente, y montos variados para probar diferentes casos) 
INSERT INTO Transaccion (usuario_envio_id, usuario_recepcion_id, importe) 
VALUES  (1, 2, 50000.00),
        (2, 3,   200.00),
        (3, 1,   100.00),
        (1, 3, 30000.00),
        (2, 1,    75.50);

-- Verificar todo
SELECT * FROM Moneda;
SELECT * FROM Usuario;
SELECT * FROM Transaccion;