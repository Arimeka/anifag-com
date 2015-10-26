class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @articles_other = Article.feed
        exclude_ids = collect_ids(@articles_other)

        @aside_videos = Article.videos(exclude_ids).limit(4)
        @aside_galleries = Article.galleries(exclude_ids).limit(4)
      end

      format.json do
        render json: Article.feed_hash(params[:offset])
      end
    end

  end
end
