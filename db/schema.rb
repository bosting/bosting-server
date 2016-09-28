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

ActiveRecord::Schema.define(version: 20160928102433) do

  create_table "apache_variations", force: :cascade do |t|
    t.string   "name"
    t.string   "ip"
    t.integer  "apache_version_id"
    t.integer  "php_version_id"
    t.integer  "hosting_server_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["hosting_server_id"], name: "index_apache_variations_on_hosting_server_id"
  end

  create_table "hosting_servers", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "fqdn",                     null: false
    t.string   "server_domain",            null: false
    t.string   "panel_domain",             null: false
    t.boolean  "panel_ssl",                null: false
    t.string   "cp_login",                 null: false
    t.string   "cp_password",              null: false
    t.string   "services_ips",             null: false
    t.integer  "cores",                    null: false
    t.boolean  "forward_agent",            null: false
    t.string   "ext_if",                   null: false
    t.string   "int_if",                   null: false
    t.string   "open_tcp_ports"
    t.string   "open_udp_ports"
    t.integer  "os_id",                    null: false
    t.integer  "mysql_distrib_id"
    t.string   "mysql_version"
    t.string   "mysql_root_password",      null: false
    t.string   "default_mx",               null: false
    t.integer  "mail_delivery_method_id",  null: false
    t.string   "ns1_domain",               null: false
    t.string   "ns1_ip",                   null: false
    t.string   "ns2_domain",               null: false
    t.string   "ns2_ip",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ssh_ip_connect"
    t.integer  "ssh_port_connect"
    t.string   "ssh_password"
    t.string   "ssh_listen_ips"
    t.string   "ssh_port_listen"
    t.integer  "ssh_permit_root_login_id"
  end

  create_table "smtp_settings", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "value",             null: false
    t.integer  "hosting_server_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["hosting_server_id"], name: "index_smtp_settings_on_hosting_server_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
