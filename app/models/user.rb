class User < ApplicationRecord
  rolify
  has_secure_password :password, validations: false

  has_many :exams, dependent: :destroy
  has_many :questions, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }

  after_create :assign_default_role

  private

  def assign_default_role
    add_role(:participant) if roles.blank?
  end
end
