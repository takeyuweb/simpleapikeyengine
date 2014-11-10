require "simpleapikeyengine/engine"

module SimpleApiKeyEngine
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= SimpleApiKeyEngine::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "simpleapikeyengine/providers"
