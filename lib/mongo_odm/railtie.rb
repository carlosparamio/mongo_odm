module Rails #:nodoc:
  module MongoODM #:nodoc:
    class Railtie < Rails::Railtie #:nodoc:
      initializer 'configure database' do
        config_file = Rails.root.join 'config', 'mongo.yml'
        if config_file.file?
          config = YAML.load( ERB.new( config_file.read ).result )[Rails.env]
          ::MongoODM.config = config  if config.present?
        end
      end
    end
  end
end
