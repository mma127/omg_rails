# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_03_194040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "available_units", comment: "Unit availability per company", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "unit_id"
    t.string "type", null: false, comment: "Type of available unit"
    t.integer "available", default: 0, null: false, comment: "Number of this unit available to purchase for the company"
    t.integer "resupply", default: 0, null: false, comment: "Per game resupply"
    t.integer "resupply_max", default: 0, null: false, comment: "How much resupply is available from saved up resupplies, <= company ma"
    t.integer "company_max", default: 0, null: false, comment: "Maximum number of the unit a company can hold"
    t.decimal "pop", null: false, comment: "Calculated pop cost of this unit for the company"
    t.integer "man", null: false, comment: "Calculated man cost of this unit for the company"
    t.integer "mun", null: false, comment: "Calculated mun cost of this unit for the company"
    t.integer "fuel", null: false, comment: "Calculated fuel cost of this unit for the company"
    t.decimal "callin_modifier", null: false, comment: "Calculated base callin modifier of this unit for the company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "unit_id", "type"], name: "index_available_units_on_company_id_and_unit_id_and_type", unique: true
    t.index ["company_id"], name: "index_available_units_on_company_id"
    t.index ["unit_id"], name: "index_available_units_on_unit_id"
  end

  create_table "available_upgrades", comment: "Upgrade availability per company", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "upgrade_id"
    t.integer "available", comment: "Number of this upgrade available to purchase for the company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_available_upgrades_on_company_id"
    t.index ["upgrade_id"], name: "index_available_upgrades_on_upgrade_id"
  end

  create_table "battle_players", force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "player_id", null: false
    t.bigint "company_id", null: false
    t.boolean "ready", default: false, comment: "Ready flag for the player"
    t.string "side", null: false, comment: "Team side"
    t.boolean "abandoned", default: false, comment: "Is this player abandoning?"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_id"], name: "index_battle_players_on_battle_id"
    t.index ["company_id"], name: "index_battle_players_on_company_id"
    t.index ["player_id"], name: "index_battle_players_on_player_id"
  end

  create_table "battles", force: :cascade do |t|
    t.string "name", comment: "Optional battle name"
    t.string "state", null: false, comment: "Battle status"
    t.integer "size", null: false, comment: "Size of each team"
    t.string "winner", comment: "Winning side"
    t.bigint "ruleset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ruleset_id"], name: "index_battles_on_ruleset_id"
    t.index ["state"], name: "index_battles_on_state"
  end

  create_table "callin_modifier_allowed_units", comment: "Units allowed in a callin for a callin modifier to take effect", force: :cascade do |t|
    t.bigint "callin_modifier_id"
    t.bigint "unit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["callin_modifier_id"], name: "index_callin_modifier_allowed_units_on_callin_modifier_id"
    t.index ["unit_id"], name: "index_callin_modifier_allowed_units_on_unit_id"
  end

  create_table "callin_modifier_required_units", comment: "Unit required for the callin modifier to be applied", force: :cascade do |t|
    t.bigint "callin_modifier_id"
    t.bigint "unit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["callin_modifier_id"], name: "index_callin_modifier_required_units_on_callin_modifier_id"
    t.index ["unit_id"], name: "index_callin_modifier_required_units_on_unit_id"
  end

  create_table "callin_modifiers", force: :cascade do |t|
    t.decimal "modifier", comment: "Modifies callin time"
    t.string "type", comment: "Type of modification"
    t.integer "priority", comment: "Priority in which the modifier is applied, from 1 -> 100"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", comment: "Company name"
    t.bigint "player_id", null: false
    t.bigint "doctrine_id", null: false
    t.bigint "faction_id", null: false
    t.bigint "ruleset_id", null: false
    t.integer "vps_earned", default: 0, null: false, comment: "VPs earned by this company"
    t.integer "vps_current", default: 0, null: false, comment: "VPs available to spend"
    t.integer "man", default: 0, comment: "Manpower available to this company"
    t.integer "mun", default: 0, comment: "Munitions available to this company"
    t.integer "fuel", default: 0, comment: "Fuel available to this company"
    t.integer "pop", default: 0, comment: "Population cost of this company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id"], name: "index_companies_on_doctrine_id"
    t.index ["faction_id"], name: "index_companies_on_faction_id"
    t.index ["player_id"], name: "index_companies_on_player_id"
    t.index ["ruleset_id"], name: "index_companies_on_ruleset_id"
  end

  create_table "company_offmaps", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "offmap_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_offmaps_on_company_id"
    t.index ["offmap_id"], name: "index_company_offmaps_on_offmap_id"
  end

  create_table "company_resource_bonuses", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "resource_bonus_id"
    t.integer "level", comment: "Number of this bonus taken"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_resource_bonuses_on_company_id"
    t.index ["resource_bonus_id"], name: "index_company_resource_bonuses_on_resource_bonus_id"
  end

  create_table "company_unlocks", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "doctrine_unlock_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_unlocks_on_company_id"
    t.index ["doctrine_unlock_id"], name: "index_company_unlocks_on_doctrine_unlock_id"
  end

  create_table "doctrine_unlocks", comment: "Associates doctrines to unlocks", force: :cascade do |t|
    t.bigint "doctrine_id"
    t.bigint "unlock_id"
    t.string "internal_description", comment: "Doctrine and Unlock names"
    t.integer "vp_cost", default: 0, null: false, comment: "VP cost of this doctrine unlock"
    t.integer "tree", comment: "Which tree of the doctrine this unlock will appear at"
    t.integer "branch", comment: "Which branch of the doctrine tree this unlock will appear at"
    t.integer "row", comment: "Which row of the doctrine tree branch this unlock will appear at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id", "tree", "branch", "row"], name: "index_doctrine_unlocks_on_doctrine_tree", unique: true
    t.index ["doctrine_id", "unlock_id"], name: "index_doctrine_unlocks_on_doctrine_id_and_unlock_id", unique: true
    t.index ["doctrine_id"], name: "index_doctrine_unlocks_on_doctrine_id"
    t.index ["unlock_id"], name: "index_doctrine_unlocks_on_unlock_id"
  end

  create_table "doctrines", comment: "Faction doctrines", force: :cascade do |t|
    t.string "name", null: false, comment: "Raw name"
    t.string "display_name", null: false, comment: "Display name"
    t.string "const_name", null: false, comment: "Doctrine CONST name for battlefile"
    t.string "internal_name", null: false, comment: "Name for internal code use, may not be needed"
    t.bigint "faction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["const_name"], name: "index_doctrines_on_const_name", unique: true
    t.index ["faction_id"], name: "index_doctrines_on_faction_id"
    t.index ["name"], name: "index_doctrines_on_name", unique: true
  end

  create_table "factions", comment: "Game factions", force: :cascade do |t|
    t.string "name", null: false, comment: "Raw name"
    t.string "display_name", null: false, comment: "Display name"
    t.string "const_name", null: false, comment: "Faction CONST name for battlefile"
    t.string "internal_name", null: false, comment: "Name for internal code use, may not be needed"
    t.string "side", null: false, comment: "Allied or Axis side"
    t.integer "race", comment: "In-game race id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["const_name"], name: "index_factions_on_const_name", unique: true
    t.index ["name"], name: "index_factions_on_name", unique: true
  end

  create_table "games", comment: "Metadata for CoH games, including alpha", force: :cascade do |t|
    t.string "name", comment: "Game name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "offmaps", force: :cascade do |t|
    t.string "name", comment: "Offmap name"
    t.string "const_name", comment: "Offmap const name for battlefile"
    t.integer "mun", comment: "Munitions cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", comment: "Player record", force: :cascade do |t|
    t.string "name", comment: "Player screen name"
    t.text "avatar", comment: "Player avatar url"
    t.string "provider", comment: "Omniauth provider"
    t.string "uid", comment: "Omniauth uid"
    t.integer "vps", default: 0, null: false, comment: "WAR VPs earned"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
  end

  create_table "resource_bonuses", force: :cascade do |t|
    t.string "name", comment: "Resource bonus name"
    t.string "type", comment: "Resource type"
    t.integer "value", comment: "Bonus amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restriction_callin_modifiers", comment: "Association of Restriction to CallinModifier", force: :cascade do |t|
    t.bigint "restriction_id"
    t.bigint "callin_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["callin_modifier_id"], name: "index_restriction_callin_modifiers_on_callin_modifier_id"
    t.index ["restriction_id"], name: "index_restriction_callin_modifiers_on_restriction_id"
  end

  create_table "restriction_offmaps", comment: "Association of Restriction to Offmap", force: :cascade do |t|
    t.bigint "restriction_id"
    t.bigint "offmap_id"
    t.integer "max", comment: "Maximum number purchasable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["offmap_id"], name: "index_restriction_offmaps_on_offmap_id"
    t.index ["restriction_id"], name: "index_restriction_offmaps_on_restriction_id"
  end

  create_table "restriction_units", comment: "Association of Restriction to Unit", force: :cascade do |t|
    t.bigint "restriction_id"
    t.bigint "unit_id"
    t.bigint "ruleset_id"
    t.string "internal_description", null: false, comment: "What does this RestrictionUnit do?"
    t.string "type", null: false, comment: "What effect this restriction has on the unit"
    t.decimal "pop", comment: "Population cost"
    t.integer "man", comment: "Manpower cost"
    t.integer "mun", comment: "Munition cost"
    t.integer "fuel", comment: "Fuel cost"
    t.integer "resupply", comment: "Per game resupply"
    t.integer "resupply_max", comment: "How much resupply is available from saved up resupplies, <= company max"
    t.integer "company_max", comment: "Maximum number of the unit a company can hold"
    t.decimal "callin_modifier", default: "1.0", comment: "Base callin modifier, default is 1"
    t.integer "priority", comment: "Priority order to apply the modification from 1 -> 100"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "upgrade_slots", default: 0, null: false, comment: "Slots used for per model weapon upgrades"
    t.integer "unitwide_upgrade_slots", default: 0, null: false, comment: "Unit wide weapon replacement slot"
    t.index ["restriction_id", "ruleset_id"], name: "index_restriction_units_on_restriction_id_and_ruleset_id"
    t.index ["restriction_id", "unit_id", "ruleset_id"], name: "index_restriction_units_restriction_unit_ruleset", unique: true
    t.index ["restriction_id"], name: "index_restriction_units_on_restriction_id"
    t.index ["ruleset_id"], name: "index_restriction_units_on_ruleset_id"
    t.index ["unit_id", "ruleset_id"], name: "index_restriction_units_on_unit_id_and_ruleset_id"
    t.index ["unit_id"], name: "index_restriction_units_on_unit_id"
  end

  create_table "restriction_upgrades", force: :cascade do |t|
    t.bigint "restriction_id"
    t.bigint "upgrade_id"
    t.bigint "ruleset_id"
    t.string "internal_description", comment: "What does this RestrictionUpgrade do?"
    t.string "type", null: false, comment: "What effect this restriction has on the upgrade"
    t.integer "uses", comment: "Number of uses this upgrade provides"
    t.integer "pop", comment: "Population cost"
    t.integer "man", comment: "Manpower cost"
    t.integer "mun", comment: "Munition cost"
    t.integer "fuel", comment: "Fuel cost"
    t.integer "priority", comment: "Priority of this restriction"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restriction_id"], name: "index_restriction_upgrades_on_restriction_id"
    t.index ["ruleset_id"], name: "index_restriction_upgrades_on_ruleset_id"
    t.index ["upgrade_id"], name: "index_restriction_upgrades_on_upgrade_id"
  end

  create_table "restrictions", force: :cascade do |t|
    t.string "name", comment: "Restriction name"
    t.text "description", comment: "Restriction description"
    t.bigint "faction_id"
    t.bigint "doctrine_id"
    t.bigint "doctrine_unlock_id"
    t.bigint "unlock_id"
    t.integer "vet_requirement", comment: "Minimum veterancy requirement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id"], name: "index_restrictions_on_doctrine_id"
    t.index ["doctrine_unlock_id"], name: "index_restrictions_on_doctrine_unlock_id"
    t.index ["faction_id", "doctrine_id", "doctrine_unlock_id", "unlock_id"], name: "idx_restrictions_uniq_id", unique: true
    t.index ["faction_id"], name: "index_restrictions_on_faction_id"
    t.index ["unlock_id"], name: "index_restrictions_on_unlock_id"
    t.check_constraint "num_nonnulls(faction_id, doctrine_id, doctrine_unlock_id, unlock_id) = 1", name: "chk_only_one_is_not_null"
  end

  create_table "rulesets", force: :cascade do |t|
    t.string "name", null: false, comment: "Ruleset name"
    t.string "description", comment: "Description"
    t.integer "starting_man", null: false, comment: "Company starting manpower"
    t.integer "starting_mun", null: false, comment: "Company starting muntions"
    t.integer "starting_fuel", null: false, comment: "Company starting fuel"
    t.integer "starting_vps", null: false, comment: "Company starting vps"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "squad_upgrades", comment: "Upgrades purchased for squad", force: :cascade do |t|
    t.bigint "squad_id"
    t.bigint "upgrade_id"
    t.boolean "is_free", comment: "Flag for whether this upgrade is free for the squad and has no availability cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["squad_id"], name: "index_squad_upgrades_on_squad_id"
    t.index ["upgrade_id"], name: "index_squad_upgrades_on_upgrade_id"
  end

  create_table "squads", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "available_unit_id"
    t.string "tab_category", null: false, comment: "Tab this squad is in"
    t.integer "category_position", null: false, comment: "Position within the tab the squad is in"
    t.decimal "vet", comment: "Squad's veterancy"
    t.string "name", comment: "Squad's custom name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["available_unit_id"], name: "index_squads_on_available_unit_id"
    t.index ["company_id"], name: "index_squads_on_company_id"
  end

  create_table "unit_games", force: :cascade do |t|
    t.bigint "unit_id"
    t.bigint "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_unit_games_on_game_id"
    t.index ["unit_id"], name: "index_unit_games_on_unit_id"
  end

  create_table "unit_swaps", comment: "Association of old and new units to swap for an unlock", force: :cascade do |t|
    t.bigint "unlock_id", null: false
    t.bigint "old_unit_id", null: false
    t.bigint "new_unit_id", null: false
    t.string "internal_description", comment: "Internal description of this UnitSwap"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["new_unit_id"], name: "index_unit_swaps_on_new_unit_id"
    t.index ["old_unit_id"], name: "index_unit_swaps_on_old_unit_id"
    t.index ["unlock_id", "old_unit_id"], name: "index_unit_swaps_on_unlock_id_and_old_unit_id", unique: true
    t.index ["unlock_id"], name: "index_unit_swaps_on_unlock_id"
  end

  create_table "units", comment: "Metadata for a unit", force: :cascade do |t|
    t.string "name", null: false, comment: "Unique unit name"
    t.string "type", null: false, comment: "Unit type"
    t.string "const_name", null: false, comment: "Const name of the unit for the battle file"
    t.string "display_name", null: false, comment: "Display name"
    t.text "description", comment: "Display description of the unit"
    t.integer "upgrade_slots", default: 0, null: false, comment: "Slots used for per model weapon upgrades"
    t.integer "unitwide_upgrade_slots", default: 0, null: false, comment: "Unit wide weapon replacement slot"
    t.boolean "is_airdrop", default: false, null: false, comment: "Is this unit airdroppable?"
    t.boolean "is_infiltrate", default: false, null: false, comment: "Is this unit able to infiltrate?"
    t.string "retreat_name", comment: "Name for retreating unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_units_on_name", unique: true
  end

  create_table "unlocks", comment: "Metadata for a generic doctrine ability", force: :cascade do |t|
    t.string "name", null: false, comment: "Unlock internal name"
    t.string "display_name", null: false, comment: "Unlock display name"
    t.string "const_name", comment: "Const name of the doctrine ability for the battle file"
    t.text "description", comment: "Display description of this doctrine ability"
    t.string "image_path", comment: "Url to the image to show for this doctrine ability"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_unlocks_on_name", unique: true
  end

  create_table "upgrades", force: :cascade do |t|
    t.string "const_name", comment: "Upgrade const name used by the battlefile"
    t.string "name", null: false, comment: "Unique upgrade name"
    t.string "display_name", null: false, comment: "Display upgrade name"
    t.string "description", comment: "Upgrade description"
    t.integer "uses", comment: "Number of uses this upgrade provides"
    t.integer "pop", comment: "Population cost"
    t.integer "man", comment: "Manpower cost"
    t.integer "mun", comment: "Munition cost"
    t.integer "fuel", comment: "Fuel cost"
    t.integer "upgrade_slots", comment: "Upgrade slot cost for per model upgrades"
    t.integer "unitwide_upgrade_slots", comment: "Upgrade slot cost for unit wide upgrades"
    t.boolean "is_building", comment: "Is this upgrade a building to be built"
    t.boolean "is_unit_replace", comment: "Does this upgrade replace units data"
    t.string "type", null: false, comment: "Type of Upgrade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "available_units", "companies"
  add_foreign_key "available_units", "units"
  add_foreign_key "available_upgrades", "companies"
  add_foreign_key "available_upgrades", "upgrades"
  add_foreign_key "callin_modifier_allowed_units", "callin_modifiers"
  add_foreign_key "callin_modifier_allowed_units", "units"
  add_foreign_key "callin_modifier_required_units", "callin_modifiers"
  add_foreign_key "callin_modifier_required_units", "units"
  add_foreign_key "companies", "doctrines"
  add_foreign_key "companies", "factions"
  add_foreign_key "companies", "players"
  add_foreign_key "companies", "rulesets"
  add_foreign_key "company_offmaps", "companies"
  add_foreign_key "company_offmaps", "offmaps"
  add_foreign_key "company_resource_bonuses", "companies"
  add_foreign_key "company_resource_bonuses", "resource_bonuses"
  add_foreign_key "company_unlocks", "companies"
  add_foreign_key "company_unlocks", "doctrine_unlocks"
  add_foreign_key "doctrine_unlocks", "doctrines"
  add_foreign_key "doctrine_unlocks", "unlocks"
  add_foreign_key "doctrines", "factions"
  add_foreign_key "restriction_callin_modifiers", "callin_modifiers"
  add_foreign_key "restriction_callin_modifiers", "restrictions"
  add_foreign_key "restriction_offmaps", "offmaps"
  add_foreign_key "restriction_offmaps", "restrictions"
  add_foreign_key "restriction_units", "restrictions"
  add_foreign_key "restriction_units", "rulesets"
  add_foreign_key "restriction_units", "units"
  add_foreign_key "restriction_upgrades", "restrictions"
  add_foreign_key "restriction_upgrades", "rulesets"
  add_foreign_key "restriction_upgrades", "upgrades"
  add_foreign_key "restrictions", "doctrine_unlocks"
  add_foreign_key "restrictions", "doctrines"
  add_foreign_key "restrictions", "factions"
  add_foreign_key "restrictions", "unlocks"
  add_foreign_key "squad_upgrades", "squads"
  add_foreign_key "squad_upgrades", "upgrades"
  add_foreign_key "squads", "available_units"
  add_foreign_key "squads", "companies"
  add_foreign_key "unit_games", "games"
  add_foreign_key "unit_games", "units"
  add_foreign_key "unit_swaps", "units", column: "new_unit_id"
  add_foreign_key "unit_swaps", "units", column: "old_unit_id"
  add_foreign_key "unit_swaps", "unlocks"
end
