class RemoveBinaryFile < ActiveRecord::Migration
  def change
    remove_column :jobs, :idml_file
  end
end
