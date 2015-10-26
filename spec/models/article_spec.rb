# == Schema Information
#
# Table name: articles # Публикации
#
#  id              :integer          not null, primary key    # Публикации
#  title           :string           default(""), not null    # Заголовок
#  content         :text                                      # Содержимое
#  category_id     :integer                                   # Связь с категорией
#  is_published    :boolean          default(FALSE), not null # Опубликовано
#  is_video        :boolean          default(FALSE), not null # Основа контента - видео
#  is_gallery      :boolean          default(FALSE), not null # Основа контента - галерея
#  source          :string           default(""), not null    # Источник публикации
#  seo_slug        :string           default(""), not null    # Канонический урл
#  seo_keywords    :string           default(""), not null    # Ключевые слова
#  seo_description :string           default(""), not null    # SEO-описание
#  published_at    :datetime         not null                 # Дата публикации
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  embed_video     :string           default(""), not null    # Код встраиваемого видео
#  source_name     :string           default(""), not null    # Название источника публикации
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
