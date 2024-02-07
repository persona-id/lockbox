require_relative "test_helper"
class ModelTypesTest < Minitest::Test
  def setup
    skip unless mongoid?
  end

  def test_boolean_true
    User.create!(active: true)
    user = User.last
    assert user.active
  end

  # def test_boolean_false
  #   User.create!(active: false)
  #   user = User.last
  #   assert_false user.active
  # end
end