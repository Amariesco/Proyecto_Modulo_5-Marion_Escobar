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

/* -- Verificar todo
-- SELECT * FROM Moneda;
-- SELECT * FROM Usuario;
-- SELECT * FROM Transaccion; */

-- LECCIÓN 3: definir tablas y relaciones
/* -- 1. Simular actualizar saldo luego de una transacción

-- Simulamos que Bruno (id=2) le envía $200 USD a Carla (id=3)
SELECT user_id, nombre, saldo FROM Usuario WHERE user_id IN (2, 3); -- Verificar saldos antes
UPDATE Usuario SET saldo = saldo - 200.00 WHERE user_id = 2;  -- Bruno envía. Si el saldo de Bruno es menor a 200, esta operación fallará por la restricción CHECK que definimos en la tabla Usuario.
UPDATE Usuario SET saldo = saldo + 200.00 WHERE user_id = 3;  -- Carla recibe. 
SELECT user_id, nombre, saldo FROM Usuario WHERE user_id IN (2, 3); -- Verificar saldos después */
/* -- 2. Simular una transacción con START TRANSACTION y COMMIT. 

-- Simulamos que Ana (id=1) envía $50.000 CLP a Bruno (id=2)
SET @monto = 50000.00; -- Definimos el monto de la transacción como una variable para usarla en las consultas siguientes, y así evitar errores de tipeo o inconsistencias.
SET @emisor = 1; -- ID de Ana, quien envía el dinero
SET @receptor = 2; -- ID de Bruno, quien recibe el dinero

START TRANSACTION; -- Iniciamos una transacción para asegurar que todas las operaciones relacionadas se ejecuten de manera atómica. 
    UPDATE Usuario SET saldo = saldo - @monto WHERE user_id = @emisor; 
    UPDATE Usuario SET saldo = saldo + @monto WHERE user_id = @receptor;
    
    INSERT INTO Transaccion (usuario_envio_id, usuario_recepcion_id, importe) 
    VALUES (@emisor, @receptor, @monto);
COMMIT; -- Si alguna de las operaciones dentro del bloque falla, ninguna de las actualizaciones se aplicará, manteniendo la integridad de los datos.

-- Verificación en una sola consulta
SELECT user_id, nombre, saldo FROM Usuario WHERE user_id IN (@emisor, @receptor); */
/* -- 3. Simular una transacción con ROLLBACK.

-- Simulamos un error: intentamos dejar saldo negativo
START TRANSACTION;
    -- Intentamos restar el saldo SOLO si el usuario tiene fondos suficientes
    UPDATE Usuario SET saldo = saldo - 999999.00 WHERE user_id = 3 AND saldo >= 999999.00; -- Carla no tiene suficiente saldo, por lo que esta consulta no afectará ninguna fila (no se restará el dinero).
ROLLBACK; -- Al hacer rollback, nos aseguramos de que no se apliquen cambios 'revertimos' el saldo de Carla por lo que vuelve a lo que tenía.

-- Verificación final
SELECT user_id, nombre, saldo FROM Usuario WHERE user_id = 3; */
/* -- 4. Simular un error de integridad referencial y revertir la operación.

-- Simulamos un error: intentamos hacer una transacción con un usuario que no existe
START TRANSACTION; 
    INSERT INTO Transaccion (usuario_envio_id, usuario_recepcion_id, importe) 
    VALUES (99, 1, 1000.00); 
ROLLBACK; -- Al fallar la línea anterior por la Foreign Key, ejecutamos ROLLBACK

-- Verificación: El historial debe seguir intacto
SELECT * FROM Transaccion ORDER BY transaccion_id DESC; -- Consultamos las últimas transacciones para demostrar que el ID 99 no aparece. */

-- LECCIÓN 2: Consultas a una o varias tablas
/*-- 1. Consultas SELECT básicas
-- Listar todos los usuarios con su nombre y saldo actual
SELECT nombre, correo_electronico, saldo FROM Usuario;

-- Listar las monedas disponibles en el sistema
SELECT currency_name, currency_abrev FROM Moneda; */
/*-- 2. Filtros dinámicos con WHERE y Operadores Lógicos
-- Usuarios con saldo alto (mayor a 1000) Y que usen una moneda específica
SELECT * FROM Usuario WHERE saldo > 1000 AND currency_id = 1;

-- Buscar transacciones que sean "grandes" (más de 50.000) O muy recientes
SELECT * FROM Transaccion WHERE importe > 50000 OR transaccion_date >= '2026-03-01';

-- Buscar todas las monedas EXCEPTO las que son de tipo 'Fiduciaria'
SELECT * FROM Moneda WHERE NOT tipo_moneda = 'Fiduciaria';*/
/*-- 3. Unir tablas con INNER JOIN
-- Ver el historial de transacciones con los nombres de los emisores
SELECT t.transaccion_id, u.nombre AS emisor, t.importe, t.transaccion_date FROM Transaccion t
INNER JOIN Usuario u ON t.usuario_envio_id = u.user_id; -- Ver el historial de transacciones con los nombres de los receptores 

SELECT t.transaccion_id, u.nombre AS receptor, t.importe, t.transaccion_date FROM Transaccion t
INNER JOIN Usuario u ON t.usuario_recepcion_id = u.user_id; -- Ver el historial completo con emisores y receptores

SELECT t.transaccion_id, ue.nombre AS emisor, ur.nombre AS receptor, t.importe, t.transaccion_date FROM Transaccion t
INNER JOIN Usuario ue ON t.usuario_envio_id = ue.user_id
INNER JOIN Usuario ur ON t.usuario_recepcion_id = ur.user_id;*/
/*-- 4. Sub-consultas: Total de transacciones por usuario
-- Obtener el nombre del usuario y cuántas transacciones ha realizado en total
SELECT u.nombre,
    (SELECT COUNT(*) FROM Transaccion t WHERE t.usuario_envio_id = u.user_id) AS total_envios
FROM Usuario u; */


/*-- Tarea Extra Leccion 4:  Modificar la tabla usuario para añadir la fecha de registro
ALTER TABLE usuario 
ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Revisar la nueva estructura de la tabla
DESCRIBE usuario;
-- Ver los datos (los usuarios antiguos tendrán la fecha en que ejecutaste el ALTER)
SELECT user_id, nombre, created_at FROM usuario;*/
