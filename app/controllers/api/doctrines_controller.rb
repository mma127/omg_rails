module Api
  class DoctrinesController < ApiController
    def index
      render json: Doctrine.all
    end

    def show
      doctrine_id = params[:id]

      render json: Doctrine.find(doctrine_id)
    end
  end
end
