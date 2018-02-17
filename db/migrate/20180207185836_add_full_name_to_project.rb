class AddFullNameToProject < ActiveRecord::Migration[5.1]
  def change
    change_table :projects do |t|
      t.string :full_name
    end
  end
end
