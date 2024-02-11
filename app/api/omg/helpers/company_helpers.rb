module OMG
  module Helpers
    module CompanyHelpers
      extend Grape::API::Helpers

      def load_company(id, current_player)
        ActiveCompany.includes(:ruleset,
                         { squads: [:embarked_transport, :squads_in_transport, available_unit: { unit: :transport_allowed_units }],
                           available_units: { unit: [:transport_allowed_units, :unit_vet] },
                           available_offmaps: :offmap,
                           company_offmaps: :offmap,
                           company_callin_modifiers: :callin_modifier,
                           squad_upgrades: :squad,
                           available_upgrades: :upgrade })
               .find_by(id: id, player: current_player)
      end

      def load_snapshot_company(uuid)
        SnapshotCompany.find_by(uuid: uuid)
      end

      def load_snapshot_company_squads(uuid)
        SnapshotCompany.includes(:ruleset,
                                 :company_stats,
                                 { squads: [:embarked_transport, :squads_in_transport, available_unit: { unit: :transport_allowed_units }],
                                   available_units: { unit: [:unit_vet, :transport_allowed_units] },
                                   available_offmaps: :offmap,
                                   company_offmaps: :offmap,
                                   company_callin_modifiers: :callin_modifier,
                                   company_resource_bonuses: :resource_bonus,
                                   company_unlocks: :doctrine_unlock,
                                   squad_upgrades: :squad,
                                   available_upgrades: :upgrade })
                       .find_by(uuid: uuid)
      end
    end
  end
end
