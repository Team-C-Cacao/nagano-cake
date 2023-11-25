# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  15.times do |n|
    Customer.create!(
      last_name: "試験#{n + 1}",
      first_name: "太郎#{n + 1}",
      last_name_kana: "テスト#{n + 1}",
      first_name_kana: "タロウ#{n + 1}",
      postal_code: "000000#{n + 1}",
      address: "カカオ町#{n + 1}",
      phone_number: "000000#{n + 1}",
      email: "test#{n + 1}@test.com",
      password: "123456"
      )
  end

  Genre.create(name: "ケーキ")
  Genre.create(name: "プリン")
  Genre.create(name: "焼き菓子")
  Genre.create(name: "キャンディ")

  32.times do |n|
    Item.create!(
      genre_id: 1,
      name: "商品#{n + 1}",
      description: "商品説明#{n + 1}",
      excluding_tax_price: rand(500..1500),
      image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/item#{n + 1}.jpeg")), filename: "item#{n + 1}.jpeg")
      )
  end

  Admin.create!(
    email: "admin@admin.com",
    password: "123456"
  )

  Customer.all.each do |customer|
    num_items = rand(1..5)
    item_ids = (1..32).to_a.sample(num_items)

    item_ids.each do |item_id|
      CartItem.create!(
        customer_id: customer.id,
        item_id: item_id,
        amount: rand(1..5)
      )
    end

    total_price = customer.cart_items.sum do |cart_item|
      cart_item.item.excluding_tax_price * cart_item.amount * 1.1
    end.round

    order = Order.create!(
      customer_id: customer.id,
      payment_method: rand(0..1),
      name: "DMM WEBCAMP(新宿校)",
      postal_code: "1600022",
      address: "東京都新宿区新宿２丁目５−１０ 成信ビル 4階",
      total: total_price
    )

    customer.cart_items.each do |cart_item|
      OrderDetail.create!(
        order_id: order.id,
        item_id: cart_item.item_id,
        amount: cart_item.amount,
        including_tax_price: cart_item.item.excluding_tax_price * 1.1,
        making_status: 0
      )
    end

    customer.cart_items.destroy_all
  end

