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

class Job < ActiveRecord::Base
  after_create :notify_slack

  validates_uniqueness_of :publication_id
  validates_presence_of :publication_id

  def notify_slack
    SLACK_NOTIFIER.ping "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Job created for #{self.username}"
  end
end
