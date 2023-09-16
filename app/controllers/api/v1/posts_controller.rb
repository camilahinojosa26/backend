class API::V1::PostsController < APIController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_with_api_key!


  def new
    @post = Post.new
  end

  def create
    @post = Post.new()
    author = User.find_by(email: params[:author])
    @post.author = author
    trip = Trip.find(params[:trip_id])
    @post.trip = trip
    @post.title = params[:title]
    @post.body = params[:body]

    if @post.save
      DestinationsPost.create(post_id: @post.id, destination_id: params[:destinations][0])
      DestinationsPost.create(post_id: @post.id, destination_id: params[:destinations][1])
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy
  end

  def index
    @posts = Post.where(trip_id: params[:trip_id])
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def update
    if @post.update(post_params)
      render :show, status: :ok, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end

  end


  private

  def set_post
    @post = Post.find(params[:id])
  end
  # Only allow a list of trusted parameters through.
  # #TODO: More params like users, destinations, photos, etc.
  def post_params
    params.fetch(:post, {}).permit(:id, :trip_id, :title, :body, :author, :public, :files, destinations: [:id1, :id2])
  end

  def update_params
    params.fetch(:post, {}).permit(:id, :trip_id, :title, :description, :author, :public, :files, destinations: [:id1, :id2])
  end



end
