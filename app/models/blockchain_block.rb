class BlockchainBlock < ActiveRecord::Base
  belongs_to :blockchain_block_hash
  
  def self.init_blocks(init_count=nil)
    config = Rails.configuration.database_configuration[Rails.env]
    BitShares::API.init(config["rpc_port"], config["rpc_username"], config["rpc_password"])

    max_block_num = BlockchainBlockHash.maximum(:block_num).to_i

    init_count ||= BitShares::API::Blockchain.get_block_count - max_block_num
    
    for i in (max_block_num+1)..(max_block_num+init_count)
      block_hash = BitShares::API::Blockchain.get_block_hash(i)
      block = BitShares::API::Blockchain.get_block(i)
      
      block_hash_count = BlockchainBlockHash.where(:block_num=>i).count

      if block_hash_count == 0
        ActiveRecord::Base.transaction do
          blockchain_block_hash = BlockchainBlockHash.create(:block_num=>i,
                                                             :block_hash=>block_hash)
          
          BlockchainBlock.create(:blockchain_block_hash=>blockchain_block_hash,
                                 :block_num=>block["block_num"],
                                 :current=>block_hash,
                                 :previous=>block["previous"],
                                 :timestamp=>block["timestamp"],
                                 :transaction_digest=>block["transaction_digest"],
                                 :next_secret_hash=>block["next_secret_hash"],
                                 :previous_secret=>block["previous_secret"],
                                 :delegate_signature=>block["delegate_signature"],
                                 :user_transaction_ids=>block["user_transaction_ids"],
                                 :signee_shares_issued=>block["signee_shares_issued"],
                                 :signee_fees_collected=>block["signee_fees_collected"],
                                 :signee_fees_destroyed=>block["signee_fees_destroyed"],
                                 :random_seed=>block["random_seed"],
                                 :block_size=>block["block_size"],
                                 :latency=>block["latency"],
                                 :processing_time=>block["processing_time"]
                                 )  
        end
      end
    end
  end
  
  def self.truncate_blocks
    BlockchainBlockHash.connection.execute("truncate table blockchain_block_hashes;")
    BlockchainBlock.connection.execute("truncate table blockchain_blocks;")
  end
end
