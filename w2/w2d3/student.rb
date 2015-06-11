class Student

  def initialize(f_name, l_name)
    @first_name = f_name
    @last_name = l_name
    @enrolled_courses = []
  end

  def name
    "#{@first_name} #{@last_name}"
  end

  def courses
    @enrolled_courses
  end

  def enroll(course)
    raise("This course conflicts with an enrolled course.") if has_conflict?(course)
    @enrolled_courses << course
    course.add_student(self)
  end

  def has_conflict?(other_course)
    @enrolled_courses.each do |course|
      return true if course.conflicts_with?(other_course)
    end
    false
  end

  def course_load
    hash = {}
    courses.each do |course|
      if hash.include?(course)
        hash[course.department] += course.credits
      else
        hash[course.department] = course.credits
      end
    end
    hash
  end
end

class Course
  attr_accessor :list_of_students, :department, :credits, :course_name, :class_days, :block

  def initialize(c_name, dept, num_creds, class_days, block)
    @course_name = c_name
    @department = dept
    @credits = num_creds
    @list_of_students = []
    @class_days = class_days
    @block = block
  end

  def students
    list_of_students
  end

  def add_student(student)
    list_of_students << student
  end

  def conflicts_with?(other_course)
    if @class_days & other_course.class_days == []
      false
    else
      @block == other_course.block ? true : false
    end
  end
end



#test
s1 = Student.new("Dave", "Cooper")
s2 = Student.new("Mark", "Zucks")
c1 = Course.new("Algebra", "Math", 4, [:mon, :wed, :fri], 1)
c2 = Course.new("Reading", "English", 5, [:tues, :thurs], 4)
c3 = Course.new("Writing", "English", 6, [:tues, :thurs], 5)

# s1.name
s1.enroll(c1)
s1.enroll(c2)
s1.enroll(c3)
s1.courses
c1.students
s1.course_load
c2.conflicts_with?(c3)
c1.conflicts_with?(c2)
