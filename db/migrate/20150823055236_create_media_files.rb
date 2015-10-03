class CreateMediaFiles < ActiveRecord::Migration
  def change
    create_table :media_files, comment: 'Медиа-файлы' do |t|
      t.integer   :attachable_id,     null: false,              comment: 'Внешний ключ связанной модели'
      t.string    :class_name,        null: false, default: ''

      t.string    :file_file_name,    null: false, default: '', comment: 'Название файла'
      t.string    :file_content_type, null: false, default: '', comment: 'Тип файла'
      t.integer   :file_file_size,    null: false, default: 0,  comment: 'Размер файла'

      t.datetime  :file_updated_at,                             comment: 'Дата загрузки файла'

      t.timestamps null: false
    end
  end
end
