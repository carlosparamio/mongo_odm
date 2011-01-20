require 'uri'

module MongoODM
  class Config
    attr_accessor :database, :host, :port, :username, :password
    attr_accessor :logger, :pool_size

    def initialize(opts = {})
      from_hash opts
      @database ||= 'test'
      @host ||= 'localhost'
      @port || 27017
      @logger ||= Rails.logger  if defined?(Rails)
      @pool_size ||= 1
    end

    def uri=(uri)
      uri = URI.parse(uri)  unless URI === uri
      @database = uri.path.to_s.sub('/', '')
      @host, @port, @username, @password = uri.host, uri.port, uri.user, uri.password
    end

    def from_hash(opts)
      opts = opts.dup.symbolize_keys!

      if opts[:uri].present?
        self.uri = opts[:uri]
      else
        @database, @host, @port, @username, @password = opts.values_at(:database, :host, :port, :username, :password)
        @port &&= Integer(@port)
      end

      @logger ||= opts[:logger]
      @pool_size ||= opts[:pool_size]
    end

    def connection
      opts = { :logger => self.logger, :pool_size => self.pool_size }
      Mongo::Connection.new(self.host, self.port, opts).tap do |conn|
        if self.username || self.password
          conn.add_auth(self.database, self.username, self.password)
          conn.apply_saved_authentication
        end
      end
    end
  end
end
