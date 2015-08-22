class ArticlesController < ApplicationController
  def index
    @articles = Article.others.limit(30)
  end

  def index_page
    @articles = Article.others.limit(30).offset(params[:page].to_i*30)
    render :index
  end

  def show
    @article = Article.find(params[:id])
  end
end
