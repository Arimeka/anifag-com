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

FactoryGirl.define do
  factory :banner_placement do
    title "MyString"
selector "MyString"
  end

end
