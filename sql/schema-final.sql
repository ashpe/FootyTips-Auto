DROP TABLE IF EXISTS user_logins;

CREATE TABLE user_logins(user_id INTEGER AUTO_INCREMENT  PRIMARY KEY, username varchar(25) NOT NULL UNIQUE, password TEXT NOT NULL, email TEXT NOT NULL, status TEXT NOT NULL);

DROP TABLE IF EXISTS user_tipping_accounts;

CREATE TABLE user_tipping_accounts(tipping_id INTEGER AUTO_INCREMENT PRIMARY KEY, group_id INTEGER NOT NULL, website_id INTEGER NOT NULL, user_id INTEGER NOT NULL, tipping_username TEXT NOT NULL, tipping_password TEXT NOT NULL);

DROP TABLE IF EXISTS tipping_websites;

CREATE TABLE tipping_websites(website_id INTEGER AUTO_INCREMENT PRIMARY KEY, website_name TEXT NOT NULL);

DROP TABLE IF EXISTS tipping_groups;

CREATE TABLE tipping_groups(group_id INTEGER AUTO_INCREMENT PRIMARY KEY, user_id INTEGER NOT NULL, group_name TEXT NOT NULL);
