class User < ApplicationRecord
  rolify
  has_secure_password :password, validations: false

  has_many :user_exam, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }

  after_create :assign_default_role

  def self.ransackable_attributes(_auth_object = nil)
    %w[email name username]
  end

  private

  def assign_default_role
    add_role(:participant) if roles.blank?
  end
end
