class Student
  attr_reader :courses, :fname, :lname

  def initialize(fname, lname)
    @fname, @lname = fname.capitalize, lname.capitalize
    @courses = []
  end

  def name
    "#{fname} #{lname}"
  end

  def enroll(course)
    # ignore re-adding a course
    return if courses.include?(course)
    # raise "course would cause conflict!" if has_conflict?(course)

    self.courses << course
    course.students << self
  end

  def course_load
    load_hash = Hash.new(0)

    self.courses.each do |course|
      load_hash[course.department] += course.num_credits
    end

    p load_hash
  end

  def has_conflict?(new_course)
    self.courses.any? do |enrolled_course|
      new_course.conflicts_with?(enrolled_course)
    end
  end
end

class Course
  attr_reader :department, :name, :num_credits, :time_block, :days, :students

  def initialize(name, department, num_credits, time_block, days)
    @name, @department, @num_credits, @time_block, @days =
      name, department, num_credits, time_block, days
    @students = []
  end

  def conflicts_with?(course2)
    return false if self.time_block != course2.time_block

    days.any? do |day|
      course2.days.include?(day)
    end
  end

  def add_student(student)
    student.enroll(self)
  end
end

#test
s1 = Student.new("Dave", "Cooper")
s2 = Student.new("Mark", "Zucks")
c1 = Course.new("Algebra", "Math", 4, [:mon, :wed, :fri], 1)
c2 = Course.new("Reading", "English", 5, [:tues, :thurs], 4)
c3 = Course.new("Writing", "English", 6, [:tues, :thurs], 5)
s1.enroll(c1)
s1.enroll(c2)
s1.enroll(c3)
s1.courses
c1.students
s1.course_load
