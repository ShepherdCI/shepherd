# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180207185836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.string "target_type"
    t.bigint "target_id"
    t.string "member_type"
    t.bigint "member_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_type", "member_id"], name: "index_memberships_on_member_type_and_member_id"
    t.index ["target_type", "target_id"], name: "index_memberships_on_target_type_and_target_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.integer "github_id", null: false
    t.string "github_login", null: false
    t.string "name"
    t.string "avatar_url"
    t.string "description"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "github_webhook_id"
    t.string "github_webhook_secret"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "github_id", null: false
    t.string "name", null: false
    t.bigint "parent_project_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "github_webhook_id"
    t.string "github_webhook_secret"
    t.string "full_name"
    t.index ["owner_type", "owner_id"], name: "index_projects_on_owner_type_and_owner_id"
    t.index ["parent_project_id"], name: "index_projects_on_parent_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "github_id", null: false
    t.string "github_login", null: false
    t.string "avatar_url"
    t.string "name"
    t.string "github_token"
    t.text "github_token_scopes"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
    t.index ["github_login"], name: "index_users_on_github_login", unique: true
  end

end
