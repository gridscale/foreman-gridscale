module FogExtensions
  module Gridscale
    module Server
      extend ActiveSupport::Concern

      attr_accessor :object_uuid, :mac, :server_uuid, :interfaces_attributes, :ipv4_address, :ipv6_address

      def state
        requires :status
        @state ||= status
      end

      def to_s
        name
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

      def ip4_add_in
        x = nil
        if interfaces_attributes != nil
          interfaces_attributes.each do |key, value|

            if value["ipv4_uuid"] !=nil && value["ipv4_uuid"] != ""
              x = service.ips.get(value["ipv4_uuid"])
            end
          end
        end
        x.ip
      end

      def ip6_add_in
        x = nil
        if interfaces_attributes != nil
          interfaces_attributes.each do |key, value|

            if value["ipv6_uuid"] !=nil && value["ipv6_uuid"] != ""
              x = service.ips.get(value["ipv6_uuid"])
            end
          end
        end
        x.ip
      end

      def mac_addr
        :mac
      end

      def select_nic(fog_nics, nic)
        # foreman-xenserver uses fog_nics[0] here, so I'll just copy that for now.
        fog_nics[0]
      end
    end
  end
end
