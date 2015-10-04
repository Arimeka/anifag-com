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
#

class Article < ActiveRecord::Base
  acts_as_taggable

  # Validations
  # ==================================================================================
  validates :title, :content, :published_at, presence: true
  # ==================================================================================
  # Validations

  # Scopes
  # ==================================================================================
  scope :published, -> { where(is_published: true).where('published_at <= ?', Time.zone.now) }

  scope :gallery, -> { includes(gallery_files: :article).where(is_gallery: true) }
  scope :video,   -> { where(is_video: true) }
  scope :post,    -> { where(is_gallery: false, is_video: false) }

  scope :tops, -> (exclude_ids = [0]) {
                      published
                      .post
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

  scope :posts,     -> (exclude_ids = [0]) { post.others(exclude_ids) }
  scope :videos,    -> (exclude_ids = [0]) { video.others(exclude_ids) }
  scope :galleries, -> (exclude_ids = [0]) { gallery.others(exclude_ids) }
  # ==================================================================================
  # Scopes

  # Relations
  # ==================================================================================
  belongs_to :category
  has_many :categories, through: :category_articles
  has_many :category_articles, dependent: :destroy

  has_one :main_image, foreign_key: :attachable_id, class_name: "#{self}::MainImage", dependent: :destroy
  accepts_nested_attributes_for :main_image, allow_destroy: true

  has_many :gallery_files, dependent: :destroy, inverse_of: :article
  accepts_nested_attributes_for :gallery_files, allow_destroy: true

  # ==================================================================================
  # Relations

  # Callbacks
  # ==================================================================================
  before_save :set_seo_keywords, if: 'seo_keywords.blank?'
  # ==================================================================================
  # Callbacks

  # Class methods
  # ==================================================================================
  class << self
    def main_big
      self.published.post.order(published_at: :desc).first
    end
  end
  # ==================================================================================
  # Class methods

  # Instance methods
  # ==================================================================================
  def to_param
    if seo_slug.present?
      "#{id}-#{seo_slug}"
    else
      super
    end
  end

  def same
    Article.published
            .where('id NOT IN (?)', id)
            .tagged_with(self.tag_list, on: :tags, any: true)
            .limit(6)
  end
  # ==================================================================================
  # Instance methods

  # Private methods
  # ==================================================================================
  private

  def set_seo_keywords
    seo_keywords = self.tag_list
  end
  # ==================================================================================
  # Private methods
end
