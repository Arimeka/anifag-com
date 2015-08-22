class Backend::TagsController < BackendController
  def search
    respond_to do |format|
      format.json do
        model_class = params[:taggable].singularize.capitalize.safe_constantize
        if model_class
          render json: model_class
                        .tag_counts_on(:tags)
                        .where('name LIKE ?', "#{params[:q]}%")
                        .limit(10).map { |tag| {value: tag.name} }
        else
          render json: []
        end
      end
    end
  end
end
