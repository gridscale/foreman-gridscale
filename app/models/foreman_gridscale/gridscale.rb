module ForemanGridscale
  class Gridscale < ComputeResource
    alias_attribute  :api_token, :password
    alias_attribute  :user_uuid, :user

    has_one :key_pair, :foreign_key => :compute_resource_id, :dependent => :destroy
    delegate  :to => :client

    # attribute :api_token
    # attribute :user_uuid

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
        :object_uuid => :identity_to_s,
        # :ip => :ipv4_address,
        # :ip6 => :ipv6_address
      )
    end

    def available_servers
      name = client.servers.all['servers']
      server_name_list = []
      name.each do |key, values|
        server_name_list << values['name']
      end
      server_name_list
    end

    def server_power_on(server_uuid)
      client.server_power_on(server_uuid)
    end

    def server_power_off(server_uuid)
      client.server_power_off(server_uuid)
    end

    def server_power_status(server_uuid)
      client.server_power_get(server_uuid)
    end

    def self.model_name
      ComputeResource.model_name
    end

    # def capabilities
    #   [:image]
    # end
    def create_server(payload )
      client.server_create(payload)
    end

    def find_vm_by_uuid(uuid)
      client.servers.get(uuid)
    rescue Fog::Compute::Gridscale::Error
      raise(ActiveRecord::RecordNotFound)
    end

    # def create_vm(args = {})
    #   args['ssh_keys'] = [ssh_key] if ssh_key
    #   args['image'] = args['image_id']
    #   super(args)
    # rescue Fog::Errors::Error => e
    #   logger.error "Unhandled Gridscale error: #{e.class}:#{e.message}\n " + e.backtrace.join("\n ")
    #   raise e
    # end

    def server
      # return [] if api_key.blank?
      client.servers
    end

    def test_connection(options = {})
      super
      errors[:token].empty? && errors[:uuid].empty?
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    rescue Fog::Errors::Error => e
      errors[:base] << e.message
    end

    def storage_get
      @default_region_name ||= client.storages.all
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    end
    # def destroy_vm(uuid)
    #   vm = find_vm_by_uuid(uuid)
    #   vm.delete if vm.present?
    #   true
    # end

    # not supporting update at the moment
    # def update_required?(*)
    #   false
    # end

    def self.provider_friendly_name
      'gridscale'
    end

    def associated_host(vm)
      associate_by('network', [vm.public_ip_address])
    end

    def user_data_supported?
      true
    end

    def servers_get
      obj = client.servers_get
      obj.each do |key, values|
        values.each do |a,b|
          b['name']
        end
      end
    end

    def available_network
      client.networks.all
    end

    def server_delete(object_uuid)
      client.server_delete(object_uuid)
    end

    def server_get(object_uuid)
      @get_server ||= client.server_get(object_uuid)
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    end

    # def client
    #   @client ||= Fog::Compute.new(
    #       :provider => 'gridscale',
    #       :api_token => api_token,#'5a66f6bfc68cab1fb933db0ab8c6480abfe801fabc56995bb8c02f9bb1097957',
    #       :user_uuid => user_uuid#'92a1a269-bca1-43a0-a4b2-8851141f560a'
    #   )
    # end


    private

    # def client
    #   @client ||= Fog::Compute.new(
    #     :provider => 'gridscale',
    #     :api_token =>'5a66f6bfc68cab1fb933db0ab8c6480abfe801fabc56995bb8c02f9bb1097957',
    #     :user_uuid => '92a1a269-bca1-43a0-a4b2-8851141f560a'
    #   )
    # end

    def client
      @client ||= Fog::Compute.new(
          :provider => 'gridscale',
          :api_token => api_token,
          :user_uuid => user_uuid
      )
    end

    def vm_instance_defaults
      super.merge(
        :size => client.servers.all['servers']
      )
    end

    # Creates a new key pair for each new Gridscale compute resource
    # After creating the key, it uploads it to Gridscale
    # def setup_key_pair
    #   public_key, private_key = generate_key
    #   key_name = "foreman-#{id}#{Foreman.uuid}"
    #   client.create_ssh_key key_name, public_key
    #   KeyPair.create! :name => key_name, :compute_resource_id => id, :secret => private_key
    # rescue StandardError => e
    #   logger.warn 'failed to generate key pair'
    #   logger.error e.message
    #   logger.error e.backtrace.join("\n")
    #   destroy_key_pair
    #   raise
    # end

    # def destroy_key_pair
    #   return unless key_pair
    #   logger.info "removing Gridscale key #{key_pair.name}"
    #   client.destroy_ssh_key(ssh_key.id) if ssh_key
    #   key_pair.destroy
    #   true
    # rescue StandardError => e
    #   logger.warn "failed to delete key pair from Gridscale, you might need to cleanup manually : #{e}"
    # end

    # def ssh_key
    #   @ssh_key ||= begin
    #     key = client.list_ssh_keys.data[:body]['ssh_keys'].find { |i| i['name'] == key_pair.name }
    #     key['id'] if key.present?
    #   end
    # end

    # def generate_key
    #   key = OpenSSL::PKey::RSA.new 2048
    #   type = key.ssh_type
    #   data = [key.to_blob].pack('m0')
    #
    #   openssh_format_public_key = "#{type} #{data}"
    #   [openssh_format_public_key, key.to_pem]
    # end
  end
end
