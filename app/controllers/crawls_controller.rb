require 'httparty'

class CrawlsController < ApplicationController

  def index
    @crawls = Crawl.where(user: current_user, saved: true)
  end

  def show
    @newcrawl = Crawl.new
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
    @response = HTTParty.get("https://api.mapbox.com/directions/v5/mapbox/walking/#{@crawl.start_longitude},#{@crawl.start_latitude};#{@crawl.end_longitude},#{@crawl.end_latitude}?geometries=geojson&access_token=#{ENV['MAPBOX_API_KEY']}")
    @waypoints = @response["routes"][0]["geometry"]["coordinates"]
    @waypoint_interval = @waypoints.length / @crawl.pub_number
    @key_waypoints = []

    x = @waypoint_interval
    while true do
      @key_waypoints << @waypoints[x - 1]
      x += @waypoint_interval
      break if x >= @waypoints.length
    end

    @client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    @key_waypoints_pubs = []
    @key_waypoints.each do |waypoint|
      radius = 0
      @pubs_for_given_waypoint = []
      while @pubs_for_given_waypoint == []
        radius += 100
        @pubs_for_given_waypoint << @client.spots(waypoint[1], waypoint[0], :types => 'pub', :name => 'pub', :radius => radius)
        if @pubs_for_given_waypoint != nil
          @key_waypoints_pubs << @pubs_for_given_waypoint.flatten.sample
        end
        @key_waypoints_pubs = @key_waypoints_pubs.reject(&:nil?).uniq { |pub| pub.name }
        # iteration only for the map
        @pub_markers = @key_waypoints_pubs.delete(nil)
        @pub_markers = @key_waypoints_pubs.map do |pub|
          {
            lng: pub.lng,
            lat: pub.lat,
            infoWindow: render_to_string(partial: "popup/infowindow", locals: { pub: pub })
          }
        end
        break if radius > 500
      end
    end
    @pub_lats = [[@crawl.start_longitude, @crawl.start_latitude]]
    @pub_markers.each { |marker| @pub_lats << [marker[:lng], marker[:lat]] }
    @pub_lats << [@crawl.end_longitude, @crawl.end_latitude]
    # @pubmarkers.each do |key,value|
    #   @pub_lats << [marker.lng, marker.lat]
    # end
    @partial = "https://api.mapbox.com/directions/v5/mapbox/walking/#{@crawl.start_longitude},#{@crawl.start_latitude};"
    @pub_lats.each { |array| @partial << "#{array[0]},#{array[1]};" }
    @partial << "#{@crawl.end_longitude},#{@crawl.end_latitude}?geometries=geojson&access_token=pk.eyJ1IjoibWF4bG9uZ2JhbyIsImEiOiJjanJ3YW51cGYwOXdhNDl0ZjFxMnNlZnJxIn0._euxNmvjQeQOpxXRNOiiqw"
    @new_response = HTTParty.get(@partial)
    @new_line_coords = @new_response["routes"][0]["geometry"]["coordinates"]
    @image_url = helpers.asset_url('beer.png')
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

  def save_for_later
    @crawl = Crawl.find(params[:id])
    @crawl.saved = true
    if @crawl.save
      redirect_to crawls_path
    else
      redirect_to crawl_path(@crawl)
    end
  end

  def pub_crawl_done
    @crawl = Crawl.find(params[:id])
    @crawl.completed = true
    if @crawl.save
      redirect_to crawls_path
    end
  end

  def destroy
    @crawl = Crawl.find(params[:id])
    @crawl.destroy
    redirect_to crawls_path
  end

  private

  def crawl_params
    params.require(:crawl).permit(:start_location, :end_location, :pub_number)
  end
end
