class CreateCategoryArticles < ActiveRecord::Migration
  def change
    create_table :category_articles, comment: 'Связь категорий и публикаций' do |t|
      t.integer :category_id, null: false, comment: 'Внешний ключ для связи с категориями'
      t.integer :article_id,  null: false, comment: 'Внешний ключ для связи с публикациями'

      t.timestamps null: false
    end
  end
end
