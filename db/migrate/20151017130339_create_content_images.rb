class CreateContentImages < ActiveRecord::Migration
  def change
    create_table :content_images do |t|
      t.string :title,           null: false, default: '', comment: 'Название файла'
      t.string :description,     null: false, default: '', comment: 'Описание файла'

      t.integer :original_height, null: false, default: 0,  comment: 'Высота оригинального изображения'
      t.integer :original_width,  null: false, default: 0,  comment: 'Ширина оригинального изображения'

      t.timestamps null: false
    end

    add_attachment :content_images, :file
  end
end
