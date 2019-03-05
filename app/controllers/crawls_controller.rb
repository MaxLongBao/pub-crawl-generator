class CrawlsController < ApplicationController
  def show
    @crawl = Crawl.find(params[:id])
    if @crawl.user != current_user
      redirect_to root_path, notice: "Not your crawl!"
    end
    @markers = [
      { lat: @crawl.start_latitude, lng: @crawl.start_longitude },
      { lat: @crawl.end_latitude, lng: @crawl.end_longitude }
    ]
  end

  def create
    @crawl = Crawl.new(crawl_params)
    @crawl.pub_number = @crawl.pub_number.to_i
    @crawl.user = current_user
    if @crawl.save
      redirect_to crawl_path(@crawl)
    else
      render template: 'pages/home'
    end
  end

  private

  def crawl_params
    params.require(:crawl).permit(:start_location, :end_location, :pub_number)
  end
end
