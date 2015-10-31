class RssController < ApplicationController
  layout false

  def feed
    respond_to do |format|
      format.xml do
        @posts = Article.feed.limit(30)
      end
    end
  end
end
