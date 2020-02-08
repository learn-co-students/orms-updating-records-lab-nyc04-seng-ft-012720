require_relative "../config/environment.rb"
    




class Student
  attr_accessor :name, :grade 
  attr_reader :id
  def initialize(id= nil, name, grade)
    @id = id 
    @name = name 
    @grade = grade 
  end 

  def self.create_table 
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS 
    students(
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

  def save 
    if !@id
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      sql = "UPDATE students SET name = ? WHERE id = ?"
      DB[:conn].execute(sql, @name, @id)
    end
  end 
  
  def self.create(name, grade)
    students = Student.new(name, grade)
    students.save
    students
  end

  def self.new_from_db(row)
    student_new = self.new(row[0], row[1], row[2])
    student_new
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
  end

  def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end 
end
