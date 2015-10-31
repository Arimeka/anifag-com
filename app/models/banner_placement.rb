# == Schema Information
#
# Table name: banner_placements # Места расположения баннеров
#
#  id         :integer          not null, primary key # Места расположения баннеров
#  title      :string           default(""), not null # Название расположения
#  selector   :string           default(""), not null # Селектор расположения в коде страницы
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BannerPlacement < ActiveRecord::Base
  # Relations
  # ==================================================================================
  has_many :banner_placement_banners, dependent: :destroy
  has_many :banners, through: :banner_placement_banners
  # ==================================================================================
  # Relations

  # Validations
  # ==================================================================================
  validates :title, :selector, presence: true, length: { minimum: 1, maximum: 225 }
  validates :selector, uniqueness: true
  # ==================================================================================
  # Validations
end
