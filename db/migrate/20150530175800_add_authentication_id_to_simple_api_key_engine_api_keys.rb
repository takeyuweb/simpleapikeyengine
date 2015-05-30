class AddAuthenticationIdToSimpleApiKeyEngineApiKeys < ActiveRecord::Migration
  def change
    change_table :simple_api_key_engine_api_keys do |t|
      t.references :authentication
    end
  end
end
