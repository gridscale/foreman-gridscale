module FogExtensions
  module Gridscale
    module Server
      extend ActiveSupport::Concern

      attr_accessor :object_uuid

      # def identity_to_s
      #   identity.to_s
      # end

      # def vm_description
      #   flavor.try(:name)
      # end

      # def flavor
      #   requires :flavor_id
      #   @flavor ||= service.flavors.get(flavor_id.to_i)
      # end

      # def flavor_name
      #   requires :flavor
      #   @flavor_name ||= @flavor.try(:name)
      # end

      def image
        # requires :object_uuid
        @server ||= service.servers.all

      end

      def image_name
        @image_name ||= @image.try(:name)
      end

      def region
        requires :object_uuid
        @region ||= service.storages.get(object_uuid)
      end

      # def region_name
      #   requires :region
      #   @region_name ||= @region.try(:name)
      # end

      # def ip_addresses
      #   [ipv4_address, ipv6_address].flatten.select(&:present?)
      # end
      #
      # def state
      #   requires :status
      #   @state ||= status
      # end
    end
  end
end
