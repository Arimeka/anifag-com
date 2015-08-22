class Backend::ArticlesController < BackendController
  def index
    @articles = Article.order(published_at: :desc).page params[:page]
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      if params[:commit] == t('label.save_and_exit')
        redirect_to backend_articles_url
      else
        redirect_to edit_backend_article_url(@article)
      end
    else
      @errors = @article.errors.full_messages
      flash.now[:error] = @errors
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(article_params)
      if params[:commit] == t('label.save_and_exit')
        redirect_to backend_articles_url
      else
        redirect_to edit_backend_article_url(@article)
      end
    else
      @errors = @article.errors.full_messages
      flash.now[:error] = @errors
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to backend_articles_url
  end

  private

  def article_params
    params.require(:article).permit(:title,
                                    :content,
                                    :is_published,
                                    :is_video,
                                    :is_gallery,
                                    :source,
                                    :seo_slug,
                                    :seo_keywords,
                                    :seo_description,
                                    :published_at)
  end
end
