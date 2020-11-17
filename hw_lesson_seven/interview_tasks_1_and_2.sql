-- Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки.
-- Создайте необходимые таблицы для хранения данной информации. Создайте запрос, который
-- выведет информацию:
-- ● id пользователя;
-- ● имя;
-- ● лайков получено;
-- ● лайков поставлено;
-- ● взаимные лайки.

CREATE SCHEMA `like_user_to_user` ;

CREATE TABLE `like_user_to_user`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

