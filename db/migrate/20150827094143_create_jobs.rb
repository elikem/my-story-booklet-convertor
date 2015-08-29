class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :story_id
      t.string :username
      t.string :email
      t.string :idml_url
      t.boolean :status

      t.timestamps null: false
    end
  end
end
