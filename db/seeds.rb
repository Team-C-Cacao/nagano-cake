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

  10.times do |n|
    Item.create!(
      genre_id: 1,
      name: "商品#{n + 1}",
      description: "商品説明#{n + 1}",
      excluding_tax_price: 2000
      )
  end

  Admin.create!(
    email: "admin@admin.com",
    password: "123456"
  )
