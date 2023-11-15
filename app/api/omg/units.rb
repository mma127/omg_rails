module OMG
  class Units < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :units do
      desc 'get all units'
      get do
        present Unit.all, type: :default
      end

      desc 'get requested unit'
      params do
        requires :id, type: Integer, desc: "A Unit ID"
      end
      get ':id' do
        present Unit.find(params[:id])
      end
    end
  end
end


