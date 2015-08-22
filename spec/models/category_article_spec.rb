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

require 'rails_helper'

RSpec.describe CategoryArticle, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
