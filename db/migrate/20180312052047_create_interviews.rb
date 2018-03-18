class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.datetime :datetime
      t.string :status

      t.timestamps
    end
  end
end
