class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  # 唯一性验证 - 防止重复关联
  validates :product_id, uniqueness: { scope: :category_id }
end