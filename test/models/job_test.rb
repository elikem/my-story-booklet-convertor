# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  story_id       :integer
#  username       :string
#  email          :string
#  status         :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  email_status   :boolean          default(FALSE)
#  pdf_status     :boolean          default(FALSE)
#  publication_id :string
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
