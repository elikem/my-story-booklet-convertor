class Job < ActiveRecord::Base
  validates_uniqueness_of :publication_id
  validates_presence_of :publication_id
end
