class ArticlesController < ApplicationController
  def index
    @articles = Article.posts.limit(30)
    @aside_videos = Article.videos.limit(4)
  end

  def index_page
    @articles = Article.posts.limit(30).offset(params[:page].to_i*30)
    @aside_videos = Article.videos.limit(4)
    render :index
  end

  def show
    @article = Article.find(params[:id])

    @same_articles = @article.same

    if @article.is_video?
      @aside_posts = Article.posts.limit(4)
    else
      @aside_videos = Article.videos.limit(4)
    end
  end
end
