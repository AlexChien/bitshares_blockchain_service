class CreateBlockchainBlockHashes < ActiveRecord::Migration
  def change
    create_table :blockchain_block_hashes do |t|
      t.integer :block_num
      t.string :block_hash
      t.timestamps
    end
    
    add_index :blockchain_block_hashes, :block_num
    add_index :blockchain_block_hashes, :block_hash
  end
end
