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

class Article < ActiveRecord::Base
  acts_as_taggable

  # Validations
  # ==================================================================================
  validates :title, :content, :seo_description, :published_at, presence: true
  validates :title, :seo_description, :source,
              :source_name, :seo_keywords, :embed_video,
              :seo_slug, length: { maximum: 225 }
  # ==================================================================================
  # Validations

  # Scopes
  # ==================================================================================
  scope :published, -> { where(is_published: true).where('published_at <= ?', Time.zone.now) }

  scope :gallery, -> { includes(:main_image, gallery_files: :article).where(is_gallery: true) }
  scope :video,   -> { includes(:main_image).where(is_video: true) }
  scope :post,    -> { includes(:main_image).where(is_gallery: false, is_video: false) }

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
                          .limit(10)
                        }

  scope :feed,      -> (exclude_ids = [0]) { includes(:main_image).others(exclude_ids) }
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
  around_create :fix_create_article_with_category_articles

  before_save :set_seo_keywords, if: 'seo_keywords.blank?'
  # ==================================================================================
  # Callbacks

  # Class methods
  # ==================================================================================
  class << self
    def feed_hash(offset = 0, exclude_ids = [0])
      self.feed(exclude_ids).offset(offset.to_i).limit(10).map(&:as_hash)
    end
  end
  # ==================================================================================
  # Class methods

  # Instance methods
  # ==================================================================================
  def as_hash
    {
      id: id,
      param: to_param,
      title: title,
      description: seo_description,
      published_at: published_at.strftime("%d-%m-%Y %H:%M"),
      published_at_iso: published_at.to_formatted_s(:iso8601),
      image: main_image.present? ? main_image.url('320x380') : nil,
      image_share: main_image.present? ? main_image.url('640x430') : nil
    }
  end

  def to_param
    if seo_slug.present?
      "#{id}-#{seo_slug}"
    else
      super
    end
  end

  def same
    Article.published
            .includes(:main_image)
            .where('id NOT IN (?)', id)
            .tagged_with(self.tag_list, on: :tags, any: true)
            .limit(6)
  end

  def gallery_json
    data = []
    self.gallery_files.each do |file|
      data << {
                src: file.url,
                w: file.original_width,
                h: file.original_height,
                title: file.description
              }
    end
    data.to_json
  end
  # ==================================================================================
  # Instance methods

  # Private methods
  # ==================================================================================
  private

  def set_seo_keywords
    seo_keywords = self.tag_list
  end

  # FIXME Remove when https://github.com/rails/rails/issues/21096 will be fixed
  def fix_create_article_with_category_articles
    cats = category_articles.to_a
    category_articles.clear
    return false unless yield
    self.category_articles = cats
    save
  end

  # ==================================================================================
  # Private methods
end
