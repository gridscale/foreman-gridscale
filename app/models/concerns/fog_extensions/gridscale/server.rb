module FogExtensions
  module Gridscale
    module Server
      extend ActiveSupport::Concern

      attr_accessor :object_uuid

      def identity_j
        identity.to_s
      end

      def current_price
        current_price.to_s
      end

      def create_time
        create_time.to_s
      end

      def memory
        attributes[:memory].gigabytes
      end

      def memory=(mem)
        attributes[:memory] = mem / 1.gigabytes if mem
      end

      def ip_adr
        requires :ipaddr_uuid
        @ip_adr ||= service.ips.get(ipaddr_uuid).ip
      end

      def state
        requires :status
        @state ||= status
      end
    end
  end
end
