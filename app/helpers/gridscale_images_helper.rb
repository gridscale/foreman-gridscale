module GridscaleImagesHelper
  def gridscale_server_field(f)
    images = @compute_resource.available_servers
    images.each { |image| image.name = image.id if image.name.nil? }
    select_f f, :uuid, images.to_a.sort_by(&:full_name),
             :id, :full_name, {}, :label => _('Image')
  end
  #
  # def select_image(f, compute_resource)
  #   images = possible_images(compute_resource, nil, nil)
  #
  #   select_f(f,
  #            :object_uuid,
  #            images,
  #            :id,
  #            :slug,
  #            { :include_blank => images.empty? || images.size == 1 ? false : _('Please select an image') },
  #            { :label => 'Image', :disabled => images.empty? })
  # end

  def select_server(compute_resource)
    compute_resource.servers_get_yo
    # compute_resource.servers_get['servers'].each do |key, values|
    #   values
    # end
    # server.each do |key, values|
      # key
      # pp 'hello'
      # pp values['name']
    # end
    #     .each do |key|
    #   key['name']
    # end
    # server
    # select_f(f,
    #          :server,
    #          servers,
    #          :object_uuid,
    #          :object_uuid,
    #          {},
    #          :label => 'server',
    #          :disabled => compute_resource.servers_get.empty?)
  end
end
