class API::V1::DestinationsController < APIController
  before_action :set_destination, only: [:show, :update, :destroy]
  before_action :authenticate_with_api_key!

  def new
    @destination = Destination.new
  end

  def create
    @destination = Destination.new(destination_params)


    if @destination.save
      render json: @destination
    else
      render json: @destination.errors, status: :unprocessable_entity
    end

  end

  def destroy
    if params[:post_id]
      DestinationsPost.where(post_id: params[:post_id], destination_id: @destination.id).delete_all
    else
      @destination.destroy
    end
  end

  def show
    @destination = Destination.find(params[:id])
    render json: @destination
  end

  #Solo para chequear que anidación funciona
  def index
    if params[:post_id]
      @post = Post.find(params[:post_id])
      @destinations = @post.destinations
    else
      @destinations = Destination.all
    end
    render json: @destinations
  end

  def update
    if @destination.update(destination_params)
      render json: @destination
    else
      render json: @destination.errors, status: :unprocessable_entity
    end

  end

  # Use callbacks to share common setup or constraints between actions.
  private
  def set_destination
    @destination = Destination.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def destination_params
    params.fetch(:destination, {}).permit(:country, :city, :latitude, :longitude, :name, :post_id)
  end

  def update_params
    params.fetch(:destination, {}).permit(:id, :country, :city, :latitude, :longitude, :name, :post_id)
  end
end
