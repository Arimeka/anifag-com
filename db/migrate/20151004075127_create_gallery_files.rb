class CreateGalleryFiles < ActiveRecord::Migration
  def change
    create_table :gallery_files, comment: 'Файлы галерей' do |t|
      t.string  :title,           null: false, default: '', comment: 'Название файла'
      t.string  :description,     null: false, default: '', comment: 'Описание файла'
      t.integer :placement_index, null: false, default: 0,  comment: 'Позиция в галерее'
      t.integer :article_id,      null: false,              comment: 'Связь со статьей, к которой крепятся файлы'

      t.timestamps null: false
    end

    add_attachment :gallery_files, :file
  end
end
