DROP TABLE IF EXISTS posts;

CREATE TABLE posts(
    post_id int,
    context text,
    author_id int PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE
);

-- INSERT INTO posts (post_id,context,author_id)
-- VALUES 
--     (102, 'They sent me here to serve humanity and help the world be a better place', 1),
--     (123, 'I can do this all day..', 5),
--     (135, 'I am Batman', 2),
--     (1234, 'Friendly Neighbourhood Spiderman', 10), -- throws error since foriegn key constriant is not satisfied
--     (212, 'Genius, billionaire, playboy, philanthropist', 4);

INSERT INTO posts (post_id, context, author_id) VALUES (102, 'They sent me here to serve humanity and help the world be a better place', 1);
INSERT INTO posts (post_id, context, author_id) VALUES (123, 'I can do this all day..', 5);
INSERT INTO posts (post_id, context, author_id) VALUES (135, 'I am Batman', 2);
INSERT INTO posts (post_id, context, author_id) VALUES (1234, 'Friendly Neighbourhood Spiderman', 10); -- This one fails s
INSERT INTO posts (post_id, context, author_id) VALUES (212, 'Genius, billionaire, playboy, philanthropist', 4);

SELECT 'Query posts' AS label;
SELECT * FROM posts;


--- Effect of cascade
DELETE FROM users WHERE username = 'superman';

SELECT 'Query users (after deletion)' AS label;
SELECT * FROM users;

SELECT 'Query posts (after deletion)' AS label;
SELECT * FROM posts;