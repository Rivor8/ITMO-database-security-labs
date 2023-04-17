-- Для начала создам новую схему и две таблицы

CREATE SCHEMA n33531_1_schema_lab2;
CREATE TABLE n33531_1_schema_lab2.authors_table (
    id integer PRIMARY KEY,
    name varchar(64) NOT NULL,
    birthday date,
    deathday date
);
CREATE TABLE n33531_1_schema_lab2.books_table (
    id integer PRIMARY KEY,
    title varchar(128) NOT NULL,
    genre varchar(128),
    author_id integer references n33531_1_schema_lab2.authors_table(id)
);

/* 1. Наполнить таблицы базы данных при помощи операторов INSERT. Каждая таблица 
должна иметь не менее 5 разных записей. */

INSERT INTO n33531_1_schema_lab2.authors_table (id, name, birthday, deathday) 
VALUES
(0, 'Толстой, Лев Николаевич', '1828-09-09', '1910-11-20'),
(1, 'Булгаков, Михаил Афанасьевич', '1891-05-15', '1940-03-10'),
(2, 'Набоков, Владимир Владимирович', '1899-04-22', '1977-07-02'),
(3, 'Толкин, Джон Рональд Руэл', '1892-01-03', '1973-09-02'),
(4, 'Льюис, Клайв Стейплз', '1898-11-29', '1963-11-22');
5
INSERT INTO n33531_1_schema_lab2.books_table (id, title, genre, author_id) 
VALUES
(0, 'Собачье сердце', 'повесть', 1),
(1, 'Мастер и Маргарита', 'любовный роман, модернизм в литературе', 1),
(2, 'Война и мир', 'роман', 0),
(3, 'Приглашение на казнь', 'роман', 2),
(4, 'Властелин Колец. Братство Кольца', 'роман-эпопея', 3),
(5, 'Хоббит, или туда и обратно', 'сказка', 3),
(6, 'Хроники Нарнии: Лев, колдунья и платяной шкаф', 'фантастик, детская и 
подростковая литература', 4);


/* 2. Обновить записи в одной таблице на основании записи из другой (между таблицами 
должна быть связь). */

UPDATE n33531_1_schema_lab2.books_table SET genre='фантастика'
WHERE author_id = (SELECT id FROM n33531_1_schema_lab2.authors_table
WHERE name = 'Льюис, Клайв Стейплз');


/* 3. Удалить несколько записей из одной таблицы на основании информации из другой 
таблицы. */

DELETE FROM n33531_1_schema_lab2.books_table
WHERE author_id = (SELECT id FROM n33531_1_schema_lab2.authors_table
WHERE birthday > '1892-01-01' AND birthday < '1892-12-31');


/* 4. Вывести часть столбцов из таблицы. */

SELECT title, genre FROM n33531_1_schema_lab2.books_table;


/* 5. Вывести несколько записей из таблицы, используя условие ограничения. */

SELECT * FROM n33531_1_schema_lab2.authors_table
WHERE deathday < '1965-01-01';


/* 6. Сделать декартово произведение двух таблиц. */

SELECT * FROM n33531_1_schema_lab2.books_table
CROSS JOIN n33531_1_schema_lab2.authors_table;


/* 7. Вывести записи из таблицы на основании условия ограничения, содержащегося в 
другой таблице. */

SELECT * FROM n33531_1_schema_lab2.books_table
WHERE author_id IN (SELECT id FROM n33531_1_schema_lab2.authors_table
WHERE birthday > '1894-01-01');


/* 8. Применить функции агрегирования к выводимым записям (sum, avg, min, max). */

-- Для выполнения этого пункта создам новую таблицу, так как к существующим 
-- таблицам не получится применить sum и avg.

CREATE TABLE n33531_1_schema_lab2.price_table (
    id integer PRIMARY KEY,
    price real NOT NULL,
    book_id integer references n33531_1_schema_lab2.books_table(id)
);
INSERT INTO n33531_1_schema_lab2.price_table (id, price, book_id)
VALUES
(0, 257.0, 0),
(1, 660.0, 1),
(2, 506.0, 3),
(3, 552.0, 6);

-- Далее выполнение

SELECT sum(price) FROM n33531_1_schema_lab2.price_table;
SELECT avg(price) FROM n33531_1_schema_lab2.price_table;
SELECT min(birthday) FROM n33531_1_schema_lab2.authors_table;
SELECT max(deathday) FROM n33531_1_schema_lab2.authors_table;


/* 9. Вывести записи из таблицы, используя сортировку от большего к меньшему. */

SELECT * FROM n33531_1_schema_lab2.books_table
ORDER BY title DESC;


/* 10. Вывести записи из таблицы, используя сортировку от меньшего к большему с 
ограничением количества выводимых строк. */

SELECT * FROM n33531_1_schema_lab2.books_table
ORDER BY title
LIMIT 3;


/* 11. Произвести агрегирование выводимых записей по одному из полей (group by). */

SELECT count(*) as books_count, genre FROM n33531_1_schema_lab2.books_table
GROUP BY genre;


/* 12. Выполнить запрос, когда табличное выражение представляет собой другой запрос. */

WITH first_half AS (
SELECT title, genre FROM n33531_1_schema_lab2.books_table
WHERE title < 'Р'
)
SELECT * FROM first_half
WHERE genre = 'роман'
ORDER BY title;
