# app/helpers/carts_helper.rb

module CartsHelper
  # 获取购物车商品数量
  def cart_items_count
    return 0 unless session[:cart].present?
    session[:cart].values.sum
  end

  # 获取购物车总价
  def cart_total_price
    return 0 unless session[:cart].present?

    session[:cart].sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? product.price * quantity : 0
    end
  end

  # 检查购物车是否为空
  def cart_empty?
    session[:cart].blank? || session[:cart].empty?
  end

  # 获取购物车中特定商品的数量
  def cart_quantity_for(product)
    return 0 unless session[:cart].present?
    session[:cart][product.id.to_s].to_i
  end

  # 检查商品是否在购物车中
  def in_cart?(product)
    session[:cart].present? && session[:cart][product.id.to_s].present?
  end
end