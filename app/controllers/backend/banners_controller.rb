class Backend::BannersController < BackendController
  def index
    @banners = Banner.includes(:banner_placements).limit(15).order(created_at: :desc).page params[:page]
  end

  def new
    @banner = Banner.new
    prepare_post
  end

  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      if params[:commit] == t('form.save_and_exit')
        redirect_to backend_banners_url
      else
        redirect_to edit_backend_banner_url(@banner)
      end
    else
      @errors = @banner.errors.full_messages
      prepare_post
      flash.now[:error] = @errors
      render :new
    end
  end

  def edit
    @banner = Banner.includes(:banner_placements).find(params[:id])
    prepare_post
  end

  def update
    @banner = Banner.find(params[:id])

    if @banner.update_attributes(banner_params)
      if params[:commit] == t('form.save_and_exit')
        redirect_to backend_banners_url
      else
        redirect_to edit_backend_banner_url(@banner)
      end
    else
      @errors = @banner.errors.full_messages
      prepare_post
      flash.now[:error] = @errors
      render :edit
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy
    redirect_to backend_banners_url
  end

  private

  def prepare_post
    @placements = BannerPlacement.all
  end

  def banner_params
    params.require(:banner).permit(:title,
                                    :content,
                                    banner_placement_ids: [])
  end
end
