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
#

class Article < ActiveRecord::Base
  # Validations
  # ==================================================================================
  validates :title, :content, :published_at, presence: true
  # ==================================================================================
  # Validations

  # Scopes
  # ==================================================================================
  scope :published, -> { where(is_published: true).where('published_at <= ?', Time.zone.now) }

  scope :tops, -> (exclude_ids = [0]) {
                      published
                      .where('id NOT IN (?)', exclude_ids)
                      .order(published_at: :desc)
                      .limit(4)
                    }

  scope :others, -> (exclude_ids = [0]) {
                          published
                          .where('id NOT IN (?)', exclude_ids)
                          .order(published_at: :desc)
                          .limit(9)
                        }
  # ==================================================================================
  # Scopes

  # Class methods
  # ==================================================================================
  class << self
    def main_big
      self.published.order(published_at: :desc).first
    end
  end
  # ==================================================================================
  # Class methods
end
