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
      expire_cache(@article)
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
      expire_cache(@article)
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
    expire_cache(@article)
  end

  private

  def prepare_post
    @categories = Category.all.map {|c| [c.name, c.id]}
    @article.build_main_image if @article.main_image.blank?
    @images = ::Content::Image.order('created_at DESC').limit(10)
  end

  def article_params
    params.require(:article).permit(:title,
                                    :content,
                                    :is_published,
                                    :is_big,
                                    :source,
                                    :source_name,
                                    :seo_slug,
                                    :seo_keywords,
                                    :seo_description,
                                    :published_at,
                                    :tag_list,
                                    :category_id,
                                    category_ids: [],
                                    main_image_attributes: [:id, :file, :_destroy])
  end

  def expire_cache(article)
    key = fragment_cache_key("#{article.id}")
    cache_store.delete_matched("#{key}*")

    key = fragment_cache_key('aside_post_block')
    cache_store.delete_matched("#{key}*")

    key = fragment_cache_key(controller: '/home', action: 'index', action_suffix: 'article_feed')
    cache_store.delete_matched("#{key}*")

    key = fragment_cache_key(controller: '/home', action: 'index', action_suffix: 'all')
    cache_store.delete_matched("#{key}*")

    key = fragment_cache_key(controller: '/articles', action: 'index')
    cache_store.delete_matched("#{key}*")

     key = fragment_cache_key(controller: '/galleries', action: 'index')
    cache_store.delete_matched("#{key}*")

     key = fragment_cache_key(controller: '/videos', action: 'index')
    cache_store.delete_matched("#{key}*")

    key = fragment_cache_key(controller: '/articles', action: 'index_page', page: '')
    cache_store.delete_matched("#{key}*")
  end
end
