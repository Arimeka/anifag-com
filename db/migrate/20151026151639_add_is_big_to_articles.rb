class AddIsBigToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_big, :boolean, null: false, default: false, comment: 'Большой блок'
  end
end
