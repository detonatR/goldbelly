# frozen_string_literal: true

class RedirectsController < ApplicationController
  def show
    if @link = Link.active.find_by(slug: params[:slug])
      redirect_to @link.url, status: :moved_permanently
    else
      head :not_found
    end
  end
end
