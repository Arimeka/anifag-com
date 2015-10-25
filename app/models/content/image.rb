# == Schema Information
#
# Table name: content_images
#
#  id                :integer          not null, primary key
#  title             :string           default(""), not null # Название файла
#  description       :string           default(""), not null # Описание файла
#  original_height   :integer          default(0), not null  # Высота оригинального изображения
#  original_width    :integer          default(0), not null  # Ширина оригинального изображения
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class Content::Image < ActiveRecord::Base
  has_attached_file :file,
                    storage:        :s3,
                    s3_credentials: "#{Rails.root}/config/s3.yml",
                    s3_permissions: :private,
                    default_url:    '/assets/missing/:class/:style.jpg',
                    path:           ':class/:id_partition/:basename.:extension',
                    url:            ":s3_custom_url",
                    s3_custom_host: Rails.configuration.s3['host'],
                    s3_protocol:    'http',
                    use_timestamp:  false

  delegate :url, to: :file
  delegate :path, to: :file

  before_post_process :randomize_file_name
  before_save :extract_dimensions

  # Validations
  # ==================================================================================
  validates_attachment :file, content_type: { content_type: /\Aimage\/.*\Z/ },
                              size: { in: 0..4.megabytes }
  # ==================================================================================
  # Validations

  # Class methods
  # ==================================================================================

  def self.index_as_hash(offset, limit = 10)
    images = self.order('created_at DESC').offset(offset.to_i).limit(limit.to_i)
    images.map(&:as_hash)
  end

  # ==================================================================================
  # Class methods

  # Instance methods
  # ==================================================================================

  def as_hash
    {
      id: id,
      title: title,
      description: description,
      image: url('250x250'),
      url: url('560x')
    }
  end

  # ==================================================================================
  # Instance methods


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

  def extract_dimensions
    tempfile = file.queued_for_write[:original]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.original_width = geometry.width.to_i
      self.original_height = geometry.height.to_i
    end
  end

  # ==================================================================================
  # Private methods
end
