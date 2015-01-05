class BlockchainBlockHash < ActiveRecord::Base
  has_one :blockchain_block, :dependent => :nullify
  
  scope :next_block_hash, lambda {|block_num| where("block_num > ?",block_num).order("block_num ASC") }
  scope :prev_block_hash, lambda {|block_num| where("block_num < ?",block_num).order("block_num DESC") }
  
  def valid_hash?
    config = Rails.configuration.database_configuration[Rails.env]
    BitShares::API.init(config["rpc_port"], config["rpc_username"], config["rpc_password"])
    
    self.block_hash == BitShares::API::Blockchain.get_block_hash(self.block_num)
  end
  
  def valid_hash_and_destroy
    self.destroy if BlockchainBlockHash.last == self && self.valid_hash? == false
  end
  
  def self.rollback_hash
    loop {
      if self.last
        break unless self.last.valid_hash_and_destroy
      else
        break
      end
    }
  end
end
