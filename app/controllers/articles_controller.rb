class ArticlesController < ApplicationController
  def index
    @articles = Article.posts.limit(10)
    @aside_videos = Article.videos.limit(4)
    @aside_galleries = Article.galleries.limit(4)
  end

  def index_page
    @articles = Article.posts.limit(10).offset(params[:page].to_i*10)
    @aside_videos = Article.videos.limit(4)
    @aside_galleries = Article.galleries.limit(4)
    render :index
  end

  def show
    @article = Article.find(params[:id])

    @same_articles = @article.same

    if @article.is_video?
      @aside_posts = Article.posts.limit(2)
      @aside_galleries = Article.galleries.limit(2)
    elsif @article.is_gallery?
      @aside_posts = Article.posts.limit(2)
      @aside_videos = Article.videos.limit(2)
    else
      @aside_videos = Article.videos.limit(2)
      @aside_galleries = Article.galleries.limit(2)
    end
  end
end
