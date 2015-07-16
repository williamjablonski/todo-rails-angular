class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.string :summary
      t.string :description
      t.string :priority
      t.integer :user_id
      t.belongs_to :user

      t.timestamps
    end
  end
end
