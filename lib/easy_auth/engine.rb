module EasyAuth
  class Engine < ::Rails::Engine
    isolate_namespace EasyAuth

    initializer 'filter_parameters' do |app|
      app.config.filter_parameters += [:password]
      app.config.filter_parameters.uniq!
    end

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
  end
end
