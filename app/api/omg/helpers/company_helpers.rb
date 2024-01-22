module OMG
  module Helpers
    module CompanyHelpers
      extend Grape::API::Helpers

      def load_company(id, current_player)
        Company.includes(:ruleset,
                         { squads: [:embarked_transport, :squads_in_transport, available_unit: { unit: :transport_allowed_units }],
                           available_units: { unit: [:transport_allowed_units, :unit_vet] },
                           available_offmaps: :offmap,
                           company_offmaps: :offmap,
                           company_callin_modifiers: :callin_modifier,
                           squad_upgrades: :squad,
                           available_upgrades: :upgrade })
               .find_by(id: id, player: current_player)
      end
    end
  end
end
