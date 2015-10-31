class BannersController < ApplicationController
  layout false

  def show
    respond_to do |format|
      format.json do
        banner_position = BannerPlacement.find_by_selector(params[:selector])
        if banner_position
          banner = banner_position.banners.order('random()').first
          if banner
            render json: {content: banner.content}
          else
            render nothing: true
          end
        else
          render nothing: true
        end
      end
    end
  end
end
