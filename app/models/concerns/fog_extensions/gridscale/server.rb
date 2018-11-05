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
      # def ip_addresses
      #   [ipv4_address, ipv6_address]
      # end

      def interfaces
        relations['networks'].first
      end

      def reset
        reboot
      end

      def vm_description
        format(_('%{cpus} CPUs and %{ram} memory'), :cpus => cores, :ram => memory)
      end

      def ip_addresses
        [ipv4_address, ipv6_address].flatten.select(&:present?)
      end

      # def mac
      #   if relations['networks'] and relations['networks'] != []
      #     if relations['networks'].first
      #       if relations['networks'].first['mac'] != nil
      #         relations['networks'].first['mac']
      #       else
      #         nil
      #       end
      #     end
      #   end
      # end

    end
  end
end
