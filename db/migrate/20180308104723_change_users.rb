class ChangeUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :birth_year, :integer
    remove_column :users, :birth_month, :integer
    remove_column :users, :birth_day, :integer
    add_column :users, :birthday, :date
  end
end
