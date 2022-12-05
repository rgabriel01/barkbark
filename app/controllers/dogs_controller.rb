class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :post_like]
  before_action :check_owner, only: [:edit, :update, :destroy]

  MAX_ITEMS_PER_PAGE = 5

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog
      .includes(:likes)
      .order('likes.created_at desc')
      .page(current_page)
      .per(MAX_ITEMS_PER_PAGE)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params.to_h.merge({ owner_id: current_user.id }))

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  def post_like
    if current_user_the_owner?
      redirect_to root_path
      return
    end

    like = Like.new(dog_id: @dog.id, user_id: current_user.id)
    respond_to do |format|
      if like.save
        format.html { redirect_to @dog, notice: 'Dog was liked successfully!' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images)
  end

  def current_page
    @current_page ||= pagination_params[:page].nil? ? 1 : pagination_params[:page]
  end

  # introduced params used for pagination
  def pagination_params
    params.permit(:page)
  end

  def post_like_params
    params.permit(:dog_id)
  end

  def current_user_the_owner?
    @current_user_the_owner ||= current_user.id == @dog.owner_id
  end

  def check_owner
    if !current_user_the_owner?
      flash[:denied] = "Access denied as you don't own #{@dog.name}"
      redirect_to root_path
    end
  end
end
