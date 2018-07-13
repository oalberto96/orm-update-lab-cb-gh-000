require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    if @id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, [@name, @grade])
      @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    end
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ?
    WHERE students.id = ?
    SQL
    DB[:conn].execute(sql, [@name, @grade, @id])
  end

  def self.new_from_db(row)
    binding.pry
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end


end
