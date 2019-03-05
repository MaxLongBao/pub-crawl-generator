class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @ben = Crawl.new
  end
end
