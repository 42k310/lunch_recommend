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

ActiveRecord::Schema.define(version: 20160115092440) do

  create_table "actions", force: true do |t|
    t.integer  "action_kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
    t.integer  "user_id"
  end

  create_table "answer_histories", force: true do |t|
    t.date     "answer_date"
    t.text     "answer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "user_id"
  end

  create_table "matches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_question1"
    t.integer  "shop_question2"
    t.integer  "shop_question3"
    t.integer  "shop_question4"
    t.integer  "shop_question5"
    t.integer  "shop_question6"
    t.integer  "shop_question7"
    t.integer  "shop_id"
  end

  create_table "questions", force: true do |t|
    t.text     "title"
    t.text     "answer1"
    t.text     "answer2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.text     "gnavi_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
