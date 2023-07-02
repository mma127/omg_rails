require 'tempfile'
require 'zip'
gem 'rubyzip'

class BattlefileService
  class BattlefileGenerationValidationError < StandardError; end

  TABS = ['', 'Core', 'Assault', 'Infantry', 'Armour', 'Anti-Armor', 'Support']
  SGA_FILENAME = "OperationMarketGardenBattle.sga"
  UCS_FILENAME = "OMGmodBattle.English.ucs"

  def initialize(battle_id)
    @battle_id = battle_id
    @battle = Battle.includes(battle_players:
                                [company:
                                   [:player, :doctrine, :faction, :offmaps,
                                    callin_modifiers: [:callin_modifier_required_units, :callin_modifier_allowed_units],
                                    squads: [available_unit: :unit]]])
                    .find(battle_id)
  end

  # To download with temp url: Rails.application.routes.url_helpers.rails_blob_url(Battle.last.battlefile)

  # Generate the SGA battlefile and UCS names file
  def generate_files
    validate_battle_exists
    validate_battle_full
    validate_battle_generating
    validate_battle_players_ready

    scar_contents, ucs_contents = build_scar_ucs_contents
    create_attach_zip(scar_contents, ucs_contents)
  end

  def get_file_download_url
    validate_battle_exists
    validate_battlefile_attached
    Rails.application.routes.url_helpers.rails_blob_url(@battle.battlefile)
  end

  private

  def build_scar_ucs_contents
    attacker = 0 # Hardcode for now, no momentum
    battle_mode = "MCP" # Hardcode for now, otherwise could be VP mode

    companies = @battle.companies

    @ucs_contents = ""
    @allied_player_index = 1
    @axis_player_index = 1
    companies_block = ""
    # Index starts at one, goes up to @battle.total_size
    companies.each.with_index(1) do |c, index|
      company_content = build_player_company_block(c, index)
      companies_block << company_content
    end
    report_url = "#{ENV['SERVER_HOST']}/api/battles/report"
    # Need to slice the protocol off so the SCAR cURL library works
    report_url.slice!("https://")

    # Header data
    scar_contents = <<-SCAR
MinTerritoryCheck = true
MaxPopcap = 40
StartPopCap = 25
PopCapIncrementation = 1
BattleAttacker = #{attacker}
TerritoryEndTime = 170
TerritoryCheckIncreaseTime = 300
BattleID = #{@battle.id}
BattleMode = "#{battle_mode}"
SpawnArtyNeeded = true
WinningCueNeeded = true
TerritoryCheckWinNeeded = true
ReportUrl = "#{report_url}"

function Setup_PlayerUnits(player)
  print("Setup_PlayerUnits")
  local pid = Player_GetID(player) - 999
#{companies_block}
  end
end
    SCAR

    [scar_contents, @ucs_contents]
  end

  def build_player_company_block(company, index)
    player = company.player
    faction = company.faction
    doctrine = company.doctrine

    arrival = 5 # Hardcode for now, else momentum-based attacker wait time if attacking

    abilities_block = build_abilities_block(company)
    buildings_block = build_buildings_block(company)
    platoons_block = build_platoons_block(company)

    # Increment player index
    if company.faction.side == Faction.sides[:allied]
      @allied_player_index += 1
    else
      @axis_player_index += 1
    end

    <<-COMPANY
  #{"else" if index != 1}if Player[pid].Name == "#{player.name}" then
    Player[pid].Race = #{faction.race}
    Player[pid].Doctrine = #{doctrine.const_name}
    Player[pid].Arrival = #{arrival}
    Player[pid].Para_Extra_Time = 15
    Player[pid].Glider_Extra_Time = 15
    Player[pid].Report_Delay = 5
    Player[pid].CompanyId = #{company.id}
    Player[pid].GliderSpawning = true
    Player[pid].Abilities = {\n#{abilities_block}
    }
    Player[pid].Buildings = {\n#{buildings_block}
    }
    Player[pid].Platoons = {\n#{platoons_block}
    }
    COMPANY
  end

  def build_abilities_block(company)
    unlock_consts = company.company_unlocks.map { |cu| cu.unlock.const_name }
    unlock_consts.join(",\n")
  end

  def build_buildings_block(company)
    offmap_consts = company.company_offmaps.map { |co| co.offmap.const_name }
    building_consts = company.squad_upgrades
                             .includes(available_upgrade: :upgrade)
                             .joins(available_upgrade: :upgrade)
                             .where(upgrade: { type: "Upgrades::Building" })
                             .map { |su| su.available_upgrade.upgrade.formatted_const_name }

    merged_consts = offmap_consts.concat(building_consts)
    merged_consts.join(",\n")
  end

  # Player[pid].Platoons = {
  #   {
  #     PlatoonID = "1x1x1",
  #     Pop = 25,
  #     CallInTimeModifier = 1,
  #     NotAvailUntil = 0,
  #     Squadnumber = 3,
  #     Glider = false,
  #     ParaDrop = false,
  #     Infiltrate = false,
  #     HalfTrack = false,
  #     {
  #       ...squad blocks
  #     }
  #   }
  #   ...
  # }
  def build_platoons_block(company)
    platoons_table = CompanyHelper.get_platoon_table(company)
    team_index = company.faction.side_integer
    player_index = company.faction.side == Faction.sides[:allied] ? @allied_player_index : @axis_player_index
    callin_modifiers = company.callin_modifiers

    result = ""
    platoons_table.each do |tab_category, platoons|
      platoons.each do |category_position, platoon|
        result << build_platoon_block(platoon, team_index, player_index, callin_modifiers)
      end
    end

    result
  end

  # HalfTrack - list of transport squads
  # squad blocks - list of non-transport squads
  def build_platoon_block(platoon, team_index, player_index, callin_modifiers)
    callin_modifier = calculate_callin_modifier_total(platoon.squads, callin_modifiers)
    glider = "false,"
    paradrop = ""
    infiltrate = ""
    halftrack = ""

    squadnumber = 0
    squad_blocks = ""
    platoon.squads.each do |squad|
      if squad.unit.is_a? Glider
        glider = build_glider_squad_block(squad) # Should only have 1 glider per platoon
      elsif squad.transporting_transported_squads.present?
        halftrack << build_squad_block(squad)
        # TODO PARADROP, INFILTRATE
      else
        squad_blocks << build_squad_block(squad)
        squadnumber += 1
      end
    end

    @ucs_contents << platoon.ucs_string(team_index, player_index)

    <<-PLATOON
        {
          PlatoonID = "#{player_index}x#{platoon.platoon_index}x#{platoon.display_position}",
          Pop = #{platoon.pop.to_i},
          CallInTimeModifier = #{callin_modifier},
          NotAvailUntil = 0,
          Squadnumber = #{squadnumber},
          Glider = #{glider}
          ParaDrop = #{format_squad_list(paradrop)}
          Infiltrate = #{format_squad_list(infiltrate)}
          HalfTrack = #{format_squad_list(halftrack)}\n#{squad_blocks}
        },
    PLATOON
  end

  def calculate_callin_modifier_total(squads, callin_modifiers)
    squad_unit_ids = squads.map { |s| s.unit_id }.uniq
    callin_modifiers.reduce(1) do |acc, cm|
      acc * maybe_apply_callin_modifier(squad_unit_ids, cm)
    end
  end

  # For each callin_modifier,
  # validate required units
  # * If not empty, one of the squads must be a unit in required units
  # Validate allowed units
  # * If not empty, every squad must be a unit in allowed units
  def maybe_apply_callin_modifier(squad_unit_ids, callin_modifier)
    return 1 unless validate_callin_modifier_required(callin_modifier.required_unit_ids, squad_unit_ids)
    return 1 unless validate_callin_modifier_allowed(callin_modifier.allowed_unit_ids, squad_unit_ids)

    callin_modifier.modifier
  end

  def validate_callin_modifier_required(required_unit_ids, squad_unit_ids)
    return true if required_unit_ids.blank?

    squad_unit_ids.any? { |unit_id| required_unit_ids.include? unit_id }
  end

  def validate_callin_modifier_allowed(allowed_unit_ids, squad_unit_ids)
    return true if allowed_unit_ids.blank?

    squad_unit_ids.all? { |unit_id| allowed_unit_ids.include? unit_id }
  end

  #  {
  #     SGroup = SGroup_CreateIfNotFound("SGroup22085"),
  #     BP = OMGSBPS.ALLY.SHERMAN,
  #     exp = 0.0000,
  #     SquadPop = 8,
  #     Upgrades = {},
  #     HalfTrack_Check = false
  #   },
  #
  # If HalfTrack_Check is true, also include HalfTrack_SGroup_Name of the transport squad id
  #
  def build_squad_block(squad)
    upgrades = build_squad_upgrades_block(squad)
    unit_replacement_const = get_unit_replacement_const(squad)
    if unit_replacement_const.present?
      const = unit_replacement_const
    else
      const = squad.unit.const_name
    end

    if squad.embarked_transported_squad.present?
      halftrack_check = "true,"
      transport_sgroup_name = "\n              Transport_SGroup_Name = 'SGroup#{squad.embarked_transported_squad.transport_squad_id}'"
    else
      halftrack_check = "false"
      transport_sgroup_name = ""
    end
    <<-SQUAD
          {
              SGroup = SGroup_CreateIfNotFound("SGroup#{squad.id}"),
              BP = OMGSBPS.#{const},
              exp = #{squad.vet},
              SquadPop = #{squad.pop.to_i},
              Upgrades = {
                #{upgrades}
              },
              HalfTrack_Check = #{halftrack_check}#{transport_sgroup_name}
            },
    SQUAD
  end

  def build_squad_upgrades_block(squad)
    upgrade_consts = squad.squad_upgrades
                        .includes(available_upgrade: :upgrade)
                        .joins(available_upgrade: :upgrade)
                        .where.not(upgrade: { type: %w[Upgrades::Building Upgrades::UnitReplacement] })
                        .map { |su| su.available_upgrade.upgrade.formatted_const_name }
    upgrade_consts.join(",\n")
  end

  def get_unit_replacement_const(squad)
    squad.squad_upgrades
         .includes(available_upgrade: :upgrade)
         .joins(available_upgrade: :upgrade)
         .where(upgrade: { type: "Upgrades::UnitReplacement" })
         .map { |su| su.available_upgrade.upgrade.const_name }
         .first
  end

  #                 Glider = {
  #                     BP = OMGEBP.CMW.INF_GLIDER,
  #                     Upgrades = {},
  #                     SquadPop = 0
  #                 },
  #
  # If HalfTrack_Check is true, also include HalfTrack_SGroup_Name of the transport squad id
  #
  def build_glider_squad_block(squad)
    upgrades = "" # TODO upgrades
    <<-SQUAD
          {
              BP = OMGEBP.#{squad.unit.const_name},
              SquadPop = #{squad.pop.to_i},
              Upgrades = {
                #{upgrades}
              }
            },
    SQUAD
  end

  def encode_sga(scar_contents)
    # tocData section
    iDirCount = 2
    iFileCount = 1
    sFileName = "omg_battlefile.scar"
    tocData = ''
    tocData << [24, 1, 24 + 138, iDirCount, 24 + 138 + 12 * iDirCount, iFileCount, 24 + 138 + 12 * iDirCount + 22 * iFileCount, iFileCount + iDirCount].pack('LSLSLSLS')
    sTocName = 'data'
    (sTocName.size...64).each do
      sTocName << "\x00"
    end
    tocData << sTocName

    sTocTitle = Time.now.utc.strftime("%a, %d %b %Y %k:%M:%S %z") # Sun, 25 Sep 2022 02:05:12 +0000
    (sTocTitle.size...64).each do
      sTocTitle << "\x00"
    end
    tocData << sTocTitle
    tocData << [0, iDirCount, 0, iFileCount, 0].pack('SSSSS')
    tocData << [0, 1, 2, 0, 0].pack('LSSSS')
    tocData << [1, 2, 2, 0, 1].pack('LSSSS')
    iFileSize = scar_contents.size

    tocData << [6, 260, iFileSize, iFileSize, 0, 0].pack('LLLLLS')
    tocData << "\0scar\0#{sFileName}\0"
    preData = sFileName
    (preData.size...256).each do
      preData << "\x00"
    end
    fileCRC = [Zlib::crc32(scar_contents)].pack('L')

    # headerData
    headerData = "_ARCHIVE"
    headerData << [4].pack("L")
    md5DataKey = [Digest::MD5.hexdigest("E01519D6-2DB7-4640-AF54-0A23319C56C3#{tocData}#{preData}#{fileCRC}#{scar_contents}".force_encoding("ASCII-8BIT"))].pack('H*')
    headerData << md5DataKey

    sArchiveTitle = "P\x00h\x00i\x00l\x00s\x00"
    (sArchiveTitle.size...128).each do
      sArchiveTitle << "\x00"
    end
    headerData << sArchiveTitle

    md5toc = [Digest::MD5.hexdigest("DFC9AF62-FC1B-4180-BC27-11CCE87D3EFF#{tocData}".force_encoding("ASCII-8BIT"))].pack('H*')
    headerData << md5toc
    tocSize = tocData.size
    headerData << [tocSize, tocSize + 0xB8].pack('LL')
    headerData << [1].pack('L')

    if headerData.size != 184
      Rails.logger.error("Failed Battlefile creation due to header size mismatch (ID: #{@battle.id})")
    end

    if tocData.size != 24 + 138 + 12 + 12 + 22 + 26
      Rails.logger.error("Failed Battlefile creation due to TOC size mismatch (ID: #{@battle.id})")
    end

    sga = headerData + tocData + preData + fileCRC + scar_contents

    # TODO this should be a zip file
    # Tempfile.create(binmode: true) do |f|
    #   f << sga
    #   f.rewind
    #   @battle.battlefile.attach(io: f, filename: "OperationMarketGardenBattle.sga")
    # end
  end

  def encode_ucs(ucs_contents)
    result = [0xFEFF].pack("v")
    ucs_contents = ucs_contents.force_encoding("ASCII-8BIT")
    ucs_contents.each_char do |s|
      result << s
      result << "\0"
    end

    result
  end

  def create_attach_zip(scar_contents, ucs_contents)
    battle_string = "battle#{@battle_id}"
    Dir.mktmpdir(battle_string) do |dir|
      omgmod = FileUtils.mkdir("#{dir}/OMGmod").first
      archives = FileUtils.mkdir("#{omgmod}/Archives").first
      locale = FileUtils.mkdir("#{omgmod}/Locale").first
      english = FileUtils.mkdir("#{locale}/English").first

      sga_path = "#{archives}/#{SGA_FILENAME}"
      ucs_path = "#{english}/#{UCS_FILENAME}"
      File.open(sga_path, "wb") do |f|
        f.write(encode_sga(scar_contents))
      end

      File.open(ucs_path, "wb") do |f|
        f.write(encode_ucs(ucs_contents))
      end

      Zip::File.open("#{dir}/#{battle_string}.zip", Zip::File::CREATE) do |zipfile|
        zipfile.add("OMGmod/Archives/#{SGA_FILENAME}",
                    sga_path)

        zipfile.add("OMGmod/Locale/English/#{UCS_FILENAME}",
                    ucs_path)
      end

      zip_filename = "#{battle_string}.zip"
      zipfile_io = File.open("#{dir}/#{zip_filename}")
      @battle.battlefile.attach(io: zipfile_io,
                                filename: "#{zip_filename}",
                                content_type: 'application/octet-stream')
    end
  end

  # Validations
  def validate_battle_exists
    raise BattlefileGenerationValidationError.new "Battle #{@battle_id} does not exist" unless @battle.present?
  end

  def validate_battle_full
    raise BattlefileGenerationValidationError.new "Battle #{@battle.id} is not full" unless @battle.players_full?
  end

  def validate_battle_generating
    raise BattlefileGenerationValidationError.new "Battle #{@battle.id} is not in generating status" unless @battle.generating?
  end

  def validate_battle_players_ready
    raise BattlefileGenerationValidationError.new "Battle #{@battle.id} is not in generating status" unless @battle.players_ready?
  end

  def validate_battlefile_attached
    raise BattlefileGenerationValidationError.new "Battle #{@battle.id} does not have a battlefile attached" if @battle.battlefile.blank?
  end

  def format_squad_list(list)
    if list.blank?
      "false,"
    else
      <<-SQUAD
{
  #{list}
          },
      SQUAD
    end
  end
end
