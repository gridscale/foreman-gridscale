module ForemanGridscale
  class Gridscale < ComputeResource
    alias_attribute  :api_token, :password
    alias_attribute  :user_uuid, :user
    alias_attribute  :object_uuid, :uuid

    has_one :key_pair, :foreign_key => :compute_resource_id, :dependent => :destroy
    delegate  :to => :client

    validates :api_token, :user_uuid, :presence => true
    before_create :test_connection


    def api_token
      attrs[:api_token]

    end

    def user_uuid
      attrs[:user_uuid]
    end

    def api_token=(api_token)
      attrs[:api_token] = api_token
    end

    def user_uuid=(user_uuid)
      attrs[:user_uuid] = user_uuid
    end


    def to_label
      "#{name} (#{provider_friendly_name})"
    end

    def provided_attributes
      super.merge(
        :uuid => :server_uuid,
      )
    end

    def get_ip
      client.ips.get(ipaddr_uuid).ip
    end

    def capabilities
      [:build]
    end


    def create_vm(args = {})
      args['cores'] = args['cores'].to_i
      args['memory'] = args['memory'].to_i
      args['storage'] = args['storage'].to_i
      super(args)
    rescue Fog::Errors::Error => e
      logger.error "Unhandled DigitalOcean error: #{e.class}:#{e.message}\n " + e.backtrace.join("\n ")
      raise e
    end


    def new_interface(attr = {})
      client.interfaces.new attr
    end

    def power_check(uuid)
      client.server_power_get(uuid).body['power']
    end

    def power_off(uuid)
      client.server_power_off(uuid)  if power_check(uuid)
    end

    def destroy_vm(uuid)
      attached_storage = []

      client.servers.get(uuid).relations['storages'].each do |storage|
        attached_storage << storage['object_uuid']
      end

      if power_check(uuid)
        client.server_power_off(uuid)
      end

      sleep(1) until  client.servers.get(uuid).status != "in-provisioning"
      find_vm_by_uuid(uuid).destroy
      sleep(1) until client.servers.get(uuid) == nil

      attached_storage.each do |storage_uuid|
        client.storage_delete(storage_uuid)
      end
    rescue ActiveRecord::RecordNotFound
      # if the VM does not exists, we don't really care.
      true
    end

    def save_vm(uuid, attr)
      vm = find_vm_by_uuid(uuid)
      vm.attributes.merge!(attr.symbolize_keys).deep_symbolize_keys
      update_interfaces(vm, attr[:interfaces_attributes])
      vm.interfaces
      vm.save
    end

    def ips
      client.ips
    end

    def interfaces
      client.interfaces rescue []
    end

    def networks
      client.networks rescue []
    end
    #
    def network
      client.networks.get(network_uuid)
    end

    def storages
      client.storages
    end

    def self.model_name
      ComputeResource.model_name
    end

    def find_vm_by_uuid(uuid)
      client.servers.get(uuid)
    rescue Fog::Compute::Gridscale::Error
      raise(ActiveRecord::RecordNotFound)
    end

    def test_connection(options = {})
      super
      errors[:token].empty? && errors[:uuid].empty?
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    rescue Fog::Errors::Error => e
      errors[:base] << e.message
    end

    def default_region_name
      @default_region_name ||= 'de/fra'
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    end

    def self.provider_friendly_name
      'gridscale'
    end

    def user_data_supported?
      true
    end

    private

    def client
      @client ||= Fog::Compute.new(
        :provider => 'gridscale',
        :api_token => api_token,
        :user_uuid => user_uuid
      )
    end

    def vm_instance_defaults
      super.merge(
        :location_uuid => '45ed677b-3702-4b36-be2a-a2eab9827950'
      )
    end


  end
end
