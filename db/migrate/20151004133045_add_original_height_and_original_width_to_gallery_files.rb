class AddOriginalHeightAndOriginalWidthToGalleryFiles < ActiveRecord::Migration
  def change
    add_column :gallery_files, :original_height,  :integer, null: false, default: 0, after: :file_file_size,  comment: 'Высота оригинального изображения'
    add_column :gallery_files, :original_width,   :integer, null: false, default: 0, after: :original_height, comment: 'Ширина оригинального изображения'
  end
end
