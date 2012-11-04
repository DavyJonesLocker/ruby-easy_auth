module EasyAuth
  class SetupGenerator < Rails::Generators::Base
    def copy_initializer
      source_paths << File.expand_path('../../templates/easy_auth', __FILE__)
      copy_file 'initializer.rb', 'config/initializers/easy_auth.rb'
    end

    private

    def self.installation_message
      'Copies initializer into config/initializers'
    end

    desc installation_message
  end
end
