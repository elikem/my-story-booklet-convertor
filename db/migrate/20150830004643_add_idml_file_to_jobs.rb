class AddIdmlFileToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :idml_file, :binary
  end
end
