# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 20) do

  create_table "attachments", :force => true do |t|
    t.column "attachable_id",   :integer
    t.column "attachable_type", :string
    t.column "photo_id",        :integer
    t.column "position",        :integer, :default => 1
  end

  create_table "bookings", :force => true do |t|
    t.column "performance_id", :integer
    t.column "name",           :string
    t.column "phone",          :string
    t.column "email",          :string
    t.column "waged",          :integer, :default => 2
    t.column "unwaged",        :integer, :default => 0
    t.column "notify_me",      :boolean
    t.column "confirmed",      :boolean, :default => false
    t.column "comments",       :text
  end

  create_table "events", :force => true do |t|
    t.column "title",       :string
    t.column "description", :text
    t.column "location",    :string
    t.column "starts_at",   :datetime
  end

  create_table "members", :force => true do |t|
    t.column "first_name",                :string
    t.column "last_name",                 :string
    t.column "email",                     :string
    t.column "type",                      :string
    t.column "login",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "last_login_at",             :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "visits_count",              :integer,                :default => 0
    t.column "time_zone",                 :string,                 :default => "Etc/UTC"
  end

  create_table "performances", :force => true do |t|
    t.column "time",          :datetime
    t.column "show_id",       :integer
    t.column "bookings_open", :boolean,  :default => true
  end

  create_table "photos", :force => true do |t|
    t.column "title",        :string
    t.column "description",  :text
    t.column "tags",         :string
    t.column "filename",     :string
    t.column "content_type", :string
    t.column "size",         :integer
    t.column "width",        :integer
    t.column "height",       :integer
    t.column "parent_id",    :integer
    t.column "thumbnail",    :string
    t.column "created_at",   :datetime
  end

  create_table "posts", :force => true do |t|
    t.column "user_id",    :integer
    t.column "title",      :string
    t.column "body",       :text
    t.column "more",       :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink",  :string
  end

  create_table "reviews", :force => true do |t|
    t.column "show_id",     :integer
    t.column "title",       :string
    t.column "publication", :string
    t.column "reviewer",    :string
    t.column "date",        :date
    t.column "body",        :text
    t.column "more",        :text
    t.column "pullquote",   :text
  end

  create_table "roles", :force => true do |t|
    t.column "member_id", :integer
    t.column "show_id",   :integer
    t.column "position",  :integer, :default => 0
    t.column "type",      :string
    t.column "role",      :string
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shows", :force => true do |t|
    t.column "name",           :string,                                              :default => "",    :null => false
    t.column "permalink",      :string,                                              :default => "",    :null => false
    t.column "year",           :integer
    t.column "month",          :integer
    t.column "description",    :text
    t.column "is_current",     :boolean
    t.column "splash_page",    :text
    t.column "created_at",     :datetime
    t.column "updated_at",     :datetime
    t.column "waged_price",    :integer,  :limit => 2, :precision => 2, :scale => 0
    t.column "unwaged_price",  :integer,  :limit => 2, :precision => 2, :scale => 0
    t.column "venue_id",       :integer
    t.column "author",         :string
    t.column "bookings_open",  :boolean,                                             :default => false
    t.column "booking_email",  :string
    t.column "auto_cutoff",    :integer,                                             :default => 3
    t.column "parent_id",      :integer
    t.column "position",       :integer,                                             :default => 1
    t.column "children_count", :integer,                                             :default => 0
  end

  add_index "shows", ["venue_id"], :name => "fk_venue_id"

  create_table "venues", :force => true do |t|
    t.column "name",        :string
    t.column "description", :text
    t.column "address",     :text
    t.column "latitude",    :decimal, :precision => 20, :scale => 16
    t.column "longitude",   :decimal, :precision => 20, :scale => 16
  end

end
