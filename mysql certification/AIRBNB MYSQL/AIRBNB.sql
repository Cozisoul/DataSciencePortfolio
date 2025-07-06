-- Creating Database
CREATE DATABASE airbnb;
SHOW DATABASES;
USE airbnb;


-- Creating Tables
CREATE TABLE Users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    bio TEXT,
    country VARCHAR(2)
    );
    
-- Values

INSERT INTO users (email, bio, country)
VALUES 
('hello1@world.com', 'i love strangers!', 'US'),
('hello3@world.com', 'boo', 'US');

-- Read data
 
SELECT email, id FROM Users

WHERE country = 'US'

ORDER BY id ASC
LIMIT 2;

-- Rooms Table

CREATE TABLE Rooms(
	id INT AUTO_INCREMENT,
    street VARCHAR(255),
    owner_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN key (owner_id) REFERENCES Users(id)
    ); 
    
INSERT INTO Rooms (owner_id, street)
VALUES
	(1, 'san diego sailboat'),
    (1, 'nantucket cottage'),
    (1, 'vail cabin'),
    (1, 'sf cardboard box');
    
SELECT * FROM Users
LEFT JOIN Rooms
ON Rooms.owner_id = Users.id;

 
    

            