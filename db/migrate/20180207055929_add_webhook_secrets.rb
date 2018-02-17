class AddWebhookSecrets < ActiveRecord::Migration[5.1]
  def change
    change_table :projects do |t|
      t.string :github_webhook_id
      t.string :github_webhook_secret
    end

    change_table :organizations do |t|
      t.string :github_webhook_id
      t.string :github_webhook_secret
    end
  end
end
