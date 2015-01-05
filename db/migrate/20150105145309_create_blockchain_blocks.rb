class CreateBlockchainBlocks < ActiveRecord::Migration
  def change
    create_table :blockchain_blocks do |t|
      t.integer :blockchain_block_hash_id
      t.integer :block_num
      t.string :current
      t.string :previous
      t.datetime :timestamp
      t.string :transaction_digest
      t.string :next_secret_hash
      t.string :previous_secret
      t.string :delegate_signature
      t.string :user_transaction_ids
      t.integer :signee_shares_issued
      t.integer :signee_fees_collected
      t.integer :signee_fees_destroyed
      t.string :random_seed
      t.integer :block_size
      t.column :latency, 'bigint'
      t.integer :processing_time
      t.timestamps
    end
    
    add_index :blockchain_blocks, :block_num
    add_index :blockchain_blocks, :previous
  end
end
