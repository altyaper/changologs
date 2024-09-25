class SitesController < ApplicationController
  skip_before_action :authenticate_client_or_user!, only: :show

  def show
    logger.debug "Subdomain: #{request.subdomain}"  # Log the subdomain for debugging

    @subdomain = request.subdomain

    @site = Site.find_by(subdomain: @subdomain)

    authorize @site

    if @site
      @log = @site.log
      render :show
    else
      render plain: "Subdomain not found", status: 404
    end
  end
end