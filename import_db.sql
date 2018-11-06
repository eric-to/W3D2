PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  parent_reply_id INTEGER,
  user_id INTEGER,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  likes INTEGER,
  user_id INTEGER,
  question_id INTEGER,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Eric', 'To'),
  ('Gabe', 'Ross');
  
INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Question One', 'Does this thing work?', 1),
  ('2nd Question', 'What is this even?', 2),
  ('Question the 3rd', 'Is this a question', 1);
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (2, 3);
  
INSERT INTO
  replies (question_id, parent_reply_id, user_id, body)
VALUES
  (1, NULL, 2, "Good question!"),
  (1, 1, 1, "Thanks!"),
  (2, NULL, 1, "Someone already asked this question.");
  
INSERT INTO
  question_likes (likes, user_id, question_id)
VALUES
  (1, 2, 3),
  (2, 2, 1),
  (3, 1, 2);