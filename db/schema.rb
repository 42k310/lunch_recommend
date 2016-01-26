# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151225075347) do

  create_table "actions", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "question_id", null: false
    t.integer  "action_kind", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["user_id", "question_id", "action_kind"], name: "unq_act_on_uid_qid_akd", unique: true

  create_table "answer_histories", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "question_id", null: false
    t.date     "answer_date", null: false
    t.integer  "answer_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_histories", ["user_id", "question_id", "answer_date"], name: "unq_ans_his_on_uid_qid_adt", unique: true

  create_table "matches", force: true do |t|
    t.integer  "shop_id",     null: false
    t.integer  "question_id", null: false
    t.integer  "answer_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["shop_id", "question_id", "answer_type"], name: "unq_mtc_on_uid_qid_atp", unique: true

  create_table "questions", force: true do |t|
    t.string   "title",      limit: 100, null: false
    t.text     "answer1",    limit: 50,  null: false
    t.text     "answer2",    limit: 50,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.string   "tblg_id",    null: false
    t.string   "gnavi_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                           default: "", null: false
    t.integer  "sign_in_count",                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "users",              limit: 1000, default: "", null: false
    t.string   "name",                            default: "", null: false
    t.string   "provider",                        default: "", null: false
    t.string   "uid",                             default: "", null: false
    t.string   "token",                           default: "", null: false
    t.text     "meta",               limit: 1000, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
