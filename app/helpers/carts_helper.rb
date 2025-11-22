module CartsHelper
  # Get the quantity of items in the shopping cart
  def cart_items_count
    return 0 unless session[:cart].present?
    session[:cart].values.sum
  end

  # Get total shopping cart price
  def cart_total_price
    return 0 unless session[:cart].present?

    session[:cart].sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? product.price * quantity : 0
    end
  end

  # Check if shopping cart is empty
  def cart_empty?
    session[:cart].blank? || session[:cart].empty?
  end

  # Get the quantity of a specific item in the shopping cart
  def cart_quantity_for(product)
    return 0 unless session[:cart].present?
    session[:cart][product.id.to_s].to_i
  end

  # Check if the item is in the shopping cart
  def in_cart?(product)
    session[:cart].present? && session[:cart][product.id.to_s].present?
  end
end
