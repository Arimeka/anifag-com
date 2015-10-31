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

FactoryGirl.define do
  factory :banner do
    title "MyString"
content "MyString"
  end

end
