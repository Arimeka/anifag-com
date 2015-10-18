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

FactoryGirl.define do
  factory :content_image, :class => 'Content::Image' do
    title "MyString"
description "MyString"
  end

end
