class Client < User

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :password, presence: true, length: { minimum: 6 }

end