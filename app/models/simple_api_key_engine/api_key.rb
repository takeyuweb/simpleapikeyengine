module SimpleApiKeyEngine
  class ApiKey < ActiveRecord::Base
    before_create :generate_token
    before_create :set_expiration

    def self.activate(token)
      api_key = where(token: token).first
      return api_key && !api_key.expired? ? api_key : nil
    end

    def user_class
      Class.const_get(user_type)
    end

    def user=(obj)
      self.user_ident = obj.to_param
      self.user_type = obj.class.name
      @user = obj
    end

    def expired?
      Time.current >= expires_at
    end

    private
    def generate_token
      begin
        self.token = SecureRandom.hex
      end while self.class.exists?(token: token)
    end

    def set_expiration
      self.expires_at = Time.current + 30.days
    end

  end
end
