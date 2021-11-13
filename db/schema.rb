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

ActiveRecord::Schema.define(version: 2021_11_13_221946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "players", comment: "Player record", force: :cascade do |t|
    t.string "name", comment: "Player screen name"
    t.text "open_id", comment: "Player open id token"
    t.text "avatar_url", comment: "Player avatar url"
    t.datetime "last_active_at", comment: "Last active timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "doctrines", "factions"
end
