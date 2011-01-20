module MongoODM
  module Document
    module Timestamps

      extend ActiveSupport::Concern

      included do
        field :created_at, Time
        field :updated_at, Time

        before_save :set_timestamps
      end

      module InstanceMethods
        def set_timestamps
          now = Time.now.utc
          self.created_at ||= now  if self.new_record?
          self.updated_at = now
        end
      end

    end
  end
end

