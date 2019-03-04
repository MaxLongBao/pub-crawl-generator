class CrawlsController < ApplicationController
  def show
    @crawl = Crawl.find(crawl_params)
  end

  def new
    @crawl = Crawl.new
  end

  def create
    Crawl.create(crawl_params)
    redirect_to crawl_path
  end


  private

  def crawl_params
    params.require(:crawl).permit(:start_location, :end_location, :pub_number)
  end
end
