require 'httparty'

class CrawlsController < ApplicationController
  def show
    @crawl = Crawl.find(params[:id])
    if @crawl.user != current_user
      redirect_to root_path, notice: "Not your crawl!"
    end


    # @client.spots(@crawl.start_latitude, @crawl.start_longitude, :types => 'pub', :radius => 300).each do |pub|
    #   @marker << { lat: pub.lat, lng: pub.lng }
    # end

    @markers = [
      { lat: @crawl.start_latitude, lng: @crawl.start_longitude },
      { lat: @crawl.end_latitude, lng: @crawl.end_longitude }
    ]
    @response = HTTParty.get("https://api.mapbox.com/directions/v5/mapbox/walking/#{@crawl.start_longitude},#{@crawl.start_latitude};#{@crawl.end_longitude},#{@crawl.end_latitude}?geometries=geojson&access_token=pk.eyJ1IjoibWF4bG9uZ2JhbyIsImEiOiJjanJ3YW51cGYwOXdhNDl0ZjFxMnNlZnJxIn0._euxNmvjQeQOpxXRNOiiqw")
    @waypoints = @response["routes"][0]["geometry"]["coordinates"]
    @waypoint_interval = @waypoints.length / @crawl.pub_number
    @key_waypoints = []

    x = @waypoint_interval
    while true do
      @key_waypoints << @waypoints[x - 1]
      x += @waypoint_interval
      break if x > @waypoints.length
    end

    @client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    @key_waypoints_pubs = []
    @key_waypoints.each do |waypoint|
      radius = 0
      @pubs_for_given_waypoint = []
      while @pubs_for_given_waypoint == []
        radius += 100
        @pubs_for_given_waypoint << @client.spots(waypoint[1], waypoint[0], :types => 'pub', :name => 'pub', :radius => radius)
        break if radius > 1000
      end
      @key_waypoints_pubs << @pubs_for_given_waypoint.flatten.sample
      # if @key_waypoints_pubs.include?(nil)
      #   @key_waypoints_pubs == [nil]
      # else
      @pub_markers = @key_waypoints_pubs.map do |pub|
        if pub.lng && pub.lat
          {
            lng: pub.lng,
            lat: pub.lat,
            infoWindow: render_to_string(partial: "popup/infowindow", locals: { pub: pub })
          }
        end
      end
      @image_url = helpers.asset_url('beer.png')
    end
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
