module BattleReportStats
  class UpdateService < ApplicationService
    class UpdateServiceValidationError < StandardError; end

    def initialize(company_id)
      @company_stats = CompanyStats.find_by(company_id: company_id)
    end

    # Add these new stats for the company to the existing company stats record
    # TODO Could we have company stats update for non-final battle?
    def update_company_stats(battle_size, new_stats, is_final, is_winner)
      vs_string(battle_size)

      # Update kill loss stats
      @company_stats["infantry_kills_#{@vs_string}"] += new_stats[:inf_killed]
      @company_stats["infantry_losses_#{@vs_string}"] += new_stats[:inf_lost]
      @company_stats["vehicle_kills_#{@vs_string}"] += new_stats[:vehicles_killed]
      @company_stats["vehicle_losses_#{@vs_string}"] += new_stats[:vehicles_lost]

      # If final, update wins, losses, streak stats
      if is_final
        if is_winner
          @company_stats["wins_#{@vs_string}"] += 1
          @company_stats["streak_#{@vs_string}"] += 1
        else
          @company_stats["losses_#{@vs_string}"] += 1
          @company_stats["streak_#{@vs_string}"] = 0
        end
      end

      @company_stats.save!
    end

    private

    def validate_battle_size(battle_size)
      raise UpdateServiceValidationError.new("Invalid battle size: #{battle_size}") unless Battle::BATTLE_SIZES.include?(battle_size)
    end

    def vs_string(battle_size)
      @vs_string ||= "#{battle_size}v#{battle_size}"
    end
  end
end
