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

ActiveRecord::Schema.define(version: 20150822101324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade, comment: "Публикации" do |t|
    t.string   "title",           default: "",    null: false, comment: "Заголовок"
    t.text     "content",                                      comment: "Содержимое"
    t.integer  "category_id",                                  comment: "Связь с категорией"
    t.boolean  "is_published",    default: false, null: false, comment: "Опубликовано"
    t.boolean  "is_video",        default: false, null: false, comment: "Основа контента - видео"
    t.boolean  "is_gallery",      default: false, null: false, comment: "Основа контента - галерея"
    t.string   "source",          default: "",    null: false, comment: "Источник публикации"
    t.string   "seo_slug",        default: "",    null: false, comment: "Канонический урл"
    t.string   "seo_keywords",    default: "",    null: false, comment: "Ключевые слова"
    t.string   "seo_description", default: "",    null: false, comment: "SEO-описание"
    t.datetime "published_at",                    null: false, comment: "Дата публикации"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end