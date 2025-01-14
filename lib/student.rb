require 'pry'
require_relative "../config/environment.rb"

class Student

attr_accessor :name, :grade, :id

def initialize(name, grade, id=nil)
  @name = name
  @grade = grade
  @id = id
end

def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
  )
  SQL

  DB[:conn].execute(sql)
end

def self.drop_table
  sql = "DROP TABLE IF EXISTS students"
  DB[:conn].execute(sql)
end

def self.drop_table
  sql = "DROP TABLE IF EXISTS students"
  DB[:conn].execute(sql)
end

def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
end

def save
  if self.id
    self.update
  else
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

def self.create(name, grade)
  student = self.new(name,grade)
  student.save
end


def self.new_from_db(row)

  student = self.new(row[1],row[2],row[0])
   # self.new is the same as running Song.new
    # creatprye a new Student object given a row from the database
end

def self.find_by_name(name)
  sql = <<-SQL
    SELECT * FROM  students
    WHERE students.name = ?
    limit 1
  SQL

  DB[:conn].execute(sql,name).map do |row|
    self.new_from_db(row)
    end.first
  end

end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
