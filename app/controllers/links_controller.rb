# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @links = current_user.links
  end

  def create
    @link = prepare_from_slugger(create_params)

    if @link.save
      render :show
    else
      render json: { errors: @link.errors }, status: :unprocessable_entity
    end
  end

  def update
    @link = current_user.links.find(params[:id])

    if @link.update(update_params)
      render :show
    else
      render json: { errors: @link.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])
    @link.destroy!

    head :no_content
  end

  private

  def prepare_from_slugger(options)
    Slugger.generate(
      user: current_user,
      url: options[:url],
      custom_slug: options[:slug],
      expires_at: options[:expires_at]
    )
  end

  def create_params
    params.require(:link).permit(:url, :slug, :expires_at)
  end

  def update_params
    params.require(:link).permit(:expires_at)
  end
end
