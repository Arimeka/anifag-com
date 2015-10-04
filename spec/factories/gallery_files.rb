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

FactoryGirl.define do
  factory :gallery_file do
    title "MyString"
description "MyString"
placement_index 1
  end

end
