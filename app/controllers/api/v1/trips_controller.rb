class API::V1::TripsController < APIController
  before_action :set_trip, only: %i[ show edit update destroy ]
  before_action :authenticate_with_api_key!

  def new
    @trip = Trip.new
  end
  # POST /requests or /requests.json
  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      json render :show, status: :created, location: @trip
    else
      json render json: @trip.errors, status: :unprocessable_entity
    end

  end

  def show
    if params[:id] == "search"
      query = params[:query]
      all_trips = Trip.all
      @trips = Trip.where("description LIKE ? OR name LIKE ?", "%#{query}%", "%#{query}%")
      all_trips.each do |trip|
        posts_with = trip.posts.where("body LIKE ? OR title LIKE ?", "%#{query}%", "%#{query}%")
        @trips << trip if posts_with.present?
      end
      render json: @trips
    else
      @trip = Trip.find(params[:id])
      render json: @trip
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @trip.destroy
  end

  def index
    if params[:user_id]
      @trips = Trip.where('author == ?', params[:user_id])
    else
      @trips = Trip.all
    end
    render json: @trips
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trip_params
    params.fetch(:trip, {}).permit(:id, :name, :description, :start, :end, :author )
  end

  def update_params

    params.fetch(:trip, {}).permit(:id, :name, :description, :start, :end, :author )
  end



end
