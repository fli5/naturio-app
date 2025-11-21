class Product < ApplicationRecord
  # Active Storage (Feature 5.2)
  has_one_attached :image
  has_many_attached :images  # 多图支持

  # Associations (Feature 4.2.2 - Many-to-Many)
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items, dependent: :restrict_with_error

  # Validations (Feature 4.2.1)
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :price, presence: true, 
                    numericality: { greater_than: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  # Scopes (Feature 2.4 - Filtering)
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :recently_updated, -> { where('updated_at >= ?', 7.days.ago) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :alphabetical, -> { order(:name) }
  scope :by_price_asc, -> { order(:price) }
  scope :by_price_desc, -> { order(price: :desc) }

  # Search (Feature 2.6)
  scope :search_by_keyword, ->(keyword) {
    where('name ILIKE :q OR description ILIKE :q', q: "%#{keyword}%")
  }

  # Methods
  def in_stock?
    stock_quantity.positive?
  end

  def thumbnail
    return unless image.attached?
    image.variant(resize_to_limit: [150, 150])
  end

  def medium_image
    return unless image.attached?
    image.variant(resize_to_limit: [400, 400])
  end
end