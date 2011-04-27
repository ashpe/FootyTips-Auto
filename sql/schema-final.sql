SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS user_login;

CREATE TABLE user_login(user_id INTEGER AUTO_INCREMENT  PRIMARY KEY, username varchar(25) NOT NULL UNIQUE, password TEXT NOT NULL, email TEXT NOT NULL, status TEXT NOT NULL) ENGINE=INNODB;

DROP TABLE IF EXISTS tipping_websites;

CREATE TABLE tipping_websites(website_id INTEGER AUTO_INCREMENT PRIMARY KEY, website_name TEXT NOT NULL);

DROP TABLE IF EXISTS tipping_groups;

CREATE TABLE tipping_groups(group_id INTEGER AUTO_INCREMENT PRIMARY KEY, user_id INTEGER NOT NULL, group_name TEXT NOT NULL);

DROP TABLE IF EXISTS user_tipping_accounts;

CREATE TABLE user_tipping_accounts(tipping_id INTEGER AUTO_INCREMENT PRIMARY KEY, group_id INTEGER NOT NULL, website_id INTEGER NOT NULL, user_id INTEGER NOT NULL, tipping_username TEXT NOT NULL, tipping_password TEXT NOT NULL, FOREIGN KEY (group_id) REFERENCES tipping_groups(group_id)) ENGINE=INNODB;

ALTER TABLE `user_tipping_accounts` ADD FOREIGN KEY (group_id) REFERENCES 
`tipping_groups` (`group_id`);
ALTER TABLE `user_tipping_accounts` ADD FOREIGN KEY (website_id) REFERENCES 
`tipping_websites` (`website_id`);
ALTER TABLE `user_tipping_accounts` ADD FOREIGN KEY (user_id) REFERENCES 
`user_login` (`user_id`);
ALTER TABLE `tipping_groups` ADD FOREIGN KEY (user_id) REFERENCES 
`user_login` (`user_id`);


ALTER TABLE `user_login` ENGINE=InnoDB DEFAULT CHARSET=utf8 
COLLATE=utf8_bin;
ALTER TABLE `user_tipping_accounts` ENGINE=InnoDB DEFAULT CHARSET=utf8 
COLLATE=utf8_bin;
ALTER TABLE `tipping_websites` ENGINE=InnoDB DEFAULT CHARSET=utf8 
COLLATE=utf8_bin;
ALTER TABLE `tipping_groups` ENGINE=InnoDB DEFAULT CHARSET=utf8 
COLLATE=utf8_bin;

