DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

-- USERS
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

-- QUESTIONS
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- QUESTION_FOLLOWS
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- REPLIES
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- QUESTION_LIKES
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Gabe", "Ross"),
  ("Eric", "To"),
  ("Cynthia", "Ma"),
  ("Kush", "Patel"),
  ("Sue", "Park");
  
INSERT INTO
  questions (title, body, author_id)
VALUES
  ("Gabe Question", "Does this thing even work?", 1),
  ("Eric Question", "Why are we doing this?", 2),
  ("Cynthia Question", "I know everything. This isn't a question.", 3),
  ("Kush Question", "Do you like App Academy?", 4),
  ("Sue Question", "Is this a question?", 5);
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (3, 2),
  (4, 5);
  
INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  (1, NULL, 1, "EXCELLENT question!!!"),
  (1, 1, 2, "Thanks!!!"),
  (5, NULL, 4, "!!! WOW !!!");
  
INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 2),
  (2, 1),
  (1, 3),
  (4, 1),
  (4, 2),
  (5, 2);
