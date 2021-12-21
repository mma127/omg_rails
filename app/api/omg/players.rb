module OMG
  class Players < Grape::API
    helpers OMG::Helpers

    before do
      authenticate!
    end

    resource :player do
      desc 'return current player'
      get do
        present current_player
      end
    end
  end
end
