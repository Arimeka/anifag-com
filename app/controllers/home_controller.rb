class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @article_main_big = Article.main_big
        exclude_ids = [@article_main_big.try(:id).to_i]

        @articles_other = Article.feed(exclude_ids)
        exclude_ids += collect_ids(@articles_other)

        @aside_videos = Article.videos(exclude_ids).limit(4)
        @aside_galleries = Article.galleries(exclude_ids).limit(4)
      end

      format.json do
        article_main_big = Article.main_big
        exclude_ids = [article_main_big.try(:id).to_i]
        render json: Article.feed_hash(params[:offset], exclude_ids)
      end
    end

  end
end
