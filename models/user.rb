class User
  include DataMapper::Resource # see: http://datamapper.org/
  
  property :id,       Serial
  property :login,    String
  property :password, String
  property :salt,     String
  
end