# frozen_string_literal: true
class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :github_id,     null:  false
      t.string :github_login,  null:  false

      t.string :avatar_url
      t.string :name

      t.string :github_token
      t.text :github_token_scopes

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users,  :github_id,     unique:  true
    add_index :users,  :github_login,  unique:  true
  end
end
