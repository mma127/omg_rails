class CompaniesController < ApplicationController
  before_action :authenticate_player!

  def index
    player_id = params[:id]
    if player_id.present?
      companies = Company.where(player_id: player_id)
    else
      companies = Company.all
    end
    render json: companies
  end
end
