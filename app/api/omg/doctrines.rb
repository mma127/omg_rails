module OMG
  class Doctrines < Grape::API
    helpers OMG::Helpers

    before do
      authenticate!
    end

    resource :doctrines do
      desc 'get all doctrines'
      get do
        present Doctrine.all
      end

      desc 'get requested doctrine'
      params do
        requires :id, type: Integer, desc: "A doctrine ID"
      end
      get ':id' do
        present Doctrine.find(params[:id])
      end
    end
  end
end

