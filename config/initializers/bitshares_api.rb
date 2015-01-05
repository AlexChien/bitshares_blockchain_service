require 'net/http'
require 'uri'
require 'json'

module BitShares
  class API

    @@rpc_instance = nil

    def self.init(port, username, password, options = nil)
      options ||= { ignore_errors: false }
      @@rpc_instance = BitShares::API::Rpc.new(port, username, password, options)
    end

    def self.rpc
      @@rpc_instance
    end

    class Wallet
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("wallet_" + name.to_s, params)
      end
    end

    class Network
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("network_" + name.to_s, params)
      end
    end

    class Blockchain
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("blockchain_" + name.to_s, params)
      end
    end
    
    class Mail
      def self.method_missing(name, *params)
        BitShares::API::rpc.request("mail_" + name.to_s, params)
      end
    end

    class Misc
      def self.method_missing(name, *params)
        BitShares::API::rpc.request(name.to_s, params)
      end
    end

    class Rpc

      class Error < RuntimeError; end

      attr_accessor :ignore_errors, :echo_off

      def initialize(port, username, password, options)
        host = Rails.configuration.database_configuration[Rails.env]["host"]
        @uri = URI("http://#{host}:#{port}/rpc")
        @req = Net::HTTP::Post.new(@uri)
        @req.content_type = 'application/json'
        @req.basic_auth username, password
        @options = options
        @logger = options[:logger]
        @instance_name = options[:instance_name]
        @ignore_errors = options[:ignore_errors]
        @echo_off = false
      end

      def log(s)
        return if @echo_off
        if @logger then @logger.info s else puts s end
      end
      
      def request(method, params = nil)
        params = params || []
        # log "[#{@instance_name}] request: #{method} #{params.join(' ')}"
        result = nil
        Net::HTTP.start(@uri.hostname, @uri.port) do |http|
          @req.body = { method: method, params: params, id: 0 }.to_json
          response = http.request(@req)
          result = JSON.parse(response.body)
          if result['error']
            log "error: #{result['error']}"
            unless @ignore_errors
              raise Error, JSON.pretty_generate(result['error']), "#{method} #{params ? params.join(' ') : ''}"
            else
              STDERR.puts JSON.pretty_generate(result['error'])
            end
          else
            # log 'ok'
          end
        end
        return result['result']
      end

    end

  end

end
