# == Schema Information
#
# Table name: banners # Рекламные баннеры
#
#  id         :integer          not null, primary key # Рекламные баннеры
#  title      :string           default(""), not null # Название баннера
#  content    :string(1000)     default(""), not null # Содержимое баннера
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Banner < ActiveRecord::Base
  # Relations
  # ==================================================================================
  has_many :banner_placement_banners, dependent: :destroy
  has_many :banner_placements, through: :banner_placement_banners
  # ==================================================================================
  # Relations

  # Validations
  # ==================================================================================
  validates :title, :content, presence: true
  validates :title, length: { minimum: 1, maximum: 225 }
  validates :content, length: { minimum: 1, maximum: 1000 }

  # ==================================================================================
  # Validations

  # Callbacks
  # ==================================================================================
  around_create :fix_create_banner_with_placements
  # ==================================================================================
  # Callbacks

  private

  # FIXME Remove when https://github.com/rails/rails/issues/21096 will be fixed
  def fix_create_banner_with_placements
    pls = banner_placement_banners.to_a
    banner_placement_banners.clear
    return false unless yield
    self.banner_placement_banners = pls
    save
  end
end
