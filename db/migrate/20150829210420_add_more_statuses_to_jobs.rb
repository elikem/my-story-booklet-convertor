class AddMoreStatusesToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :email_status, :boolean, default: false
    add_column :jobs, :idml_status, :boolean, default: false

    change_column :jobs, :status, :boolean, default: false
  end
end
