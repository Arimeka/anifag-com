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

ActiveRecord::Schema.define(version: 20151031152015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "dblink"

  create_table "admins", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

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
    t.string   "embed_video",     default: "",    null: false, comment: "Код встраиваемого видео"
    t.string   "source_name",     default: "",    null: false, comment: "Название источника публикации"
    t.boolean  "is_big",          default: false, null: false, comment: "Большой блок"
  end

  create_table "banner_placement_banners", force: :cascade, comment: "Связующая таблица баннеров и плейсментов" do |t|
    t.integer  "banner_id",           null: false, comment: "Внешний ключ для связи с баннером"
    t.integer  "banner_placement_id", null: false, comment: "Внешний ключ для связи с плейсментом"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "banner_placements", force: :cascade, comment: "Места расположения баннеров" do |t|
    t.string   "title",      default: "", null: false, comment: "Название расположения"
    t.string   "selector",   default: "", null: false, comment: "Селектор расположения в коде страницы"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "banners", force: :cascade, comment: "Рекламные баннеры" do |t|
    t.string   "title",                   default: "", null: false, comment: "Название баннера"
    t.string   "content",    limit: 1000, default: "", null: false, comment: "Содержимое баннера"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "categories", force: :cascade, comment: "Категории" do |t|
    t.string   "name",       default: "", null: false, comment: "Название"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "category_articles", force: :cascade, comment: "Связь категорий и публикаций" do |t|
    t.integer  "category_id", null: false, comment: "Внешний ключ для связи с категориями"
    t.integer  "article_id",  null: false, comment: "Внешний ключ для связи с публикациями"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "content_images", force: :cascade do |t|
    t.string   "title",             default: "", null: false, comment: "Название файла"
    t.string   "description",       default: "", null: false, comment: "Описание файла"
    t.integer  "original_height",   default: 0,  null: false, comment: "Высота оригинального изображения"
    t.integer  "original_width",    default: 0,  null: false, comment: "Ширина оригинального изображения"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "gallery_files", force: :cascade, comment: "Файлы галерей" do |t|
    t.string   "title",             default: "", null: false, comment: "Название файла"
    t.string   "description",       default: "", null: false, comment: "Описание файла"
    t.integer  "placement_index",   default: 0,  null: false, comment: "Позиция в галерее"
    t.integer  "article_id",                     null: false, comment: "Связь со статьей, к которой крепятся файлы"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "original_height",   default: 0,  null: false, comment: "Высота оригинального изображения"
    t.integer  "original_width",    default: 0,  null: false, comment: "Ширина оригинального изображения"
  end

  create_table "media_files", force: :cascade, comment: "Медиа-файлы" do |t|
    t.integer  "attachable_id",                  null: false, comment: "Внешний ключ связанной модели"
    t.string   "class_name",        default: "", null: false
    t.string   "file_file_name",    default: "", null: false, comment: "Название файла"
    t.string   "file_content_type", default: "", null: false, comment: "Тип файла"
    t.integer  "file_file_size",    default: 0,  null: false, comment: "Размер файла"
    t.datetime "file_updated_at",                             comment: "Дата загрузки файла"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
