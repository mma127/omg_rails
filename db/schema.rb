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

ActiveRecord::Schema.define(version: 2021_11_20_233644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", comment: "Company name"
    t.bigint "player_id"
    t.bigint "doctrine_id"
    t.bigint "faction_id"
    t.integer "vps_earned", comment: "VPs earned by this company"
    t.integer "man", comment: "Manpower available to this company"
    t.integer "mun", comment: "Munitions available to this company"
    t.integer "fuel", comment: "Fuel available to this company"
    t.integer "pop", comment: "Population cost of this company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id"], name: "index_companies_on_doctrine_id"
    t.index ["faction_id"], name: "index_companies_on_faction_id"
    t.index ["player_id"], name: "index_companies_on_player_id"
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
    t.bigint "unlock_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_unlocks_on_company_id"
    t.index ["unlock_id"], name: "index_company_unlocks_on_unlock_id"
  end

  create_table "doctrine_unlocks", comment: "Associates doctrines to unlocks", force: :cascade do |t|
    t.bigint "doctrine_id"
    t.bigint "unlock_id"
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
    t.string "name", comment: "Raw name"
    t.string "display_name", comment: "Display name"
    t.string "const_name", comment: "Doctrine CONST name for battlefile"
    t.string "internal_name", comment: "Name for internal code use, may not be needed"
    t.bigint "faction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["faction_id"], name: "index_doctrines_on_faction_id"
  end

  create_table "factions", comment: "Game factions", force: :cascade do |t|
    t.string "name", comment: "Raw name"
    t.string "display_name", comment: "Display name"
    t.string "const_name", comment: "Faction CONST name for battlefile"
    t.string "internal_name", comment: "Name for internal code use, may not be needed"
    t.string "side", comment: "Allied or Axis side"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "offmaps", force: :cascade do |t|
    t.string "name", comment: "Offmap name"
    t.string "const_name", comment: "Offmap const name for battlefile"
    t.bigint "restriction_id"
    t.integer "mun", comment: "Munitions cost"
    t.integer "max", comment: "Maximum number purchasable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restriction_id"], name: "index_offmaps_on_restriction_id"
  end

  create_table "players", comment: "Player record", force: :cascade do |t|
    t.string "name", comment: "Player screen name"
    t.text "open_id", comment: "Player open id token"
    t.text "avatar_url", comment: "Player avatar url"
    t.datetime "last_active_at", comment: "Last active timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resource_bonuses", force: :cascade do |t|
    t.string "name", comment: "Resource bonus name"
    t.string "type", comment: "Resource type"
    t.integer "value", comment: "Bonus amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restrictions", force: :cascade do |t|
    t.string "name", comment: "Restriction name"
    t.text "description", comment: "Restriction description"
    t.bigint "faction_id"
    t.bigint "doctrine_id"
    t.bigint "unlock_id"
    t.integer "vet_requirement", comment: "Minimum veterancy requirement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id"], name: "index_restrictions_on_doctrine_id"
    t.index ["faction_id"], name: "index_restrictions_on_faction_id"
    t.index ["unlock_id"], name: "index_restrictions_on_unlock_id"
  end

  create_table "unit_modifications", comment: "Changes unit attributes from faction, doctrine, unlock", force: :cascade do |t|
    t.bigint "unit_id"
    t.bigint "faction_id"
    t.bigint "doctrine_id"
    t.bigint "unlock_id"
    t.string "const_name", comment: "Replacement const name for the unit used by the battle file"
    t.integer "pop", comment: "Modified population cost"
    t.integer "man", comment: "Modified manpower cost"
    t.integer "mun", comment: "Modified munition cost"
    t.integer "fuel", comment: "Modified fuel cost"
    t.integer "resupply", comment: "Modified resupply per game"
    t.integer "company_max", comment: "Modified company max"
    t.integer "upgrade_slots", comment: "Modified number of slots available for per model weapon upgrades"
    t.integer "unitwide_upgrade_slots", comment: "Modified number of slots available for unit wide weapon replacements"
    t.boolean "is_airdrop", comment: "Replacement flag for whether the unit can airdrop"
    t.boolean "is_infiltrate", comment: "Replacement flag for whether the unit can infiltrate"
    t.decimal "callin_modifier", comment: "Replaces base callin modifier if not 1"
    t.string "type", comment: "Type of modification"
    t.integer "priority", comment: "Priority order to apply the modification from 1 -> 100"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["doctrine_id"], name: "index_unit_modifications_on_doctrine_id"
    t.index ["faction_id"], name: "index_unit_modifications_on_faction_id"
    t.index ["unit_id"], name: "index_unit_modifications_on_unit_id"
    t.index ["unlock_id"], name: "index_unit_modifications_on_unlock_id"
  end

  create_table "units", comment: "Metadata for a unit", force: :cascade do |t|
    t.string "const_name", comment: "Const name of the unit for the battle file"
    t.string "display_name", comment: "Display name"
    t.text "description", comment: "Display description of the unit"
    t.integer "pop", comment: "Population cost"
    t.integer "man", comment: "Manpower cost"
    t.integer "mun", comment: "Munition cost"
    t.integer "fuel", comment: "Fuel cost"
    t.integer "resupply", comment: "Per game resupply"
    t.integer "resupply_max", comment: "How much resupply is available from saved up resupplies, <= company max"
    t.integer "company_max", comment: "Maximum number of the unit a company can hold"
    t.integer "upgrade_slots", comment: "Slots used for per model weapon upgrades"
    t.integer "unitwide_upgrade_slots", comment: "Unit wide weapon replacement slot"
    t.boolean "is_airdrop", comment: "Is this unit airdroppable?"
    t.boolean "is_infiltrate", comment: "Is this unit able to infiltrate?"
    t.string "retreat_name", comment: "Name for retreating unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unlocks", comment: "Metadata for a generic doctrine ability", force: :cascade do |t|
    t.string "const_name", comment: "Const name of the doctrine ability for the battle file"
    t.text "description", comment: "Display description of this doctrine ability"
    t.string "image_path", comment: "Url to the image to show for this doctrine ability"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "companies", "doctrines"
  add_foreign_key "companies", "factions"
  add_foreign_key "companies", "players"
  add_foreign_key "company_offmaps", "companies"
  add_foreign_key "company_offmaps", "offmaps"
  add_foreign_key "company_resource_bonuses", "companies"
  add_foreign_key "company_resource_bonuses", "resource_bonuses"
  add_foreign_key "company_unlocks", "companies"
  add_foreign_key "company_unlocks", "unlocks"
  add_foreign_key "doctrine_unlocks", "doctrines"
  add_foreign_key "doctrine_unlocks", "unlocks"
  add_foreign_key "doctrines", "factions"
  add_foreign_key "offmaps", "restrictions"
  add_foreign_key "restrictions", "doctrines"
  add_foreign_key "restrictions", "factions"
  add_foreign_key "restrictions", "unlocks"
  add_foreign_key "unit_modifications", "doctrines"
  add_foreign_key "unit_modifications", "factions"
  add_foreign_key "unit_modifications", "units"
  add_foreign_key "unit_modifications", "unlocks"
end
