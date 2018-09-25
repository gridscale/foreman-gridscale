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


      #
      # def to_s
      #   name
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

      # def image
      #   # requires :object_uuid
      #   @server ||= service.servers.all
      #
      # end
      #
      # def image_name
      #   @image_name ||= @image.try(:name)
      # end
      #
      def ip_adr
        requires :ipaddr_uuid
        @ip_adr ||= service.ips.get(ipaddr_uuid).ip
      end

      # def region_name
      #   requires :region
      #   @region_name ||= @region.try(:name)
      # end

      # def ip_addresses
      #   [ipv4_address, ipv6_address].flatten.select(&:present?)
      # end
      #
      # def interfaces
      #   nics
      # end
      #
      # def select_nic(fog_nics, nic)
      #   nic_attrs = nic.compute_attributes
      #   match =   fog_nics.detect { |fn| fn.network_uuid == nic_attrs['network_uuid'] } # grab any nic on the same network
      #   match
      # end

      def state
        requires :status
        @state ||= status
      end
    end
  end
end
