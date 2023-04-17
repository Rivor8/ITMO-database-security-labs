-- Создание новой схемы
CREATE SCHEMA n33531_1_schema_lab3;

-- Создание таблиц
CREATE TABLE n33531_1_schema_lab3.students (
    student_id integer PRIMARY KEY,
    firstname varchar(128) NOT NULL,
    lastname varchar(128) NOT NULL,
    avg_score real
);

CREATE TABLE n33531_1_schema_lab3.marks (
    score real NOT NULL,
    student_id integer REFERENCES n33531_1_schema_lab3.students (student_id),
    mark_description varchar(256)
);

-- Наполнение таблиц
INSERT INTO n33531_1_schema_lab3.students (student_id, firstname, lastname) VALUES
    (1, 'Petr', 'Nekrasov'),
    (2, 'Mikhail', 'Terentev'),
    (3, 'Fedor', 'Li'),
    (4, 'Olga', 'Nitsenko'),
    (5, 'Natalia', 'Soloveva');


INSERT INTO n33531_1_schema_lab3.marks VALUES
    (5, 3, 'Test'),
    (4, 1, 'HW #1'),
    (3, 4, 'HW #5'),
    (5, 3, 'Test'),
    (4, 4, 'Quiz #1'),
    (2, 2, 'Test'),
    (3, 5, 'Quiz #7'),
    (3, 2, 'classwork'),
    (5, 5, 'Beautiful eyes');


-- Проверка

SELECT * FROM n33531_1_schema_lab3.students;
SELECT * FROM n33531_1_schema_lab3.marks;


/*

Задание 1.
Написать процедуру, которая выполняет агрегации значений в таблице и обновляет значение в другой таблице.
Таким образом, чтобы при запуске пользователем информация в таблице обновлялась и содержала агрегированные значения из другой таблицы.

*/

CREATE OR REPLACE PROCEDURE agr_score() AS
$$
DECLARE
    avg_score_st real;
    student integer;
BEGIN
    FOR student IN SELECT student_id FROM n33531_1_schema_lab3.students LOOP
        avg_score_st := (SELECT avg(score) FROM n33531_1_schema_lab3.marks WHERE student_id=student);
        UPDATE n33531_1_schema_lab3.students SET avg_score = avg_score_st WHERE student_id=student;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Тест
SELECT * FROM n33531_1_schema_lab3.students;
CALL agr_score();
SELECT * FROM n33531_1_schema_lab3.students;


/*

Задание 2.
Написать триггер, который будет выполнять действие из 1 пункта автоматически при вставке записи в исходную таблицу.
Таким образом, чтобы агрегированная информация всегда была актуальна.

*/

CREATE OR REPLACE FUNCTION upd_agr_score_trigger() RETURNS trigger AS
$$
DECLARE
    avg_score_st real;
    student integer;
BEGIN
    FOR student IN SELECT student_id FROM n33531_1_schema_lab3.students LOOP
        avg_score_st := (SELECT avg(score) FROM n33531_1_schema_lab3.marks WHERE student_id=student);
        UPDATE n33531_1_schema_lab3.students SET avg_score = avg_score_st WHERE student_id=student;
    END LOOP;
    RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_agr_score
AFTER INSERT ON n33531_1_schema_lab3.marks FOR EACH ROW 
EXECUTE PROCEDURE upd_agr_score_trigger();

-- Тест
SELECT * FROM n33531_1_schema_lab3.students;

INSERT INTO n33531_1_schema_lab3.marks VALUES
    (5, 1, 'Quiz #8'),
    (3, 4, 'classwork'),
    (2, 3, 'Test');

SELECT * FROM n33531_1_schema_lab3.students;


/*

Задание 3.
Написать триггер, который на основании даты из вставляемой записи, вставлял ее в соответствующую таблицу.

*/

-- Создам три новые таблицы для этого задания 

CREATE TABLE n33531_1_schema_lab3.people (
    name varchar(128),
    birthday date NOT NULL
);

CREATE TABLE n33531_1_schema_lab3.old_people (
    name varchar(128),
    birthday date NOT NULL
);

CREATE TABLE n33531_1_schema_lab3.young_people (
    name varchar(128),
    birthday date NOT NULL
);


-- Выполнение

CREATE OR REPLACE FUNCTION sort_people_trigger() RETURNS trigger AS
$$
BEGIN
    IF NEW.birthday >= '1960-01-01' THEN
        INSERT INTO n33531_1_schema_lab3.young_people VALUES (NEW.name, NEW.birthday);
    ELSE
        INSERT INTO n33531_1_schema_lab3.old_people VALUES (NEW.name, NEW.birthday);
    END IF;
    RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sort_people
AFTER INSERT ON n33531_1_schema_lab3.people FOR EACH ROW 
EXECUTE PROCEDURE sort_people_trigger();


-- Тест

INSERT INTO n33531_1_schema_lab3.people VALUES
    ('Aleksey', '1945-07-04'),
    ('Anna', '1967-02-20'),
    ('Fedor', '1990-10-03');

SELECT * FROM n33531_1_schema_lab3.young_people;
SELECT * FROM n33531_1_schema_lab3.old_people;


/*

Задание 4.
Написать триггер, который при вставке в таблицу, производил подмену вставляемого значения в соответствии с уже существующим словарем.

*/

-- Использую таблицы из первых двух заданий и создам новую со "словарём"

CREATE TABLE n33531_1_schema_lab3.descriptions (
    short_description varchar(256),
    long_description varchar(256)
);

INSERT INTO n33531_1_schema_lab3.descriptions VALUES
    ('HW', 'Homework'),
    ('CW', 'Classwork'),
    ('BE', 'Beautiful eyes');

-- Выполнение

CREATE OR REPLACE FUNCTION description_trigger() RETURNS trigger AS
$$
BEGIN
    IF NEW.mark_description IN (SELECT short_description FROM n33531_1_schema_lab3.descriptions) THEN 
        NEW.mark_description := (SELECT long_description FROM n33531_1_schema_lab3.descriptions 
            WHERE short_description = NEW.mark_description);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_description
BEFORE INSERT ON n33531_1_schema_lab3.marks FOR EACH ROW 
EXECUTE PROCEDURE description_trigger();


-- Тест

INSERT INTO n33531_1_schema_lab3.marks VALUES
    (4, 2, 'HW'),
    (4, 2, 'CW'),
    (5, 2, 'BE');

SELECT * FROM n33531_1_schema_lab3.marks;



/*

Задание 5.
Написать процедуру выводящую сумму первого, последнего и значений записей в таблице, находящихся в позициях золотого сечения.

*/

CREATE OR REPLACE PROCEDURE sum_proc() AS
$$
DECLARE
    pos integer;
    fib1 integer;
    fib2 integer;
    fib_tmp integer;
    sum real;
    mark real;
BEGIN
    fib1 := 1;
    fib2 := 1;
    pos := 0;
    sum := 0;

    FOR mark IN SELECT score FROM n33531_1_schema_lab3.marks LOOP
        pos := pos + 1;
        IF pos = (SELECT count(*) FROM n33531_1_schema_lab3.marks) THEN
            sum := sum + mark;
        ELSIF pos = fib2 THEN 
            sum := sum + mark;
            fib_tmp := fib2;
            fib2 := fib1 + fib2;
            fib1 := fib_tmp;
        END IF;
    END LOOP;

    RAISE NOTICE 'Sum: %', sum;
END;
$$ LANGUAGE plpgsql;

-- Тест

CALL sum_proc();