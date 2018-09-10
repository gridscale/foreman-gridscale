require 'fast_gettext'
require 'gettext_i18n_rails'

module ForemanGridscale
  class Engine < ::Rails::Engine
    engine_name 'foreman_gridscale'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman_gridscale.register_gettext', :after => :load_config_initializers do
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_gridscale'

      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer 'foreman_gridscale.register_plugin', :before => :finisher_hook do
      Foreman::Plugin.register :foreman_gridscale do
        requires_foreman '>= 1.16'
        compute_resource ForemanGridscale::Gridscale
        parameter_filter ComputeResource, :api_token, :user_uuid
      end
    end

    rake_tasks do
      load "#{ForemanGridscale::Engine.root}/lib/foreman_gridscale/tasks/test.rake"
    end

    config.to_prepare do
      require 'fog/gridscale'
      require 'fog/compute/gridscale'
      require 'fog/compute/gridscale/models/storage'
      require 'fog/compute/gridscale/models/server'

      Fog::Compute::Gridscale::Storage.send :include,
                                             FogExtensions::Gridscale::Storage
      Fog::Compute::Gridscale::Server.send :include,
                                              FogExtensions::Gridscale::Server
      ::Host::Managed.send :include,
                           ForemanGridscale::Concerns::HostManagedExtensions
    end
  end
end
