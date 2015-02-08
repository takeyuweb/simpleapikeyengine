class AddExpiresAtToSimpleApiKeyEngineAuthentications < ActiveRecord::Migration
  def change
    change_table :simple_api_key_engine_authentications do |t|
      t.datetime :expires_at
    end
  end
end
