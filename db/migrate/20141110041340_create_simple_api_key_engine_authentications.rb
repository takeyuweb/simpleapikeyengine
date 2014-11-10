class CreateSimpleApiKeyEngineAuthentications < ActiveRecord::Migration
  def change
    create_table :simple_api_key_engine_authentications do |t|
      t.string :user_ident
      t.string :user_type
      t.string :provider
      t.string :uid
      t.string :token
      t.text :auth_hash
      t.timestamps
      t.index [:user_type, :user_ident], name: :simple_api_key_engine_authentications_user
    end

  end
end
