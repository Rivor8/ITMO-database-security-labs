/* Создать базу данных в соответствии с шаблоном номергруппы_номерстудента.
Выбрать базу данных в соответствии с шаблоном номергруппы_номерстудента. */

CREATE DATABASE n33531_1;


/* Создать новую схему в своей БД с именем номергруппы_номерстудента_schema_lab1. */

CREATE SCHEMA n33531_1_schema_lab1;


/* Создать таблицу номергруппы_номерстудента_tbl1 в схеме по умолчанию и 
номергруппы_номерстудента_tbl2 в созданной в пункте 3. */

CREATE TABLE n33531_1_tbl1 ();
CREATE TABLE n33531_1_schema_lab1.n33531_1_tbl2 ();


/* Создать таблицу и номергруппы_номерстудента_table_i5 в своей схеме (далее все 
объекты нужно создавать в своей схеме из пункта 3), в которой будут использовать
атрибуты с типами integer, varchar, char, timestamp, date, bytea. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_table_i5 (
    age integer,
    name varchar(40),
    pin char(4),
    birth_time timestamp,
    birth_date date,
    some_bytes bytea
);


/* Создать таблицу номергруппы_номерстудента_table_i6, в которой будет атрибут с 
любым типом со значением по умолчанию и атрибут с типом интервал времени. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_table_i6 (
    amount integer DEFAULT 0,
    int_time interval
);


/* Создать свой составной тип с именем номергруппы_номерстудента_type для описания 
свойств какого-либо объекта со свойствами real, real, date, bytea. */

CREATE TYPE n33531_1_schema_lab1.n33531_1_type AS (
    width real,
    height real,
    check_date date,
    code bytea
);


/* Создать свой тип перечисления с именем номергруппы_номерстудента_enum для 
возможности указания градации размера большой, средний, маленький. */

CREATE TYPE n33531_1_schema_lab1.n33531_1_enum AS ENUM ('small', 'medium', 'big');


/* Создать свой домен с именем номергруппы_номерстудента_domain с проверкой, что в 
нем содержится только 3 цифры. */

CREATE DOMAIN n33531_1_schema_lab1.n33531_1_domain AS integer
CHECK (
    VALUE > 99 AND
    VALUE < 1000
);


/* Создать последовательность с именем номергруппы_номерстудента_seq с началом 
1000 и шагом -1 (1000,999, 998, ...) */

CREATE SEQUENCE n33531_1_schema_lab1.n33531_1_seq AS integer
INCREMENT BY -1
START WITH 1000
MAXVALUE 1000;


/* Создать для таблицы с пункта 5 индекс с именем номергруппы_номерстудента_idx1 по 
атрибуту c типом integer. */

CREATE INDEX n33531_1_idx1 ON n33531_1_schema_lab1.n33531_1_table_i5 (age);


/* Создать составной индекс для таблицы из пункта 5 с именем 
номергруппы_номерстудента _idx2 по атрибутам integer, date */

CREATE INDEX n33531_1_idx2 ON n33531_1_schema_lab1.n33531_1_table_i5 (age, birth_date);


/* Создать индекс по выражению для таблицы из пункта 5 с именем 
номергруппы_номерстудента_idx3 по атрибуту integer, выражение взятие по 
модулю 10. */

CREATE INDEX n33531_1_idx3 ON n33531_1_schema_lab1.n33531_1_table_i5 (mod(age, 10));


/* Создать частичный индекс для таблицы из пункта 5 с именем 
номергруппы_номерстудента_idx4 по атрибуту integer, исключая значения меньше 100 
и больше 1000. */

CREATE INDEX n33531_1_idx4 ON n33531_1_schema_lab1.n33531_1_table_i5 (age) 
WHERE age > 99 AND age < 1001;


/* Создать таблицу как в пункте 5, но с ограничение NOT NULL на поле char с именем 
номергруппы_номерстудента_notnull. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_notnull (
    age integer,
    name varchar(40),
    pin char(4) NOT NULL,
    birth_time timestamp,
    birth_date date,
    some_bytes bytea
);


/* Создать таблицу как в пункте 5, но с ограничение UNIQUE на комбинацию полей char, 
integer с именем номергруппы_номерстудента_unique. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_unique (
    age integer,
    name varchar(40),
    pin char(4),
    birth_time timestamp,
    birth_date date,
    some_bytes bytea,
    UNIQUE(age, pin)
);


/* Создать таблицу как в пункте 5, но с ограничение первичного ключа поля integer с 
именем номергруппы_номерстудента_pk. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_pk (
    age integer PRIMARY KEY,
    name varchar(40),
    pin char(4),
    birth_time timestamp,
    birth_date date,
    some_bytes bytea
);


/* Создать таблицу как в пункте 5, но с ограничением проверкой поля varchar на наличие 
символа ‘a’ номергруппы_номерстудента_check. */

CREATE TABLE n33531_1_schema_lab1.n33531_1_check (
    age integer,
    name varchar(40) CHECK (name LIKE '%a%'),
    pin char(4),
    birth_time timestamp,
    birth_date date,
    some_bytes bytea
);


/* Создать представление, в котором из таблицы из пункта 5 будут представлены только 
атрибуты с типом varchar и date, имя представления номергруппы_номерстудента_view. */

CREATE VIEW n33531_1_schema_lab1.n33531_1_view AS
SELECT name, birth_date
FROM n33531_1_schema_lab1.n33531_1_table_i5;
