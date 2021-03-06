class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def initialize
    @@all << self
  end

  def self.all_in_class
    @@all
  end

  def self.new_from_db(row)
    new_id = row[0]
    new_name = row[1]
    new_grade = row[2]
    new_student = Student.new
    new_student.id = new_id
    new_student.name = new_name
    new_student.grade = new_grade
    new_student
  end

  def self.all

    Student.all_in_class.clear
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    table = DB[:conn].execute(sql)
    table.each do |row|
      new_student = Student.new
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
    Student.all_in_class
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    row = DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql)

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
     self.new_from_db(row)
     end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.first_X_students_in_grade_10(number)

    Student.all_in_class.clear

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = '10'
      LIMIT ?
    SQL

    table = DB[:conn].execute(sql, number)
    table.each do |row|
      new_student = Student.new
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
    Student.all_in_class

  end


  def self.first_student_in_grade_10

    new_student = nil

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = '10'
      LIMIT 1
    SQL

    rows = DB[:conn].execute(sql)
    rows.each do |row|
      new_student = Student.new
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
    new_student


  end



  def self.all_students_in_grade_X(grade)

    Student.all_in_class.clear

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL
    table = DB[:conn].execute(sql, grade)
    table.each do |row|
      new_student = Student.new
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
    Student.all_in_class

  end

end
