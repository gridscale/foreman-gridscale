module FogExtensions
  module Gridscale
    module Server
      extend ActiveSupport::Concern

      attr_accessor :object_uuid

      def state
        requires :status
        @state ||= status
      end

      def to_s
        name
      end
    end
  end
end
