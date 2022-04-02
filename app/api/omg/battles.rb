module OMG
  class Battles < Grape::API
    helpers OMG::Helpers

    resource :battles do
      desc 'get all battles'
      params do
        optional :statuses, type: Array[String], default: %w[open full generating ingame], desc: "Optional battle statuses to filter by"
        optional :rulesetId, type: Integer, desc: "Optional ruleset to filter by"
      end
      get do
        query = Battle.where(state: params[:statuses])
        if params[:ruleset_id].present?
          query.where(ruleset_id: params[:ruleset_id])
        end
        present query, type: :include_players
      end

      namespace :player do
        before do
          authenticate!
        end

        # TODO
        # Create new Battle
        desc 'create new Battle by the player'
        params do
          requires :name, type: String, desc: "Battle name"
          requires :size, type: Integer, desc: "Battle size per side"
          requires :rulesetId, type: Integer, desc: "Ruleset for the battle"
          requires :initialCompanyId, type: Integer, desc: "Initial company to start the battle, should belong to the player"
        end
        post 'create_match' do
          service = BattleService.new(current_player)
          service.create_battle(declared_params[:name],declared_params[:size],declared_params[:rulesetId],declared_params[:initialCompanyId])
        end

        # Join Battle with Company
        desc "Join an existing Battle with the Player's Company"
        params do
          requires :battleId, type: Integer, desc: "Battle id to join"
          requires :companyId, type: Integer, desc: "Company Id to join the Battle with"
        end
        post 'join_match' do
          service = BattleService.new(current_player)
          service.join_battle(declared_params[:battleId], declared_params[:companyId])
        end

        # Leave Battle
        desc "Leave an existing Battle"
        params do
          requires :battleId, type: Integer, desc: "Battle id to leave"
        end
        post 'leave_match' do
          service = BattleService.new(current_player)
          service.leave_battle(declared_params[:battleId])
        end

        # Ready up in Battle
        desc "Ready a player in a battle"
        params do
          requires :battleId, type: Integer, desc: "Battle id to ready in"
        end
        post 'ready' do
          service = BattleService.new(current_player)
          service.ready_player(declared_params[:battleId])
        end

        # Abandon a 'generating', 'ingame', 'reporting'? Battle

      end
    end
  end
end

