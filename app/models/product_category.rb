class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  # 唯一性验证 - 防止重复关联
  validates :product_id, uniqueness: { scope: :category_id }
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "id", "product_id", "updated_at"]
  end
end