class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
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
end
