CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author_id INT UNSIGNED NOT NULL,
    title VARCHAR(150) NOT NULL ,
    year INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    language VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT 'ISO 639-1 Language', 
    cover_url VARCHAR(500),
    price DOUBLE(6,2) NOT NULL DEFAULT 10.0,
    sellable TINYINT(1) DEFAULT 1,
    copies INTEGER NOT NULL DEFAULT 1,
    description TEXT
);

CREATE TABLE IF NOT EXISTS authors(
    author_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthdaate DATETIME,
    gender ENUM('M', 'F', 'ND') NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS operations (
    operation_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_id INT UNSIGNED NOT NULL,
    client_id INT UNSIGNED NOT NULL, 
    `type` ENUM('sale', 'rent') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    finished TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES books (book_id) 
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (client_id) REFERENCES clients (client_id) 
        ON DELETE NO ACTION ON UPDATE CASCADE
);

INSERT INTO authors 
(`name`, nationality)
VALUES
('Julio Cortázar', 'ARG');

INSERT INTO `clients` (`name`, email, birthdate, gender, active) VALUES
	('Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F',1),
	('Adrian Fernandez','Adrian.55818851J@random.names','1970-04-09','M',1),
	('Maria Luisa Marin','Maria Luisa.83726282A@random.names','1957-07-30','F',1),
	('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1);

INSERT INTO books(title, author_id, `year`)
VALUES
('Vuelta al Laberinto de la Soledad',
    (SELECT author_id FROM authors
     WHERE name = 'Octavio Paz'
     LIMIT 1
    ),
    1960
);

-- ¿Qué nacionalidades hay? 

SELECT nationality
FROM authors
WHERE nationality IS NOT NULL
GROUP BY nationality
ORDER BY nationality;

-- ¿Cuantos escritores hay de cada nacionalidad? 

SELECT nationality, COUNT(*) AS quantity_of_authors
FROM authors
GROUP BY nationality
ORDER BY nationality;

-- ¿Cuantos libros hay de cada nacionalidad? 

SELECT nationality, COUNT(*) AS quantity_of_books
FROM books AS b 
LEFT JOIN authors AS a
    ON b.author_id = a.author_id
GROUP BY nationality; 

-- ¿Cuál es el promedio/desviación estándar del precio de libros? 

SELECT AVG(price) as `standard_deviation` FROM books; 

-- ¿Cuál es el promedio/desviación estándar de la cantidad de autores por nacionalidad? 

SELECT AVG(quantity_of_authors) as standard_deviation_by_nationality FROM
    (SELECT COUNT(*) AS quantity_of_authors
    FROM authors
    GROUP BY nationality) 
    AS quantity_of_authors_by_nationality; 

-- ¿Cuál es el precio máximo y mínimo de un libro?

SELECT price as max_price FROM books
ORDER BY price DESC
LIMIT 1;

SELECT price as min_price FROM books
WHERE price IS NOT NULL
ORDER BY price ASC
LIMIT 1; 

-- ¿Cómo quedaría el reporte de préstamos? 

SELECT c.name, b.title, 
(CASE 
    WHEN finished = 1 THEN 'returned'
    WHEN finished = 0 THEN 'owed'
END) AS `state`
FROM transactions AS t
INNER JOIN books AS b
    ON t.book_id = b.book_id
INNER JOIN clients AS c 
    ON t.client_id = c.client_id
WHERE (`type` = 'lend' and finished = 0) or `type` = 'return' 
ORDER BY `name`; 
