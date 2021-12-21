module API
  class DoctrinesController < APIController
    def index
      render json: DoctrineSerializer.new(Doctrine.all).serializable_hash
    end

    def show
      doctrine_id = params[:id]

      render json: DoctrineSerializer.new(Doctrine.find(doctrine_id)).serializable_hash
    end
  end
end
