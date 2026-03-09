# Alke Wallet - ABP — Base de datos para Billetera Digital

**Módulo 5:** Fundamentos de Bases de Datos Relacionales  
**Motor utilizado:** MySQL 8 · MySQL Workbench  · Local 

# Descripción del Proyecto

AlkeWallet es una billetera virtual cuya base de datos relacional permite a los usuarios:
- Almacenar y gestionar fondos en múltiples monedas.
- Realizar transferencias entre usuarios.
- Consultar el historial completo de transacciones.


Estructura del repositorio:

Proyecto ABP - Modulo 5/
    ── Registro avance/
      ── 1. Leccion 1/
        ── Alkewallet.sql      # Codigo solicitado en lección 1 (Creacion de base de datos, codigo inicial)
      ── 2. Leccion 4/
        ── Alkewallet.sql      # Se agrega codigo solicitado en lección 4 (Tablas moneda, usuarios y transaccion (DDL))
      ── 3. Leccion 5/
        ── Alkewallet.sql      # Codigo solicitado en lección 4
        ── diagrama/
          ── Alkewallet.drawio  # Se agrega diagrama de relaciones (draw.io)   
      ── 4. Leccion 3/
        ── Alkewallet.sql       # Se agrega codigo solicitado en lección 3 (DML) (Simulaciones de transacciones y errores)
      ── 5. Leccion 2/
        ── Alkewallet.sql       # Se agrega codigo solicitado en lección 2 (Consultas) (Filtros dinámicos con WHERE y Operadores Lógicos)
      
    ── Alkewallet.sql      # Codigo completo (DDL + DML + Consultas) | Proyecto final terminado
    ── README.md           # Este archivo de documentacion con explicaciones
    ── diagrama/
      ── Alkewallet.drawio   # Diagrama de relaciones (draw.io)
      ── Alkewallet.mwb      # Diagrama generado en Workbench

---

Tablas (y datos de prueba)

Tabla [moneda]: Tipo de monedas disponibles (CLP, USD, EUR, etc.)          | 3 (CLP, USD, EUR)
Tabla [usuario]: Usuarios registrados con saldo y tipo de moneda preferida | 3 (Ana, Bruno, Carla)   
Tabla [transaccion]: Registro de cada transferencia entre usuarios         | 5+ transferencias entre usuarios 


---

Diagrama Relaciones (simplificado):

moneda  1──────< usuario (N)                             1:N     (Una moneda puede ser preferida por N usuarios)
moneda  1──────< transaccion (N)                         1:N     (Una moneda puede usarse en N transacciones)
usuario 1──────< transaccion (N) [como remitente]        1:N     (Un usuario puede enviar N transacciones)
usuario 1──────< transaccion (N) [como destinatario]     1:N     (Un usuario puede recibir N transacciones)
     
---

Atributos:
(Columna + Tipo + Restricción)

Tabla [moneda]
'currency_id'     + INT          + PK · AUTO_INCREMENT 
'currency_name'   + VARCHAR(50)  + NOT NULL · UNIQUE   
'currency_symbol' + VARCHAR(10)  + NOT NULL  

Tabla [usuario]
'user_id'         + INT          + PK · AUTO_INCREMENT
'nombre'          + VARCHAR(100) + NOT NULL
'email'           + VARCHAR(150) + NOT NULL · UNIQUE
'contrasena'      + VARCHAR(255) + NOT NULL (hash SHA-256)
'saldo'           + DECIMAL(15,2)+ NOT NULL · DEFAULT 0.00 · CHECK >= 0
'currency_id'     + INT          + FK - moneda 

Tabla [transaccion]
'transaction_id'  + INT          + PK · AUTO_INCREMENT                    
'sender_user_id'  + INT          + FK - usuario (remitente)               
'receiver_user_id'+ INT          + FK - usuario (destinatario)            
'importe'         + DECIMAL(15,2)+ NOT NULL · CHECK > 0                   
'currency_id'     + INT          + FK - moneda                            
'transaction_date'+ DATETIME     + DEFAULT CURRENT_TIMESTAMP              
| —                  | —         + CHECK sender ≠ receiver             



# Proceso
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||| Proceso  (Con capturas en documento pdf entregable) |||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

LECCIÓN 1: Crear estructura inicial
  1.- Crear código para base de datos del alkewallet:
    - Se crea base de datos si esta no existe con instrucciones de cómo comparar y ordenar texto ingresado, se permite texto con símbolos asiáticos complejos y emojis, en estándar internacional unicode y que no se distinga entre mayúsculas y minúsculas.
    - Se usa la base de datos creada llamada “alkewallet” y se muestra la base de datos.

  2.- Crea tabla básica de Usuarios (con DDL + DML y consultas):
    - Se agregan restricciones para el ingreso de datos nombre, email, contraseña, saldo. (DDL)
    - Se insertan datos de prueba para verificar que Tabla usuarios funcione correctamente (DML)
    - Se usa SELECT para mostrar los datos de prueba ingresados (Consultas)
    - Se agrega código para vaciar tabla despues del uso de los datos de prueba

LECCIÓN 4: definir tablas y relaciones (DDL)
    - Definir la tabla moneda (currency_id, currency_name, currency_symbol). 
    - Definir la tabla usuario con PRIMARY KEY (user_id) y atributos básicos. 
    - Definir la tabla transacción con claves foráneas a usuario y la moneda de la Wallet. 
    - Añadir restricciones NOT NULL e índices compuestos para optimizar búsquedas. 

LECCIÓN 5: Modelo entidad-relación 
    - Extraer requerimientos y listar entidades, atributos y relaciones
    - Dibujar el diagrama ER con una herramienta libre con la extensión draw.io en VS Code
    - Definir cardinalidades y opcionalidades entre usuario, transacción y moneda
    - Aplicar reglas de normalización hasta 3FN y documentar los cambios
    - Generar el diagrama EER en MySQL Workbench, se guarda en carpeta diagrama

LECCIÓN 3: Sentencias para la manipulación de datos y transaccionalidad (DML)
    - Simular actualización de saldo de un usuario luego de una transacción
    - Simular una transacción con START TRANSACTION, COMMIT
    - Simular una transacción con ROLLBACK
    - Simular un error de integridad referencial y revertir la operación.	

LECCIÓN 2: Consultas a una o varias tablas
    - 1. Ejecutar consultas SELECT básicas sobre la tabla usuario.	15
    - 2. Implementar filtros dinámicos con WHERE y operadores lógicos.	15
    - 3. Unir las tablas transaccion y usuario mediante INNER JOIN.	16
    - 4. Practicar sub‑consultas para obtener el total de transacciones por usuario.	17

Tarea Extra Lección 4:  Modificar la tabla usuario para añadir la fecha de registro

# Explicaciones Extra
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||| Algunas Explicaciones Extra    ||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

¿Por qué normalizar?

Primera Forma Normal (1FN): Todas las columnas tienen valores atómicos (indivisibles).        || Se cumple porque no hay grupos repetidos.
Segunda Forma Normal (2FN): Todas las columnas no clave dependen de "toda" la clave primaria. || Se cumple porque todas las PKs son simples (un solo campo).
Tercera Forma Normal (3FN): No existen dependencias transitivas.                              || Por eso 'moneda' es una tabla separada: si guardáramos 'currency_name' 
                                                                                                directamente en 'usuario', ese dato dependería de 'currency_id' (no de 'user_id'), violando la 3FN.

Beneficio práctico: Si el nombre de una moneda cambia, solo se actualiza "un registro" en 'moneda', y todos los usuarios y transacciones que la referenciaban quedan correctos automáticamente.

La base de datos de Alke Wallet se encuentra normalizada hasta la 3FN para garantizar la integridad y evitar la redundancia de datos. No se procedió con una normalización mayor para mantener la simplicidad de las consultas JOIN y optimizar el tiempo de respuesta del motor MySQL en las operaciones de balance de saldo.


---


Restricciones implementadas:
(Tipo | Aplicada en | Detalle )

PRIMARY KEY     | Todas las tablas     | Identifica unívocamente cada fila 
FOREIGN KEY     | usuario, transaccion | Integridad referencial con ON UPDATE CASCADE
UNIQUE          | email, currency_name | Evita duplicados lógicos 
CHECK           | saldo, importe       | Saldo ≥ 0; Importe > 0 
CHECK           | transaccion          | emosor ≠ receptor (no auto-transferencia)
NOT NULL        | Columnas críticas    | Evita valores nulos en datos obligatorios
DEFAULT         | saldo, created_at    | Valores iniciales automáticos

---

Consultas principales (LECCIÓN 2)

SELECT basicas
- Listar todos los usuarios con su nombre y saldo actual
- Listar las monedas disponibles en el sistema

WHERE con AND (sobre usuario)
- Usuarios con saldo alto (mayor a 1000) Y que usen una moneda específica
WHERE con OR (sobre transaccion)
- Buscar transacciones que sean "grandes" (más de 50.000) O muy recientes
WHERE NOT (sobre moneda)
- Buscar todas las monedas EXCEPTO las que son de tipo 'Fiduciaria'

INNER JOIN
- Ver el historial de transacciones con los nombres de los emisores
- Ver el historial de transacciones con los nombres de los receptores
- Ver el historial completo con emisores y receptores

Subconsulta 
- Total de transacciones por usuario: Obtener el nombre del usuario y cuántas transacciones ha realizado en total

---


Principios ACID
(Propiedad + Significado | Implementación)

"Atomicidad": Todo o nada: la transacción se completa entera o se revierte | Uso de 'START TRANSACTION' + 'COMMIT' / 'ROLLBACK'
"Consistencia": La BD pasa de un estado válido a otro válido               | Restricciones CHECK, FK y NOT NULL validan el estado
"Aislamiento": Las transacciones concurrentes no interfieren entre sí      | Motor InnoDB provee aislamiento por defecto (REPEATABLE READ)
"Durabilidad": Los cambios confirmados persisten ante fallos               | InnoDB escribe en disco mediante redo log
