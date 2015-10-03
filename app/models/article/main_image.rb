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

class Article::MainImage < MediaFile
  belongs_to :article, foreign_key: :attachable_id

  validates_attachment :file, content_type: { content_type: /\Aimage\/.*\Z/ },
                              size: { in: 0..4.megabytes }
end
