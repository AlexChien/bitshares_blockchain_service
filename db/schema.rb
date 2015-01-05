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

ActiveRecord::Schema.define(version: 20150105165844) do

  create_table "blockchain_block_hashes", force: true do |t|
    t.integer  "block_num"
    t.string   "block_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blockchain_block_hashes", ["block_hash"], name: "index_blockchain_block_hashes_on_block_hash", using: :btree
  add_index "blockchain_block_hashes", ["block_num"], name: "index_blockchain_block_hashes_on_block_num", using: :btree

  create_table "blockchain_blocks", force: true do |t|
    t.integer  "blockchain_block_hash_id"
    t.integer  "block_num"
    t.string   "current"
    t.string   "previous"
    t.datetime "timestamp"
    t.string   "transaction_digest"
    t.string   "next_secret_hash"
    t.string   "previous_secret"
    t.string   "delegate_signature"
    t.string   "user_transaction_ids"
    t.integer  "signee_shares_issued"
    t.integer  "signee_fees_collected"
    t.integer  "signee_fees_destroyed"
    t.string   "random_seed"
    t.integer  "block_size"
    t.integer  "latency",                  limit: 8
    t.integer  "processing_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blockchain_blocks", ["block_num"], name: "index_blockchain_blocks_on_block_num", using: :btree
  add_index "blockchain_blocks", ["previous"], name: "index_blockchain_blocks_on_previous", using: :btree

end
