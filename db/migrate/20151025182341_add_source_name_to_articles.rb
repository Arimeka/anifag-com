class AddSourceNameToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :source_name, :string, null: false, default: '', comment: 'Название источника публикации'
  end
end
