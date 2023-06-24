module OMG
  class Doctrines < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :doctrines do
      desc 'get all doctrines'
      get do
        present Doctrine.all
      end

      route_param :id, type: Integer do
        desc 'get requested doctrine'
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        get do
          present Doctrine.find(params[:id])
        end

        desc 'get unlocks for the doctrine'
        params do
          requires :id, type: Integer, desc: "Company ID"
        end
        get 'unlocks' do
          present Doctrine.includes(doctrine_unlocks: [:restriction, unlock: :restriction]).find(params[:id]).doctrine_unlocks, type: :full
        end
      end
    end
  end
end

