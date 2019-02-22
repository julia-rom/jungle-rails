require 'sendgrid-ruby'
include SendGrid

class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @line_items = @order.line_items
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      send_order_email(order)
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

  def send_order_email(order)
    # using SendGrid's Ruby Library
    # https://github.com/sendgrid/sendgrid-ruby
    line_items = order.line_items
    
    product_names = ''

    line_items.each do |item|
      product_names += item.product.name + "\n"
    end

    from = Email.new(email: ENV['VALID_EMAIL_ACCOUNT'])
    to = Email.new(email: 'juliaromanowski@gmail.com')
    subject = "Thank you for your order # #{order.id}"
    puts "subjects: #{subject}"
    content = Content.new(
      type: 'text/plain',
      value: "Hello there,
      Your total order is $ #{order.total_cents / 100}.
      Your products:
      #{product_names}
      Thanks for shopping!"
    )
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

end
