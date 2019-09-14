-- Tipos de dato más comunes en MySQL

TINYINT
SMALLINT
INT
BIGINT

FLOAT 
DOUBLE(number_of_digits, digits_after_the_comma) -- Ejemplo: Double(6,2) = 1024.35

CHAR(number_of_characters) -- Reserva la memoria estáticamente
VARCHAR(number_of_characters) -- Reserva la memoria dinámicamente

DATE -- Almacena fechas pero no horas
DATETIME -- Almacena cualquier fecha. Es más lento que TIMESTAMP
TIMESTAMP -- Almacena fechas en segundos a partir del número EPOC (desde 1970)

ENUM(value1, value2, value3) -- Almacena solo los valores especificados


-- Funciones más comunes en MySQL

YEAR() -- Trae el año de una fecha
MONTH() -- Trae el mes de una fecha
DAY()  -- Trae el día de una fecha
TO_DAYS() -- Trae la cantidad de días pasados desde el 01/01/0000 hasta la fecha indicada entre paréntesis
NOW() -- Trae la fecha actual

COUNT() -- Cuenta registros
SUM() -- Suma registros
AVG() -- Promedia registros
STDDEV() -- Trae la desviación estándar de registros

MAX() -- Me trae el registro con el campo más grande
MIN() -- Me trae el registro con el campo más pequeño

CONCAT(value1, " ", value2) -- Concatena valores en una columna

-- DDL: Data Definition Language

/*

Sirve para crear la estructura de una base de datos. Se pueden manipular: 
- Esquemas o Bases de Datos
- Tablas
- Vistas

*/

-- Show: Mostrar las bases de datos y tablas existentes

SHOW DATABASES; 
SHOW TABLES; 
SHOW WARNINGS; 
SHOW FULL COLUMNS FROM `table_names`;
SELECT DATABASE(); -- Muestra la base de datos actual (en la que estamos posicionados)


-- Describe: Mostrar la estructura de una tabla

DESCRIBE `table_name`;
DESC `table_name`;

-- Use: Usar una base de datos (cambiarla a por defecto)

USE `database_name`;

-- Create: Crea bases de datos, tablas y vistas

CREATE DATABASE IF NOT EXISTS `database_name` DEFAULT CHARACTER SET utf8;

CREATE TABLE IF NOT EXISTS `table_name` (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    attr1 VARCHAR(255) NOT NULL,
    attr2 BOOLEAN NOT NULL,
    attr3 INT NOT NULL COMMENT 'random_comment', -- Comment: Añade comentario al nombre de la columna (solo puede ser visto por quien ve la estructura de la DB)
    CONSTRAINT FOREIGN KEY (attr3) REFERENCES `other_table_name` (`other_table_name_PK`) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE VIEW `view_name` AS
    SELECT * FROM `table_name`;

-- Alter: Modifica bases de datos y tablas

ALTER TABLE `table_name` AUTO_INCREMENT = 1; -- Setea el auto increment a 1

ALTER TABLE `table_name` 
ADD COLUMN `column_name` INT NOT NULL AFTER `previous_column_name`;

ALTER TABLE usuarios MODIFY COLUMN id_ciudad INT NOT NULL;

ALTER TABLE `table_name`
DROP COLUMN `column_name`

-- Drop: Borra bases de datos o tablas

DROP DATABASE `database_name`;
DROP TABLE `table_name`;


-- DML: Data Manipulation Language

/*

Manipula el contenido de una base de datos

*/

-- Truncate: Borra el contenido de una tabla

TRUNCATE `table_name`;

-- Transacciones

BEGIN TRAN `transaction_name` -- Inicia una transacción
ROLLBACK TRAN  `transaction_name` -- Vuelve atrás en una transacción
COMMIT TRAN `transaction_name` -- Confirma los cambios de una transacción 

-- Insert: Inserta tuplas en una tabla

INSERT INTO `table_name`
(attr1, attr2, attr3)
VALUES
(value1, value2, value3),
(value4, value5, value6);

INSERT INTO `table_name` SET `column_name` = value1, `other_column_name` = value2;

INSERT INTO `table_name` VALUES (value1, value2, value3)
ON DUPLICATE KEY UPDATE attr3 = VALUES (value3); -- On Duplicate Key: Realiza acciones si se repite un campo único

-- Update: Actualiza tuplas en una tabla

UPDATE `table_name`
SET `column_name` = value1
WHERE `other_column_name` = value2

-- Delete: Borra tuplas en una tabla (o borra toda la información en una tabla)

DELETE FROM `table_name`
WHERE `column_name` = value1; 

DELETE FROM `table_name`;

-- Select: Muestra tuplas en una o varias tablas. Consulta la base de datos

SELECT * FROM `table_name`; -- From: Define de donde se van a sacar los datos

SELECT DISTINCT `column_name` FROM `table_name`; -- Distinct: Me trae los los valores sin repetir los mismos 

SELECT * FROM `table_a` 
INNER // LEFT // RIGHT JOIN `table_b` -- Joins: Sirven para aplicar union, intersección y diferencia entre conjuntos
ON `table_a`.`key` = `table_b`.`key`

SELECT * FROM `table_name` AS table1; -- As: Genera alias en tablas y columnas

SELECT COUNT(*) FROM `table_name`; -- Count: Cuenta los registros

SELECT SUM(*) FROM `table_name`; -- Sum: Suma los registros

SELECT GROUP_CONCAT(*); -- Group_Concat: Concatena los registros separándolos por coma. Se puede personalizar con los modificadores DISTINCT, ORDER BY y SEPARATOR

SELECT * FROM `table_name` WHERE `column_name` = value1; -- Where: Filtra tuplas o registros a partir de condiciones

SELECT * FROM `table_name` WHERE `column_name` = value1 \G -- \G: Muestra de manera más amigable el query si el resultado se sale de la pantalla

SELECT * FROM `table_name` WHERE `column_name` LIKE '%text%'; -- Like / Not Like: Nos ayuda a traer registros de los cuales conocemos solo una parte de la información

SELECT * FROM `table_name` WHERE `column_name` BETWEEN value1 AND value2; -- Between / Not Between: Trae registros que estén en el medio de dos, ambos inlusive

SELECT * FROM `table_name` WHERE `column_name` IS IN (value1, value2, value3); -- Is in / Is not in: Trae registros que estén o no en cierto conjunto

SELECT * FROM `table_name` WHERE `column_name` IS NULL; -- Is null / Is not null: Trae registros que tengan o no un valor nulo

SELECT * FROM `table_name` GROUP BY `column_name`; -- Group By: Recorre todos los registros por la columna especificada, y coloca el primero que encuentra de cada columna

SELECT * FROM `table_name` GROUP BY `column_name` HAVING `other_column_name` = value1; -- Having: Cumple la misma función de Where, solo que sirve después de agrupar

SELECT * FROM `table_name` ORDER BY `column_name` // RAND(); -- Order By: Ordena los registros por la columna especificada. Se pueden emplear los modificadores DESC y ASC (para ordernar de manera descendente o ascendente respectivamente). Con la función RAND se ordena de manera aleatoria

SELECT * FROM `table_name` LIMIT number1; -- Limit: Trae la cantidad de registros especificada

SELECT idioma, precio
    CASE                                    -- Case: Agrega un campo virtual con información generada a partir de condiciones múltiples
        WHEN precio > 1000 THEN 'Muy caro'
        WHEN precio > 500 THEN 'Módico'
        ELSE 'Muy Barato'
    END AS 'informe'
FROM `libros` 

