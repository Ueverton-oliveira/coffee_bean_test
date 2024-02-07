class User < ApplicationRecord

  VALID_EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  VALID_PASSWORD_FORMAT = /^(?=.*[a-zA-Z])(?=.*[0-9]).{10,}$/

  validates :name, presence: true, length: {minimum: 5, maximum: 128}
  validates :password, presence: true, length: {minimum: 10, maximum: 128}
  validates :email, presence: true, length: {maximum: 192}
end