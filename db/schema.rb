# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101202092817) do

  create_table "accounts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "business_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "receive_email", :default => false
  end

  create_table "address_books", :force => true do |t|
    t.string   "nick_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_use",     :default => false
    t.integer  "buyer_id"
    t.string   "buyer_type"
  end

  create_table "anonymous_users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "business_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "carts", :force => true do |t|
    t.string   "session_id"
    t.integer  "billing_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cart_type"
    t.integer  "shipping_address_id"
    t.integer  "buyer_id"
    t.string   "buyer_type"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizables", :force => true do |t|
    t.integer  "category_id"
    t.string   "categorized_type"
    t.integer  "categorized_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "format_order"
  end

  create_table "gym_locations", :force => true do |t|
    t.string   "location_name"
    t.string   "phone"
    t.string   "website"
    t.string   "address1"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.integer  "price_id"
    t.integer  "promo_id"
    t.integer  "unit_price_in_cents"
    t.string   "currency"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "billing_later",       :default => false
  end

  create_table "ordered_line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.integer  "price"
    t.string   "promo_discount_type"
    t.integer  "promo_discount_amount_in_cents"
    t.float    "promo_discount_percentage"
    t.integer  "unit_price_in_cents"
    t.string   "product_title"
    t.string   "product_description"
    t.string   "currency"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "total_amount_in_cents"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "status"
    t.string   "order_number"
    t.string   "approval_code"
    t.string   "tracking_number"
    t.integer  "buyer_id"
    t.string   "buyer_type"
    t.string   "session_id"
  end

  create_table "prices", :force => true do |t|
    t.integer  "amount_in_cents"
    t.string   "currency"
    t.string   "product_type"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.string   "name"
    t.string   "discount_type"
    t.integer  "discount_amount_in_cents"
    t.string   "currency"
    t.float    "discount_percentage"
    t.string   "product_type"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "trails", :force => true do |t|
    t.string   "name"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",            :default => false
  end

  create_table "video_formats", :force => true do |t|
    t.string   "sku"
    t.text     "details"
    t.boolean  "is_downloadable"
    t.string   "download_file_name"
    t.string   "download_content_type"
    t.integer  "download_file_size"
    t.datetime "download_updated_at"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cdn_url"
    t.string   "acutrack_sku"
    t.integer  "format_id"
  end

  create_table "video_pack_formats", :force => true do |t|
    t.string   "sku"
    t.text     "details"
    t.integer  "video_pack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "format_id"
    t.boolean  "is_downloadable"
  end

  create_table "video_pack_videos", :id => false, :force => true do |t|
    t.integer "video_pack_id"
    t.integer "video_id"
  end

  create_table "video_packs", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.date     "published_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "purchase_count",     :default => 0
    t.boolean  "is_featured",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count",         :default => 0
  end

  create_table "video_stats", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.date     "published_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "duration_in_seconds", :default => 0
    t.integer  "view_count",          :default => 0
    t.integer  "purchase_count",      :default => 0
    t.boolean  "is_featured",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "demo_url"
    t.boolean  "featured_home",       :default => false
    t.boolean  "is_demo",             :default => false
  end

end
