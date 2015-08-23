class VideosController < ApplicationController
   def index
    @articles = Article.videos.limit(30)
    @aside_posts = Article.posts.limit(4)
  end

  def index_page
    @articles = Article.videos.limit(30).offset(params[:page].to_i*30)
    @aside_posts = Article.posts.limit(4)
    render :index
  end
end
