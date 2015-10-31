class CreateBannerPlacementBanners < ActiveRecord::Migration
  def change
    create_table :banner_placement_banners, comment: 'Связующая таблица баннеров и плейсментов' do |t|
      t.integer :banner_id,           null: false, comment: 'Внешний ключ для связи с баннером'
      t.integer :banner_placement_id, null: false, comment: 'Внешний ключ для связи с плейсментом'

      t.timestamps null: false
    end
  end
end
