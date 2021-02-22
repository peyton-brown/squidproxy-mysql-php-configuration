CREATE DATABASE squid;

USE squid;

CREATE TABLE `users` (
  `user` VARCHAR(32) NOT NULL PRIMARY KEY default '',
  `password` VARCHAR(32) NOT NULL default '',
  `fullname` VARCHAR(64) default NULL
);

One line version:
	CREATE TABLE `users` (`user` VARCHAR(32) NOT NULL PRIMARY KEY default "", `password` VARCHAR(32) NOT NULL default "", `fullname` VARCHAR(64) default NULL);

INSERT INTO users VALUES('rootUser', 'rootPWD', 'Root User');

SHOW TABLES;

SELECT * FROM users;