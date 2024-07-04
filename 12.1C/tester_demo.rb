# tester_demo.rb
require "minitest/autorun"
require_relative "student"

class StudentTest < Minitest::Test

  def test_student_id_is_integer
    assert_kind_of Integer, get_student_id(2)
  end

# insert a test here for the finding the correct student for id 300
  def test_student_id_is_300
    assert_match "Jill", get_student_name_for_id(300)
  end
# insert a test here for returning "Not Found" for student with id 800
  def test_student_id_is_800
    assert_match "Not Found", get_student_name_for_id(800)
  end
# insert a test here for finding the correct student name for array position 0
  def test_student_name_array_position_0
    assert_match "Fred", get_student_name(0)
  end

end

