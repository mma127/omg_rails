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

ActiveRecord::Schema.define(version: 2023_12_01_053817) do

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

  create_table "available_offmaps", comment: "Offmap availability per company", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "offmap_id"
    t.integer "available", default: 0, null: false, comment: "Number of this offmap available to purchase for the company"
    t.integer "max", default: 0, null: false, comment: "Max number of this offmap that the company can hold"
    t.integer "mun", default: 0, null: false, comment: "Munitions cost of this offmap"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_available_offmaps_on_company_id"
    t.index ["offmap_id"], name: "index_available_offmaps_on_offmap_id"
  end

  create_table "available_units", comment: "Unit availability per company", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "unit_id"
    t.string "type", null: false, comment: "Type of available unit"
    t.integer "available", default: 0, null: false, comment: "Number of this unit available to purchase for the company"
    t.integer "resupply", default: 0, null: false, comment: "Per game resupply"
    t.integer "resupply_max", default: 0, null: false, comment: "How much resupply is available from saved up resupplies, <= company max"
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

  create_table "available_upgrades", comment: "Upgrade availability per company and unit", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "upgrade_id"
    t.bigint "unit_id"
    t.string "type", null: false, comment: "Type of available upgrade"
    t.decimal "pop", null: false, comment: "Calculated pop cost of this upgrade for the company"
    t.integer "man", null: false, comment: "Calculated man cost of this upgrade for the company"
    t.integer "mun", null: false, comment: "Calculated mun cost of this upgrade for the company"
    t.integer "fuel", null: false, comment: "Calculated fuel cost of this upgrade for the company"
    t.integer "uses", comment: "Uses of this upgrade"
    t.integer "max", comment: "Maximum number of this upgrade purchasable by a unit"
    t.integer "upgrade_slots", comment: "Upgrade slot cost for per model upgrades"
    t.integer "unitwide_upgrade_slots", comment: "Upgrade slot cost for unit wide upgrades"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "upgrade_id", "unit_id", "type"], name: "idx_available_upgrade_uniq", unique: true
    t.index ["company_id"], name: "index_available_upgrades_on_company_id"
    t.index ["unit_id"], name: "index_available_upgrades_on_unit_id"
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

