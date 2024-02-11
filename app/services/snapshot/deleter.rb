module Snapshot
  class Deleter < ApplicationService
    def initialize(player, company_id)
      @player = player
      @company_id = company_id
    end

    def delete
      snapshot = SnapshotCompany.find_by(id: @company_id, player: @player)
      if snapshot.present?
        snapshot.destroy!
      end
    end
  end
end
