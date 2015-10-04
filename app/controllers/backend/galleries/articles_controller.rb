class Backend::Galleries::ArticlesController < BackendController
  def index
    @articles = Article.gallery.order(published_at: :desc).page params[:page]
  end

  def new
    @article = Article.new(published_at: Time.current, is_gallery: true)
    @article.save(validate: false)
    redirect_to edit_backend_galleries_article_url(@article)
  end

  def edit
    @article = Article.gallery.find(params[:id])
    prepare_post
  end

  def update
    @article = Article.gallery.find(params[:id])
    @article.is_video = true

    if @article.update_attributes(article_params)
      if params[:commit] == t('form.save_and_exit')
        redirect_to backend_galleries_articles_url
      else
        redirect_to edit_backend_galleries_article_url(@article)
      end
    else
      @errors = @article.errors.full_messages
      prepare_post
      flash.now[:error] = @errors
      render :edit
    end
  end

  def destroy
    @article = Article.gallery.find(params[:id])
    @article.destroy
    redirect_to backend_galleries_articles_url
  end

  def upload
    file = GalleryFile.create(file: params[:file], article_id: params[:id])
    respond_to do |format|
      format.json do
        if file.valid?
          render json: {id: file.id, image: file.url('378x249'), rand: SecureRandom.random_number(1000000)}
        else
          render json: file.errors.full_messages
        end
      end
    end
  end

  def sort
    GalleryFile.where(article_id: params[:id]).update(params[:map].keys, params[:map].values)
    respond_to do |format|
      format.json { render nothing: true }
    end
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
                                    :is_video,
                                    :is_gallery,
                                    :source,
                                    :seo_slug,
                                    :seo_keywords,
                                    :seo_description,
                                    :embed_video,
                                    :published_at,
                                    :tag_list,
                                    :category_id,
                                    category_ids: [],
                                    main_image_attributes: [:id, :file, :_destroy],
                                    gallery_files_attributes: [:id, :_destroy, :title, :description])
  end
end
