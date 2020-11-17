-- Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки.
-- Создайте необходимые таблицы для хранения данной информации.

CREATE SCHEMA `like_user_to_user` ;

CREATE TABLE `like_user_to_user`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE `like_user_to_user`.`like_user` (
  `liker_id` INT UNSIGNED NOT NULL,
  `liked_user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`liker_id`, `liked_user_id`),
  INDEX `fk_like_user_liked_user_id_idx` (`liked_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_like_user_liker_id`
    FOREIGN KEY (`liker_id`)
    REFERENCES `like_user_to_user`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_user_liked_user_id`
    FOREIGN KEY (`liked_user_id`)
    REFERENCES `like_user_to_user`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- Заполняем таблицы
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Petr');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Mihail');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Egor');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Maria');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Anna');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Yulia');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Andrey');
INSERT INTO `like_user_to_user`.`user` (`name`) VALUES ('Sergey');

INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('1', '4');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('1', '6');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('2', '5');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('2', '6');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('3', '6');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('4', '1');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('5', '3');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('6', '3');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('7', '4');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('7', '6');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('8', '6');
INSERT INTO `like_user_to_user`.`like_user` (`liker_user_id`, `liked_user_id`) VALUES ('6', '8');

-- Создайте запрос, который выведет информацию:
-- ● id пользователя;
-- ● имя;
-- ● лайков получено;
-- ● лайков поставлено;
-- ● взаимные лайки.

SELECT 
    u.*,
    '' AS 'likes received',
    COUNT(*) AS `likes given`,
    '' AS 'mutual likes'
FROM
    like_user_to_user.`user` u
        JOIN
    like_user_to_user.like_user lu ON u.id = lu.liker_user_id
WHERE
    u.id = 6 
UNION SELECT 
    u.*, COUNT(*) AS `likes received`, '', ''
FROM
    like_user_to_user.`user` u
        JOIN
    like_user_to_user.like_user lu ON u.id = lu.liked_user_id
WHERE
    u.id = 6 
UNION SELECT 
    u.*, '', '', COUNT(*)
FROM
    like_user_to_user.`user` u
        JOIN
    like_user_to_user.like_user lu1 ON u.id = lu1.liker_user_id
        JOIN
    like_user_to_user.like_user lu2 ON lu1.liked_user_id = lu2.liker_user_id
WHERE
    u.id = 6 AND lu2.liked_user_id = 6;

-- Задача 2. Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк
-- пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

-- Выберем пользователей, которые лайкнули пользователей с ид 4 и 6
SELECT 
    u.*
FROM
    like_user_to_user.`user` u
        JOIN
    like_user_to_user.like_user lu ON u.id = lu.liker_user_id
WHERE
    lu.liked_user_id = 4
        OR lu.liked_user_id = 6
GROUP BY u.id
HAVING COUNT(*) = 2;

-- Выберем пользователей, которые не лайкнули пользователей с ид 5
SELECT 
    lu1.liker_user_id AS user_id
FROM
    (SELECT 
        *
    FROM
        like_user_to_user.like_user lu
    WHERE
        lu.liked_user_id = 5) AS lu5
        RIGHT JOIN
    like_user_to_user.like_user lu1 ON lu5.liker_user_id = lu1.liker_user_id
WHERE
    lu5.liker_user_id IS NULL;

-- Теперь пытаемся соединить в одно

SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        like_user_to_user.like_user lu
    WHERE
        lu.liked_user_id = 5) AS lu5
        RIGHT JOIN
    like_user_to_user.like_user lu1 ON lu5.liker_user_id = lu1.liker_user_id JOIN like_user_to_user.`user`
WHERE
    (lu5.liker_user_id IS NULL
        AND lu1.liked_user_id = 4)
        OR (lu5.liker_user_id IS NULL
        AND lu1.liked_user_id = 6)
GROUP BY lu1.liker_user_id
HAVING COUNT(lu1.liker_user_id) = 2;