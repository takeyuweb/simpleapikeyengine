module SimpleApiKeyEngine
  class Authentication < ActiveRecord::Base
    has_many :api_keys, class_name: 'SimpleApiKeyEngine::ApiKey', dependent: :destroy
    store :auth_hash

    class << self
      def auth(request, &block)
        get_provider(request).auth(&block)
      end

      def activate(request, &block)
        authentication = auth(request, &block)
        return nil unless authentication
        authentication.api_keys.create!(provider: authentication.provider,
                                        user_type: authentication.user_type,
                                        user_ident: authentication.user_ident)
      end

      private
      def provider_classes
        ObjectSpace.each_object(Class).select{|klass| klass < SimpleApiKeyEngine::Providers::AbstractProvider}.reject { |klass|
          klass.priority.nil?
        }.sort_by { |klass| klass.priority }
      end

      private
      def get_provider(request)
        provider_class = provider_classes.find do |klass|
          klass.acceptable? request
        end
        raise 'Unknown authentication provider' unless provider_class
        provider_class.new request
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

