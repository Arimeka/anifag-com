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
#  original_height   :integer          default(0), not null  # Высота оригинального изображения
#  original_width    :integer          default(0), not null  # Ширина оригинального изображения
#

require 'rails_helper'

RSpec.describe GalleryFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
