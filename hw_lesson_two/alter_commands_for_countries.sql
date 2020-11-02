ALTER TABLE `geodata`.`_countries` 
CHANGE COLUMN `country_id` `id` INT NOT NULL AUTO_INCREMENT ,
ADD PRIMARY KEY (`id`);
;

ALTER TABLE `geodata`.`_countries` 
CHANGE COLUMN `title_en` `title` VARCHAR(150) NOT NULL ,
ADD INDEX `title_index` (`title` ASC) VISIBLE;
;

ALTER TABLE `geodata`.`_countries` 
DROP COLUMN `title_be`,
DROP COLUMN `title_ua`,
DROP COLUMN `title_ru`,
DROP COLUMN `title_cz`,
DROP COLUMN `title_lv`,
DROP COLUMN `title_lt`,
DROP COLUMN `title_ja`,
DROP COLUMN `title_pl`,
DROP COLUMN `title_it`,
DROP COLUMN `title_fr`,
DROP COLUMN `title_de`,
DROP COLUMN `title_pt`,
DROP COLUMN `title_es`;