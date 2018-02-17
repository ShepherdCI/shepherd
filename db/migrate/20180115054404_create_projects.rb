class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.integer :github_id,          null:  false
      t.string  :name,               null:  false

      t.belongs_to :parent_project
      t.belongs_to :owner, index: true, polymorphic: true

      t.timestamps
    end
  end
end
