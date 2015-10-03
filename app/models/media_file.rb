# == Schema Information
#
# Table name: media_files # Медиа-файлы
#
#  id                :integer          not null, primary key # Медиа-файлы
#  attachable_id     :integer          not null              # Внешний ключ связанной модели
#  class_name        :string           default(""), not null
#  file_file_name    :string           default(""), not null # Название файла
#  file_content_type :string           default(""), not null # Тип файла
#  file_file_size    :integer          default(0), not null  # Размер файла
#  file_updated_at   :datetime                               # Дата загрузки файла
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MediaFile < ActiveRecord::Base
  self.inheritance_column = :class_name

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
