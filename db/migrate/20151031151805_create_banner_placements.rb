class CreateBannerPlacements < ActiveRecord::Migration
  def change
    create_table :banner_placements, comment: 'Места расположения баннеров' do |t|
      t.string :title,    null: false, default: '', comment: 'Название расположения'
      t.string :selector, null: false, default: '', comment: 'Селектор расположения в коде страницы'

      t.timestamps null: false
    end
  end
end
