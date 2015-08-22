# == Schema Information
#
# Table name: category_articles # Связь категорий и публикаций
#
#  id          :integer          not null, primary key # Связь категорий и публикаций
#  category_id :integer          not null              # Внешний ключ для связи с категориями
#  article_id  :integer          not null              # Внешний ключ для связи с публикациями
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :category_article do
    category_id 1
article_id 1
  end

end
