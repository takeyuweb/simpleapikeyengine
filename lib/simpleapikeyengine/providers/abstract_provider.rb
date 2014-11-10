module SimpleApiKeyEngine::Providers
  class AbstractProvider
    class << self
      @@priorities = {}
      def priority(val=nil)
        if val.present?
          @@priorities[self] = val
        else
          @@priorities[self]
        end
      end

      def acceptable?(auth_hash)
        raise NotImplementedError
      end

      def decorate_auth_hash(auth_hash)
        auth_hash
      end
    end

    def initialize(params)
      @params = params
    end

    def auth(&block)
      auth_hash = get_auth_hash!
      authentication = ::SimpleApiKeyEngine::Authentication.find_by_provider_and_uid(auth_hash[:provider], auth_hash[:uid])
      unless authentication
        authentication = ::SimpleApiKeyEngine::Authentication.new(provider: auth_hash[:provider],
                                                                  uid: auth_hash[:uid])
        authentication.user = block.call(auth_hash)
      end
      authentication.token = auth_hash[:credentials][:token]
      authentication.auth_hash = auth_hash
      authentication.save!
      return authentication
    end

    def get_auth_hash!
      # {
      #     provider: 'provider_key',
      #     uid: user_info['id'],
      #     credentials: {
      #         token: 'OAuth2Token',
      #         expires_at: expires_at,
      #         expires: expires
      #     },
      #     info: {
      #         email: user_info['email'],
      #         name: user_info['name']
      #     },
      #     extra: {
      #         raw_info: user_info.to_h
      #     }
      # }
      raise NotImplementedError
    end

  end
end
