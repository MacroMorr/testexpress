create table `courier`
(
    `id` int primary key auto_increment,
    `name` varchar(255) not null
);

create table `city`
(
    `id` int primary key auto_increment,
    `name` varchar(255) not null,
    `duration` smallint unsigned not null
);

create table `visit`
(
    `id` int primary key auto_increment,
    `courier_id` int not null,
    `city_id` int not null,
    `departure_date` TIMESTAMP not null,
    `arrival_date` TIMESTAMP not null,

    foreign key (`courier_id`) references `courier`(`id`),
    foreign key (`city_id`) references `city`(`id`)
);




DROP PROCEDURE IF EXISTS generate_data;
DELIMITER $$
    DROP FUNCTION IF EXISTS getRandomCityId;
    CREATE FUNCTION getRandomCityId()
        RETURNS INT DETERMINISTIC
    BEGIN
        declare x INT;
        SET x := (SELECT r1.id
                  FROM city AS r1 JOIN
                       (SELECT CEIL(RAND() * (SELECT MAX(city.id) FROM city)) AS id) AS r2
                  WHERE r1.id >= r2.id
                  ORDER BY r1.id
                  LIMIT 1);
        RETURN x;
    END;

    DROP FUNCTION IF EXISTS getRandomCourierId;
    CREATE FUNCTION getRandomCourierId()
        RETURNS INT DETERMINISTIC
    BEGIN
        declare x INT;
        SET x := (SELECT r1.id
                  FROM courier AS r1 JOIN
                       (SELECT CEIL(RAND() * (SELECT MAX(courier.id) FROM courier)) AS id) AS r2
                  WHERE r1.id >= r2.id
                  ORDER BY r1.id
                  LIMIT 1);
        RETURN x;
    END;

    CREATE PROCEDURE generate_data ()
    BEGIN
        DECLARE i smallint DEFAULT 1;
        DECLARE d DATE DEFAULT '2019-06-01';

        INSERT INTO city (name, duration) VALUES ('Санкт-Петербург', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Уфа', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Нижний Новгород', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Владимир', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Кострома', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Екатеринбург', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Ковров', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Воронеж', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Самара', FORMAT(RAND()*(100-1)+1, 0));
        INSERT INTO city (name, duration) VALUES ('Астрахань', FORMAT(RAND()*(100-1)+1, 0));

        -- Past courier
        WHILE i < 100 DO
            INSERT INTO courier (name) VALUES (CONCAT('Courier ', i));
            SET i = i + 1;
        END WHILE;

        -- Past visits
        WHILE d < current_date() DO
            INSERT INTO visit (courier_id, city_id, departure_date, arrival_date)
            VALUES (getRandomCourierId(), getRandomCityId(), TIMESTAMP(d), TIMESTAMP(d + INTERVAL 1 DAY));
            SET d = d + INTERVAL 1 DAY;
        END WHILE;
    END
$$
DELIMITER ; -- вернем прежний разделитель

CALL generate_data();

DROP FUNCTION IF EXISTS getRandomCityId;
DROP FUNCTION IF EXISTS getRandomCourierId;
DROP PROCEDURE IF EXISTS getRandomCourierId;