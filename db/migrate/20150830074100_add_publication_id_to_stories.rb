class AddPublicationIdToStories < ActiveRecord::Migration
  def change
    add_column :jobs, :publication_id, :string
  end
end
