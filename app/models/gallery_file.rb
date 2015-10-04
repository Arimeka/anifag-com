# == Schema Information
#
# Table name: gallery_files # Файлы галерей
#
#  id                :integer          not null, primary key # Файлы галерей
#  title             :string           default(""), not null # Название файла
#  description       :string           default(""), not null # Описание файла
#  placement_index   :integer          default(0), not null  # Позиция в галерее
#  article_id        :integer          not null              # Связь со статьей, к которой крепятся файлы
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class GalleryFile < ActiveRecord::Base

  has_attached_file :file,
                    storage:        :s3,
                    s3_credentials: "#{Rails.root}/config/s3.yml",
                    s3_permissions: :private,
                    default_url:    '/assets/missing/:class/:style.jpg',
                    path:           'galleries/:gallery_id_partition/:basename.:extension',
                    url:            ":s3_custom_url",
                    s3_custom_host: Rails.configuration.s3['host'],
                    s3_protocol:    'http',
                    use_timestamp:  false

  delegate :url, to: :file
  delegate :path, to: :file

  before_post_process :randomize_file_name

  # Validations
  # ==================================================================================
  validates :article_id, :placement_index, presence: true
  validates_attachment :file, content_type: { content_type: /\Aimage\/.*\Z/ },
                              size: { in: 0..4.megabytes }
  # ==================================================================================
  # Validations

  # Relations
  # ==================================================================================
  belongs_to :article
  # ==================================================================================
  # Relations

  # Scopes
  # ==================================================================================
  default_scope { order('gallery_files.placement_index ASC, gallery_files.id ASC') }
  # ==================================================================================
  # Scopes

  # Private methods
  # ==================================================================================
  private

  def randomize_file_name
    return if file_file_name.nil?
    if file_file_name_changed?
      extension = File.extname(file_file_name).downcase
      self.file.instance_write(:file_name, "#{SecureRandom.hex}#{extension}")
    end
  end
  # ==================================================================================
  # Private methods
end
