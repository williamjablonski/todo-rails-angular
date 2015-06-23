class AddDueDateToSubTasks < ActiveRecord::Migration
  def change
    add_column :sub_tasks, :due_date, :date
  end
end
