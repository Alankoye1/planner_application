CREATE DATABASE IF NOT EXISTS fit_planner;
USE fit_planner;
CREATE TABLE IF NOT EXISTS userAuth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    token VARCHAR(255) NOT NULL
);

INSERT INTO userAuth (username, password, email, token)
VALUES ('testuser', 'hashed_password', 'testuser@example.com', 'sample_token');