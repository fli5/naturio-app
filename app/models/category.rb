class Category < ApplicationRecord
  # Associations (Feature 4.2.2 - Many-to-Many)
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  # Validations (Feature 4.2.1)
  validates :name, presence: true, 
                   uniqueness: true, 
                   length: { maximum: 50 }
  validates :description, length: { maximum: 500 }

  # Scopes
  scope :alphabetical, -> { order(:name) }
end