# frozen_string_literal: true

puts 'Beginning seed'

5.times do |i|
  User.create(first_name: 'Test', last_name: "Admin+#{i + 1}", username: "testadmin+#{i + 1}", email: "testadmin+#{i + 1}@test.com", password: 'Test123$')
end
puts 'Users created'

5.times do
  order = Order.create(sales_order_number: Faker::Alphanumeric.alphanumeric(number: 6), vendor_purchase_order_number: Faker::Alphanumeric.alphanumeric(number: 11), shipping_method: 'SAMPLE', shipping_account_number: '1234', test_order: 'test', shipping_details: {IOSS: 'GB295849305'}, status: :approved)

  5.times do
    order.line_items.create(name: Faker::Commerce.product_name, line_number: rand(1..1000), quantity: rand(1..10), description: 'It is not so fluffy!', product_code: "PRT-GEN-SHGNPW", customer_product_code: '', item_properties: {thread_color: 'white'}, designs: [image_remote_url: 'https://static.pexels.com/photos/39803/pexels-photo-39803.jpeg'])
  end

  5.times do
    order.addresses.create(address_type: 5, name: Faker::Commerce.product_name, email: Faker::Internet.email, address1: Faker::Address.full_address, address2: Faker::Address.full_address, city: Faker::Address.city, state: Faker::Address.state, country: Faker::Address.country, postal_code: Faker::Address.postcode, phone: Faker::PhoneNumber.phone_number)
  end

  order.packing_lists.create(url: Faker::Internet.url)

  order.shipping_labels.create(url: Faker::Internet.url)
end
puts 'Orders created'

puts 'Seed completed'
