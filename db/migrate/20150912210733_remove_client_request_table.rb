class RemoveClientRequestTable < ActiveRecord::Migration
  def change
    drop_table :client_requests
  end
end
