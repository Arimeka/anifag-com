# == Schema Information
#
# Table name: banner_placement_banners # Связующая таблица баннеров и плейсментов
#
#  id                  :integer          not null, primary key # Связующая таблица баннеров и плейсментов
#  banner_id           :integer          not null              # Внешний ключ для связи с баннером
#  banner_placement_id :integer          not null              # Внешний ключ для связи с плейсментом
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class BannerPlacementBanner < ActiveRecord::Base
  belongs_to :banner
  belongs_to :banner_placement
end
