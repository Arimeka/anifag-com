class Backend::Content::ImagesController < BackendController
  def index
    respond_to do |format|
      format.json do
        render json: ::Content::Image.index_as_hash(params[:offset])
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        file = ::Content::Image.create(file: params[:file])
        if file.valid?
          render json: file.as_hash
        else
          render json: file.errors.full_messages
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        file = ::Content::Image.find(params[:id])

        if file.update_attributes(image_params)
          render json: file.as_hash
        else
          render json: file.errors.full_messages
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        file = ::Content::Image.find(params[:id])

        if file.destroy
          render json: file.as_hash
        else
          render json: file.errors.full_messages
        end
      end
    end
  end

  private

  def image_params
    params.require(:content_image).permit(:title, :description)
  end
end
