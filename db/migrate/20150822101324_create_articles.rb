class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles, comment: 'Публикации' do |t|
      t.string    :title,           null: false, default: '',     comment: 'Заголовок'
      t.text      :content,                                       comment: 'Содержимое'
      t.integer   :category_id,                                   comment: 'Связь с категорией'
      t.boolean   :is_published,    null: false, default: false,  comment: 'Опубликовано'
      t.boolean   :is_video,        null: false, default: false,  comment: 'Основа контента - видео'
      t.boolean   :is_gallery,      null: false, default: false,  comment: 'Основа контента - галерея'

      t.string    :source,          null: false, default: '',     comment: 'Источник публикации'

      t.string    :seo_slug,        null: false, default: '',     comment: 'Канонический урл'
      t.string    :seo_keywords,    null: false, default: '',     comment: 'Ключевые слова'
      t.string    :seo_description, null: false, default: '',     comment: 'SEO-описание'

      t.datetime  :published_at,    null: false,                  comment: 'Дата публикации'

      t.timestamps null: false
    end
  end
end
