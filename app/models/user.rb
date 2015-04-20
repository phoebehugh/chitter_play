require 'bcrypt'
require 'data_mapper'

class User

  include DataMapper::Resource
  include BCrypt

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password

  property :id,              Serial
  property :name,            String
  property :username,        String
  property :email,           String
  property :password_digest, Text

  has n, :peeps

  def password=(password)
    @password=password
    self.password_digest = BCrypt::Password.create(password)
  end

end
