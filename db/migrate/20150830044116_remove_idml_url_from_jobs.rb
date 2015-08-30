class RemoveIdmlUrlFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :idml_url
  end
end
