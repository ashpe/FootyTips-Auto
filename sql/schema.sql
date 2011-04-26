CREATE TABLE users(username TEXT PRIMARY KEY NOT NULL, password TEXT NOT NULL, email TEXT NOT NULL, status TEXT NOT NULL);
CREATE TABLE users_accounts(username TEXT PRIMARY KEY NOT NULL, total_accounts INTEGER NOT NULL, account_info TEXT NOT NULL);
