class GalleriesController < ApplicationController
  def index
    @articles = Article.galleries.limit(30)
    @aside_posts = Article.posts.limit(4)
    @aside_videos = Article.videos.limit(4)
  end

  def index_page
    @articles = Article.galleries.limit(30).offset(params[:page].to_i*30)
    @aside_posts = Article.posts.limit(4)
    @aside_videos = Article.videos.limit(4)
    render :index
  end
end
