class CreateSimpleApiKeyEngineApiKeys < ActiveRecord::Migration
  def change
    create_table :simple_api_key_engine_api_keys do |t|
      t.string :token, index: true
      t.datetime :expires_at
      t.string :user_ident
      t.string :user_type
      t.timestamps
      t.index [:user_type, :user_ident], name: :simple_api_key_engine_api_keys_user
    end
  end
end
