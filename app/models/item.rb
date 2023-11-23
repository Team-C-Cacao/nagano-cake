class Item < ApplicationRecord

  has_many :cart_items
  has_many :order_details
  belongs_to :genre


  has_one_attached :image

  # ビュー側でサイズ指定
  # イメージがないときにno_image.jpgの表示
  def get_item_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  def tax_included_price
    excluding_tax_price * 1.10
  end


end
