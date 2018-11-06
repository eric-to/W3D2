require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

# USER
class User
  attr_accessor :fname, :lname
  attr_reader :id
  
  def self.find_by_id(user_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    
    User.new(user.first)
  end
  
  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    
    User.new(user.first)
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end
end


# QUESTION_CLASS
class Question
  attr_accessor :title, :body, :author_id
  attr_reader :id
  
  def self.find_by_id(question_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    
    Question.new(question.first)
  end
  
  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    
    question.map { |question| Question.new(question) }
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
end


# QUESTION_FOLLOW
class QuestionFollow
  attr_accessor :user_id, :question_id
  attr_reader :id
  
  def self.find_by_id(follow_id)
    follow = QuestionsDatabase.instance.execute(<<-SQL, follow_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    
    QuestionFollow.new(follow.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    
    users.map { |user| User.new(user) }
  end
  
  def self.followed_questions_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN 
        question_follows ON questions.id = question_follows.question_id
      WHERE 
        question_follows.user_id = ?
    SQL
    
    questions.map { |question| Question.new(question) }
  end
end


# REPLY
class Reply
  attr_accessor :question_id, :parent_reply_id, :author_id, :body
  attr_reader :id
  
  def self.find_by_id(reply_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    
    Reply.new(reply.first)
  end
  
  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    
    reply.map { |reply| Reply.new(reply) }
  end
  
  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL
    
    reply.map { |reply| Reply.new(reply) }
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_reply_id)
  end
  
  def self.find_child_by_parent(parent_id)
    child_replies = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    
    child_replies.map { |child_reply| Reply.new(child_reply) }
  end
  
  def child_replies
    Reply.find_child_by_parent(@id)
  end
end


# QUESTION_LIKE
class QuestionLike
  attr_accessor :id, :user_id, :question_id
  attr_reader :id
  
  def self.find_by_id(like_id)
    like = QuestionsDatabase.instance.execute(<<-SQL, like_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    
    QuestionLike.new(like.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end