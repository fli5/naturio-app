class Customer < ApplicationRecord
  # Devise modules (Feature 3.1.4)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error

  # Validations (Feature 4.2.1)
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 3, maximum: 50 }
  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 50 }

  # Methods
  def primary_address
    addresses.find_by(address_type: 'shipping') || addresses.first
  end

  def full_name
    username
  end

   # 明确指定哪些字段可搜索
  def self.ransackable_attributes(auth_object = nil)
    # 只列出你希望在 ActiveAdmin / Ransack 中可搜索的字段
    ["id", "email", "username", "created_at", "updated_at"]
  end
end