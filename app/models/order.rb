class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy

  # Validations (Feature 4.2.1)
  validates :status, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }
  validates :grand_total, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :paid, -> { where(status: 'paid') }
  scope :shipped, -> { where(status: 'shipped') }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :calculate_totals

  # Status Methods
  def pending?
    status == 'pending'
  end

  def paid?
    status == 'paid'
  end

  def shipped?
    status == 'shipped'
  end

  def mark_as_paid!(stripe_payment_id = nil)
    update!(status: 'paid', stripe_payment_id: stripe_payment_id)
  end

  def mark_as_shipped!
    update!(status: 'shipped', shipped_at: Time.current)
  end

   # Associations that allow Ransack searches
  def self.ransackable_associations(auth_object = nil)
    ["address", "customer", "order_items", "payment"]
  end

  def self.ransackable_attributes(auth_object = nil)
 %w[id status total_price grand_total created_at]
  end

  private

  def calculate_totals
    self.subtotal = order_items.sum(&:subtotal)
    province = address&.province
    if province
      self.gst_amount = subtotal * (province.gst_rate / 100)
      self.pst_amount = subtotal * (province.pst_rate / 100)
      self.hst_amount = subtotal * (province.hst_rate / 100)
    end
    self.grand_total = subtotal + gst_amount + pst_amount + hst_amount
  end

end
