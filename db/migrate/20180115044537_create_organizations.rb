class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.integer :github_id, null: false
      t.string :github_login, null: false

      t.string :name
      t.string :avatar_url
      t.string :description
      t.string :company

      t.timestamps
    end
  end
end
