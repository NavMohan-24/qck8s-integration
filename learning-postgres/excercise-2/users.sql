DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

CREATE TABLE users(
    user_id serial PRIMARY KEY,
    username text
);

INSERT INTO users (username)
VALUES
    ('superman'),
    ('batman'),
    ('spiderman'),
    ('ironman'),
    ('captain america');

SELECT 'Query Users' AS label;
SELECT * FROM users;