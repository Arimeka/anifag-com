class AddEmbedVideoToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :embed_video, :string, null: false, default: '', after: :seo_description, comment: 'Код встраиваемого видео'
  end
end
