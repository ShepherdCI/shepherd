class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.belongs_to :target, index: true, polymorphic: true
      t.references :member, index: true, polymorphic: true
      t.string :role

      t.timestamps
    end
  end
end
