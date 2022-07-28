class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /items
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    items = @user ? @user.items : Item.all
    # items = Item.all
    render json: items, include: :user
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if params[:user_id]
      @user = User.find(params[:user_id])
      @item.user = @user
    end

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.fetch(:item, {})
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end
end
