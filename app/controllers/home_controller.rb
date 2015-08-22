class HomeController < ApplicationController
  def index
    @article_main_big = Article.main_big
    exclude_ids = [@article_main_big.try(:id).to_i]
    @articles_top = Article.tops(exclude_ids)
    exclude_ids += collect_ids(@articles_top)
    @articles_other = Article.others(exclude_ids)
  end
end
