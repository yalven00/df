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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130412162533) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.integer  "member_id"
    t.string   "address1"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "phone"
    t.float    "lat"
    t.float    "lng"
    t.string   "address2"
  end

  add_index "addresses", ["member_id"], :name => "index_addresses_on_member_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "children", :force => true do |t|
    t.datetime "dob"
    t.string   "gender"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "children", ["member_id"], :name => "index_children_on_member_id"

  create_table "content_pages", :force => true do |t|
    t.string   "title"
    t.string   "nav_title"
    t.string   "path"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coreg_optin_params", :force => true do |t|
    t.integer "coreg_optin_id"
    t.string  "name"
    t.text    "value"
  end

  add_index "coreg_optin_params", ["coreg_optin_id"], :name => "index_coreg_optin_params_on_coreg_optin_id"

  create_table "coreg_optins", :force => true do |t|
    t.integer  "coreg_id"
    t.integer  "member_id"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taken"
    t.string   "hashcode"
    t.boolean  "success"
    t.text     "params"
    t.boolean  "sent"
    t.string   "email"
  end

  add_index "coreg_optins", ["created_at"], :name => "index_coreg_optins_on_created_at"
  add_index "coreg_optins", ["email"], :name => "index_coreg_optins_on_email"
  add_index "coreg_optins", ["hashcode"], :name => "index_coreg_optins_on_hashcode"
  add_index "coreg_optins", ["member_id"], :name => "index_coreg_optins_on_member_id"

  create_table "coreg_params", :force => true do |t|
    t.integer  "coreg_id"
    t.string   "name"
    t.string   "label",           :limit => 512
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_type"
    t.boolean  "required"
    t.string   "data_type"
    t.integer  "min_length"
    t.string   "match"
    t.text     "select_options"
    t.string   "select_prompt"
    t.text     "value"
    t.boolean  "display",                        :default => false, :null => false
    t.integer  "sequence"
    t.integer  "dependent_id"
    t.string   "dependent_value"
    t.integer  "group_id"
    t.integer  "flatfile_width"
  end

  create_table "coregs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "taken_default"
    t.text     "description"
    t.string   "image"
    t.string   "screen_key"
    t.text     "prompt"
    t.string   "endpoint"
    t.text     "css_snippet"
    t.string   "success_regex"
    t.float    "revenue",          :default => 0.0
    t.string   "request_method",   :default => "post"
    t.text     "acceptance"
    t.string   "coreg_type",       :default => "compact"
    t.string   "flatfile_pattern"
    t.string   "email_field"
    t.string   "run_days"
    t.string   "time_delay"
    t.datetime "expires_on"
    t.string   "endpoint2"
    t.string   "endpoint2_delay"
    t.boolean  "opt_out"
    t.string   "headers"
  end

  add_index "coregs", ["coreg_type"], :name => "index_coregs_on_coreg_type"
  add_index "coregs", ["screen_key"], :name => "index_coregs_on_screen_key"

  create_table "eway_messages", :force => true do |t|
    t.integer "member_id"
    t.string  "message"
    t.string  "result"
  end

  create_table "living_social_cities", :force => true do |t|
    t.integer  "city_id"
    t.string   "displayName"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postal_code"
    t.string   "salt"
    t.string   "ip_address"
    t.string   "gender",           :default => "F"
    t.integer  "partner_id",       :default => 0
    t.datetime "dob"
    t.string   "original_email"
    t.string   "affiliate_id"
    t.string   "affiliate_sub_id"
    t.string   "entrypath"
  end

  add_index "members", ["created_at", "partner_id"], :name => "index_members_on_created_at_and_partner_id"
  add_index "members", ["email"], :name => "index_members_on_email"
  add_index "members", ["partner_id"], :name => "index_members_on_partner_id"

  create_table "page_coregs", :force => true do |t|
    t.integer  "coreg_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "css_snippet"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", :force => true do |t|
    t.string   "hashcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address"
    t.string   "affiliate_id"
    t.string   "affiliate_sub_id"
  end

  add_index "requests", ["created_at"], :name => "index_requests_on_created_at"
  add_index "requests", ["hashcode"], :name => "index_requests_on_hashcode"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "country"
  end

  create_table "unsubscribes", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
