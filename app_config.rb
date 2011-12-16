require 'yaml'

module AppConfig
  class << self
    attr_accessor :path
    
    def dirs
      @dirs ||= YAML.load_file(path) rescue Hash.new
    end
    
    %w[source_dir target_dir second_target_dir].each do |method|
      define_method method do
        dirs[method]
      end
    end
    
    def save(source_dir, target_dir, second_target_dir)
      config = {
        'source_dir' => dir_for(source_dir),
        'target_dir' => dir_for(target_dir),
        'second_target_dir' => dir_for(second_target_dir),
        :path => path
      }
      File.open(path, 'w') do |file|
        YAML.dump config, file
      end
    end
    
    private
    
    def dir_for(dir)
      dir.blank? ? nil : dir
    end
  end
end