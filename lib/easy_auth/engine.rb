module EasyAuth
  class Engine < ::Rails::Engine
    isolate_namespace EasyAuth

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    def self.require_dependency(dependency)
      _all_autoload_paths.each do |path|
        file_path = File.join(path, "#{dependency}.rb")
        if File.exist? file_path
          load_or_require file_path
          return
        end
      end

      raise LoadError, "cannot find dependency -- #{dependency}"
    end

    private

    def self.load_or_require(path)
      if load?
        load path
      else
        require path
      end
    end

    def self.load?
      !Rails.configuration.cache_classes
    end

  end
end
