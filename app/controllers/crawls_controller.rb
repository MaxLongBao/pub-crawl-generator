class CrawlsController < ApplicationController
  def show
    @crawl = Crawl.find(crawl_params)
  end

  def new
    @crawl = Crawl.new
  end

  def create
    Crawl.new(crawl_params)
    if @crawl.save
      redirect_to crawl_path
    else
      render :new
    end
  end

  private

  def crawl_params
    params.require(:crawl).permit(:start_location, :end_location, :pub_number)
  end
end
