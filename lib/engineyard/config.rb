module EY
  class Config
    CONFIG_FILE = "cloud.yml"

    def initialize(file=CONFIG_FILE)
      @config = YAML.load_file(file)
    end

    def method_missing(meth, *args, &blk)
      key = meth.to_s.downcase
      if @config.key?(key)
        @config[key]
      else
        super
      end
    end

    def respond_to?(meth)
      key = meth.to_s.downcase
      @config.key?(key) || super
    end

    def default_environment
      environments.detect do |name, env|
        env["default"]
      end.first
    end

    def default_branch(environment = default_environment)
      environments[environment]["branch"]
    end
  end
end