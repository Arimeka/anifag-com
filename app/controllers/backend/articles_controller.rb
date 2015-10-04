class Backend::ArticlesController < BackendController
  def index
    @articles = Article.post.order(published_at: :desc).page params[:page]
  end

  def new
    @article = Article.new
    prepare_post
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      if params[:commit] == t('form.save_and_exit')
        redirect_to backend_articles_url
      else
        redirect_to edit_backend_article_url(@article)
      end
    else
      @errors = @article.errors.full_messages
      prepare_post
      flash.now[:error] = @errors
      render :new
    end
  end

  def edit
    @article = Article.post.find(params[:id])
    prepare_post
  end

  def update
    @article = Article.post.find(params[:id])

    if @article.update_attributes(article_params)
      if params[:commit] == t('form.save_and_exit')
        redirect_to backend_articles_url
      else
        redirect_to edit_backend_article_url(@article)
      end
    else
      @errors = @article.errors.full_messages
      prepare_post
      flash.now[:error] = @errors
      render :edit
    end
  end

  def destroy
    @article = Article.post.find(params[:id])
    @article.destroy
    redirect_to backend_articles_url
  end

  private

  def prepare_post
    @categories = Category.all.map {|c| [c.name, c.id]}
    @article.build_main_image if @article.main_image.blank?
  end

  def article_params
    params.require(:article).permit(:title,
                                    :content,
                                    :is_published,
                                    :source,
                                    :seo_slug,
                                    :seo_keywords,
                                    :seo_description,
                                    :published_at,
                                    :tag_list,
                                    :category_id,
                                    category_ids: [],
                                    main_image_attributes: [:id, :file, :_destroy])
  end
end
