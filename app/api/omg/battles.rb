module OMG
  class Battles < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :battles do
      desc 'get all battles'
      params do
        optional :statuses, type: Array[String], default: %w[open full generating ingame], desc: "Optional battle statuses to filter by"
        optional :rulesetId, type: Integer, desc: "Optional ruleset to filter by"
      end
      get do
        query = Battle.includes(battle_players: { player: :player_rating }).where(state: params[:statuses])
        if params[:ruleset_id].present?
          query.where(ruleset_id: params[:ruleset_id])
        end
        present query, type: :include_players
      end

      route_param :battle_id, type: Integer, desc: "Battle id to download" do
        namespace :battlefiles do
          desc 'download battlefile zip'
          get :zip do
            service = BattlefileService.new(declared_params[:battle_id])
            redirect service.get_zip_file_download_url
          end

          desc 'download battlefile sga'
          get :sga do
            service = BattlefileService.new(declared_params[:battle_id])
            redirect service.get_sga_file_download_url
          end

          desc 'download battlefile ucs'
          get :ucs do
            service = BattlefileService.new(declared_params[:battle_id])
            redirect service.get_ucs_file_download_url
          end

          desc 'download battle report file'
          get :report do
            service = BattlefileService.new(declared_params[:battle_id])
            redirect service.get_report_file_download_url
          end
        end
      end

      namespace :player do
        before do
          authenticate!
        end

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
          battle = service.create_battle(declared_params[:name], declared_params[:size], declared_params[:rulesetId], declared_params[:initialCompanyId])
          present battle
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

        # Ready up in Battle
        desc "Unready a player in a battle"
        params do
          requires :battleId, type: Integer, desc: "Battle id to ready in"
        end
        post 'unready' do
          service = BattleService.new(current_player)
          service.unready_player(declared_params[:battleId])
        end

        # Kick player from battle
        desc "Admin kick player from lobby"
        params do
          requires :battleId, type: Integer, desc: "Battle id to kick from"
          requires :kickPlayerId, type: Integer, desc: "Player id to kick"
        end
        post 'kick' do
          service = BattleService.new(current_player)
          service.kick_player(declared_params[:battleId], declared_params[:kickPlayerId])
        end

        # Abandon a 'generating', 'ingame', 'reporting'? Battle
        desc "Mark a player as abandoned in a battle"
        params do
          requires :battleId, type: Integer, desc: "Battle id to abandon in"
        end
        post 'abandon' do
          service = BattleService.new(current_player)
          service.abandon_battle(declared_params[:battleId])
        end

        # Resize battle
        desc "Admin change battle size"
        params do
          requires :battleId, type: Integer, desc: "Battle id to change"
          requires :newSize, type: Integer, values: Battle::BATTLE_SIZES, desc: "new battle size"
        end
        post "change_battle_size" do
          service = BattleService.new(current_player)
          service.change_battle_size(declared_params[:battleId], declared_params[:newSize])
        end
      end

      namespace :report do
        desc 'Handle a battle report from omg_statexport.scar'
        params do
          requires :battleID, type: Integer, desc: "Battle id"
          requires :final, type: Integer, desc: "Battle final flag, 1 for final, 0 for not"
          requires :battleReport, type: String, desc: "Display name of reporting player"
          requires :timeElapsed, type: Float, desc: "Battle elapsed time"
          requires :raceWinner, type: String, desc: "Axis or Allies or Intermediate if no winner (drop report)"
          requires :map, type: String, desc: "Map name"
          requires :deadSGroups, type: String, desc: "List of dead squads, semicolon separated"
          requires :surviveSGroups, type: String, desc: "List of surviving squads with xp, semicolon separated in format: [squad id],[exp];..."
          optional :newSGroups, type: String, desc: "List of new squads" # Not using for now
          requires :dropPlayers, type: String, desc: "List of dropped player names, possible to receive a blank string name, semicolon separated in format: [player name]; ..."
          requires :battleStats, type: String, desc: "Stats string by player semicolon separated in format: " \
            "[player name],CompanyId:[company id],Inf Lost:[int] ,Vehicles Lost:[int] ,Inf Killed[int] ,Vehicles Killed:[int];..."
        end
        post do
          # Rails.logger.info("Received battle report for battle #{declared_params[:battleID]} with params:")
          # Rails.logger.info("is_final #{declared_params[:final]}, reporting player #{declared_params[:battleReport]}, time_elapsed #{declared_params[:timeElapsed]}, winner #{declared_params[:raceWinner]}")
          # Rails.logger.info("dead_squads #{declared_params[:deadSGroups]}, surviving_squads #{declared_params[:surviveSGroups]}")
          BattleReportService.enqueue_report(declared_params[:battleID],
                                             declared_params[:final],
                                             declared_params[:battleReport],
                                             declared_params[:timeElapsed],
                                             declared_params[:raceWinner],
                                             declared_params[:map],
                                             declared_params[:deadSGroups],
                                             declared_params[:surviveSGroups],
                                             declared_params[:dropPlayers],
                                             declared_params[:battleStats],)
        end
      end
    end
  end
end

