/*
DATABASE queries :
*/

CREATE TABLE IF NOT EXISTS LinesCount (
    id INT NOT NULL AUTO_INCREMENT,
    ObjectPath varchar(250) DEFAULT NULL,
	AmountOfLines INT DEFAULT NULL,
	Insertion_date datetime default CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
) ENGINE = INNODB;
SHOW COLUMNS FROM LinesCount;

CREATE TABLE IF NOT EXISTS WordsCount (
    ObjectPath varchar(250) DEFAULT NULL,
	AmountOfWords INT DEFAULT NULL,
	Insertion_date datetime default CURRENT_TIMESTAMP
) ENGINE = INNODB;
SHOW COLUMNS FROM WordsCount;


