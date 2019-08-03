class Person
  include Mongoid::Document

  field :email_ciphertext, type: String

  encrypts :email
end
