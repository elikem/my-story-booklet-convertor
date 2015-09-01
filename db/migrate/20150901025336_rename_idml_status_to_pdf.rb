class RenameIdmlStatusToPdf < ActiveRecord::Migration
  def change
    rename_column :jobs, :idml_status, :pdf_status
  end
end
