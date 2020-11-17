-- Задача 3. Добавим сущности «Фотография» и «Комментарии к фотографии». Нужно создать
-- функционал для пользователей, который позволяет ставить лайки не только пользователям, но и
-- фото или комментариям к фото. Учитывайте следующие ограничения:
-- ● пользователь не может дважды лайкнуть одну и ту же сущность;
-- ● пользователь имеет право отозвать лайк;
-- ● необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
-- ● в будущем могут появиться новые виды сущностей, которые можно лайкать.

CREATE SCHEMA `like_user_to_entity` ;

CREATE TABLE `like_user_to_entity`.`entity` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`));
  
CREATE TABLE `like_user_to_entity`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `entity_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_entity_id_idx` (`entity_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_entity_id`
    FOREIGN KEY (`entity_id`)
    REFERENCES `like_user_to_entity`.`entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `like_user_to_entity`.`foto` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `entity_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_foto_entity_id_idx` (`entity_id` ASC) VISIBLE,
  INDEX `fk_foto_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_foto_entity_id`
    FOREIGN KEY (`entity_id`)
    REFERENCES `like_user_to_entity`.`entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_foto_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `like_user_to_entity`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `like_user_to_entity`.`comment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `entity_id` INT UNSIGNED NOT NULL,
  `foto_id` INT UNSIGNED NOT NULL,
  `comment_text` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_entity_id_idx` (`entity_id` ASC) VISIBLE,
  INDEX `fk_comment_foto_id_idx` (`foto_id` ASC) VISIBLE,
  CONSTRAINT `fk_comment_entity_id`
    FOREIGN KEY (`entity_id`)
    REFERENCES `like_user_to_entity`.`entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_foto_id`
    FOREIGN KEY (`foto_id`)
    REFERENCES `like_user_to_entity`.`foto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `like_user_to_entity`.`like_entity` (
  `user_id` INT UNSIGNED NOT NULL,
  `entity_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `entity_id`),
  INDEX `fk_like_entity_entity_id_idx` (`entity_id` ASC) VISIBLE,
  CONSTRAINT `fk_like_entity_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `like_user_to_entity`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_entity_entity_id`
    FOREIGN KEY (`entity_id`)
    REFERENCES `like_user_to_entity`.`entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    -- Посчитать число полученных сущностью лайков и вывести список пользователей, поставивших лайки;
    SELECT COUNT(*) FROM like_user_to_entity.`user` u JOIN like_user_to_entity.like_entity le ON u.id=le.user_id WHERE le.entity_id=6;
    SELECT u.name FROM like_user_to_entity.`user` u JOIN like_user_to_entity.like_entity le ON u.id=le.user_id WHERE le.entity_id=6;
    
    -- Заполним таблицы
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Petr', '1');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Mihail', '2');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Egor', '3');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Maria', '4');
	INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Anna', '5');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Yulia', '6');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Andrey', '7');
    INSERT INTO `like_user_to_entity`.`entity` (`type`) VALUES ('1');
    INSERT INTO `like_user_to_entity`.`user` (`name`, `entity_id`) VALUES ('Sergey', '8');
    
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('1', '4');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('1', '6');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('2', '5');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('2', '6');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('3', '6');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('4', '1');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('5', '3');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('6', '3');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('6', '8');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('7', '4');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('7', '6');
    INSERT INTO `like_user_to_entity`.`like_entity` (`user_id`, `entity_id`) VALUES ('8', '6');

    
  