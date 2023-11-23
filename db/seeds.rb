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
    item = Item.create!(
      genre_id: 1,
      name: "商品名#{n + 1}",
      description: "商品説明#{n + 1}",
      excluding_tax_price: rand(500..1500)
    )
  end

  Admin.create!(
    email: "admin@admin.com",
    password: "123456"
  )
