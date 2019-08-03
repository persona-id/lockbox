require_relative "test_helper"

class MongoidTest < Minitest::Test
  def test_symmetric
    email = "test@example.org"
    Person.create!(email: email)
    user = Person.last
    assert_equal email, user.email
  end
end
