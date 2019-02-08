module GridscaleImagesHelper
  def gridscale_server_field(f)
    images = @compute_resource.available_servers
    images.each { |image| image.name = image.id if image.name.nil? }
    select_f f, :uuid, images.to_a.sort_by(&:full_name),
             :id, :full_name, {}, :label => _('Image')
  end

  def select_ipv4(f, compute_resource)
    addresses = Array.new
    compute_resource.ips.each do |ip|
       if ip.relations['servers'].empty? and ip.relations['loadbalancers'].empty? and ip.family ==4 and ip.failover = false
         addresses << ip
       end
     end
    if addresses.empty?
      "No IPs available"
    else
      select_f(f,
               :ipv4_uuid,
               addresses,
               :object_uuid,
               :ip,
               { :include_blank => true },
               { :label => 'IP Address 4'})
    end
  end

  def select_ipv6(f, compute_resource)
    addresses = Array.new
    compute_resource.ips.each do |ip|
      if ip.relations['servers'].empty? and ip.relations['loadbalancers'].empty? and ip.family ==6 and ip.failover = false
        addresses << ip
      end
    end
    if addresses.empty?
      "No IPs available"
    else
      select_f(f,
               :ipv6_uuid,
               addresses,
               :object_uuid,
               :ip,
               { :include_blank => true },
               { :label => 'IP Address 6'})
    end
  end

  def select_network(f, compute_resource)
    networks_list = Array.new
    compute_resource.networks.each do |network|
      networks_list << network
    end

    select_f(f,
             :network_uuid,
             networks_list,
             :object_uuid,
             :name,
             { :include_blank => true },
             { :label => 'Network'})

  end



  def select_storage(f, compute_resource)

    storages_list = Array.new

    compute_resource.storages.each do |storage|
      if storage.relations['servers'].empty?
        storages_list << storage
      end
    end

    if storages_list.empty?
      "No storage available"
    else
      select_f(f,
               :storage_uuid,
               storages_list,
               :object_uuid,
               :name,
               { :include_blank => true },
               { :label => 'available storage'})
    end
  end

  def select_template(f, compute_resource)
    template_list = Array.new
    compute_resource.templates.each do |template|
      template_list << template
    end

    select_f(f,
             :template_uuid,
             template_list,
             :object_uuid,
             :name,
             { :include_blank => true },
             { :label => 'Template'})

  end

  def select_sshkey(f, compute_resource)
    template_list = Array.new
    compute_resource.sshkeys.each do |template|
      template_list << template
    end

    select_f(f,
             :sshkey_uuid,
             template_list,
             :object_uuid,
             :name,
             { :include_blank => true },
             { :label => 'SSH Key'})

  end

  def select_isoimage(f, compute_resource)
    template_list = Array.new
    compute_resource.isoimages.each do |isoimage|
      template_list << isoimage
    end

    select_f(f,
             :isoimage_uuid,
             template_list,
             :object_uuid,
             :name,
             { :include_blank => true },
             { :label => 'Iso-image'})

  end

  def gridscale_image_field(f)
    images = @compute_resource.available_templates
    images.each { |image| image.name = image.object_uuid if image.name.nil? }
    select_f f, :object_uuid, images.to_a,
             :object_uuid, :name, {}, :label => _('Image')
  end
end
