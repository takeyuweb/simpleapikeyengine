class AddProviderToSimpleApiKeyEngineApiKeys < ActiveRecord::Migration
  def change
    change_table :simple_api_key_engine_api_keys do |t|
      t.string :provider
    end
  end
end
