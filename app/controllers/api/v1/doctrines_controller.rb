class Api::V1::DoctrinesController < ApplicationController

  def doctrine
    @doctrine ||= Doctrine.find(params[:id])
  end

  def index
    doctrines = Doctrine.all.order(:created_at)
    render json: doctrines
  end

  def create
  end

  def show
    if doctrine
      render json: @doctrine
    else
      render json: doctrine.errors
    end
  end

  def destroy
  end
end
