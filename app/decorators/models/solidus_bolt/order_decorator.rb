# frozen_string_literal: true

module SolidusBolt
  module OrderDecorator
    def bolt_cart
      {
        order_reference: number,
        items: line_items.map do |line_item|
          {
            sku: line_item.sku,
            name: line_item.name,
            unit_price: cents(line_item.price),
            quantity: line_item.quantity
          }
        end
      }.to_json
    end

    def bolt_user_identifier
      {
        email: email,
        phone: bill_address.phone
      }.to_json
    end

    def bolt_user_identity
      name = bill_address.name.split(' ')
      {
        first_name: name.first,
        last_name: name.last
      }.to_json
    end

    private

    def cents(float)
      (float * 100).to_i
    end

    Spree::Order.prepend(self)
  end
end
