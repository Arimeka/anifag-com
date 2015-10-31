class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners, comment: 'Рекламные баннеры' do |t|
      t.string :title,    null: false, default: '',               comment: 'Название баннера'
      t.string :content,  null: false, default: '', limit: 1000,  comment: 'Содержимое баннера'

      t.timestamps null: false
    end
  end
end
