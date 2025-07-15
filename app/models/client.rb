class Client < User

  validates :full_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, length: { minimum: 11 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

end