class ChangeUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :birthday, :date
    add_column :users, :birth_year, :integer
    add_column :users, :birth_month, :integer
    add_column :users, :birth_day, :integer
  end
end
