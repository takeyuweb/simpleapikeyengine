require 'spec_helper'

describe SimpleApiKeyEngine::Providers::AbstractProvider do

  class DummyProvider < SimpleApiKeyEngine::Providers::AbstractProvider
    def self.acceptable?(auth_hash)
      false
    end
    def get_auth_hash!
      {
          provider: 'dummy',
          uid: '1234567',
          info: {
              email: 'joe@bloggs.com',
              name: 'Joe Bloggs'
          },
          credentials: {
              token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
              expires_at: 1321747205, # when the access token expires (it always will)
              expires: true
          }
      }
    end
  end

  let(:params) do
    {
        provider: 'dummy',
        hoge: 'fuga'
    }
  end

  let(:auth_hash) do
    DummyProvider.new(params).get_auth_hash!
  end
  describe '#auth' do
    let(:authentication_provider) { DummyProvider.new(params) }
    subject(:auth) do
      authentication_provider.auth do |auth_hash|
        user = auth_user
        user.name = auth_hash[:info][:name]
        user.email = auth_hash[:info][:email]
        user
      end
    end
    let(:auth_user) do
      user = Hash.new
      def user.name; self[:name]; end
      def user.email; self[:email]; end
      user
    end
    context '新しい認証情報のとき' do
      it '認証情報を返すこと' do
        expect(auth).to be_instance_of(SimpleApiKeyEngine::Authentication)
      end
      it '認証情報にOAuth2アクセストークンを記録すること' do
        expect(auth.token).to eq(auth_hash[:credentials][:token])
      end
      it 'ユーザーに名前を設定すること' do
        expect { auth }.to change(auth_user, :name).from(nil).to(auth_hash[:info][:name])
      end
      it 'ユーザーにメールアドレスを設定すること' do
        expect { auth }.to change(auth_user, :email).from(nil).to(auth_hash[:info][:email])
      end
    end
    context '既知（providerとuidの組が存在する）の認証情報のとき' do
      let(:auth_user) { stub_model(User) }
      let(:authentication) { stub_model(SimpleApiKeyEngine::Authentication, user: auth_user) }
      before do
        allow(SimpleApiKeyEngine::Authentication).to receive_messages(find_by_provider_and_uid: authentication)
      end
      it '認証情報を返すこと' do
        expect(auth).to be_instance_of(SimpleApiKeyEngine::Authentication)
      end
      it '認証情報にOAuth2アクセストークンを記録すること' do
        expect(auth.token).to eq(auth_hash[:credentials][:token])
      end
      it 'ユーザーの名前を更新しないこと' do
        expect { auth }.to_not change(auth_user, :name)
      end
      it 'ユーザーのメールアドレスを更新しないこと' do
        expect { auth }.to_not change(auth_user, :email)
      end
    end
  end

end