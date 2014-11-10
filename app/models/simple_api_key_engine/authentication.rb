module SimpleApiKeyEngine
  class Authentication < ActiveRecord::Base
    store :auth_hash

    class << self
      def auth(auth_hash, &block)
        get_provider(auth_hash).auth(&block)
      end

      def activate(auth_hash, &block)
        authentication = auth(auth_hash, &block)
        return nil unless authentication
        SimpleApiKeyEngine::ApiKey.create!(user_type: authentication.user_type,
                                           user_ident: authentication.user_ident)
      end

      private
      def provider_classes
        ObjectSpace.each_object(Class).select{|klass| klass < SimpleApiKeyEngine::Providers::AbstractProvider}.reject { |klass|
          klass.priority.nil?
        }.sort_by { |klass| klass.priority }
      end

      private
      def get_provider(auth_hash)
        provider_class = provider_classes.find do |klass|
          klass.acceptable? auth_hash
        end
        raise 'Unknown authentication provider' unless provider_class
        provider_class.new auth_hash
      end
    end

    def user_class
      Class.const_get(user_type)
    end

    def user=(obj)
      self.user_ident = obj.to_param
      self.user_type = obj.class.name
      @user = obj
    end

  end
end

