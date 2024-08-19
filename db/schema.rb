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

ActiveRecord::Schema[7.1].define(version: 2024_08_19_075512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.boolean "is_private"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "hash_id"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.bigint "requestor_id"
    t.bigint "receiver_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["receiver_id"], name: "index_friend_requests_on_receiver_id"
    t.index ["requestor_id", "receiver_id"], name: "index_friend_requests_on_requestor_id_and_receiver_id", unique: true
    t.index ["requestor_id"], name: "index_friend_requests_on_requestor_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "friend_a_id"
    t.bigint "friend_b_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["friend_a_id", "friend_b_id"], name: "index_friendships_on_friend_a_id_and_friend_b_id", unique: true
    t.index ["friend_a_id"], name: "index_friendships_on_friend_a_id"
    t.index ["friend_b_id"], name: "index_friendships_on_friend_b_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.string "color"
    t.bigint "board_id"
    t.boolean "is_private", default: true
    t.boolean "bluried", default: false
    t.string "hash_id"
    t.index ["board_id"], name: "index_logs_on_board_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "log_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["log_id"], name: "index_taggings_on_log_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "user_boards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "board_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["board_id"], name: "index_user_boards_on_board_id"
    t.index ["user_id", "board_id"], name: "index_user_boards_on_user_id_and_board_id", unique: true
    t.index ["user_id"], name: "index_user_boards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "photo"
    t.string "profile_picture"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boards", "users"
  add_foreign_key "friend_requests", "users", column: "receiver_id"
  add_foreign_key "friend_requests", "users", column: "requestor_id"
  add_foreign_key "friendships", "users", column: "friend_a_id"
  add_foreign_key "friendships", "users", column: "friend_b_id"
  add_foreign_key "logs", "boards"
  add_foreign_key "logs", "users"
  add_foreign_key "taggings", "logs"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_boards", "boards"
  add_foreign_key "user_boards", "users"
end
