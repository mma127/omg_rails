module OMG
  class Players < Grape::API
    helpers OMG::Helpers::RequestHelpers

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
