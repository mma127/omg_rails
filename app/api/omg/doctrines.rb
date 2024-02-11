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
          requires :id, type: Integer, desc: "Doctrine ID"
        end
        get do
          present Doctrine.find(params[:id])
        end

        desc 'get unlocks for the doctrine'
        params do
          requires :id, type: Integer, desc: "Doctrine ID"
        end
        get 'unlocks' do
          present DoctrineUnlock
                    .includes(restriction:
                                { enabled_units: :unit,
                                  disabled_units: :unit,
                                  enabled_offmaps: :offmap,
                                  enabled_callin_modifiers: {
                                    callin_modifier: [:callin_modifier_required_units,
                                                      :callin_modifier_allowed_units] } },
                              unlock: {
                                unit_swaps: [:old_unit, :new_unit],
                                restriction:
                                  { enabled_units: :unit,
                                    disabled_units: :unit,
                                    enabled_offmaps: :offmap,
                                    enabled_callin_modifiers: {
                                      callin_modifier: [:callin_modifier_required_units,
                                                        :callin_modifier_allowed_units] } } })
                    .where(doctrine_id: params[:id]), type: :full
        end
      end
    end
  end
end

