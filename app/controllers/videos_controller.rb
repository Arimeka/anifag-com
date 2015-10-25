class VideosController < ApplicationController
   def index
    @articles = Article.videos.limit(10)
    @aside_posts = Article.posts.limit(4)
    @aside_galleries = Article.galleries.limit(4)
  end

  def index_page
    @articles = Article.videos.limit(10).offset(params[:page].to_i*10)
    @aside_posts = Article.posts.limit(4)
    @aside_galleries = Article.galleries.limit(4)
    render :index
  end
end
