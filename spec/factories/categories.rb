# == Schema Information
#
# Table name: categories # Категории
#
#  id         :integer          not null, primary key # Категории
#  name       :string           default(""), not null # Название
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :category do
    name "MyString"
  end

end
