class Store
  require 'open-uri'
  require 'fileutils'

  def self.published_stories
    stories = Parse.published_stories

    stories.each do |story|
      Job.create(
          story_id: story['story_id'],
          publication_id: story['publication_id'],
          username: story['username'],
          email: story['email']
      )

      Store.new.create_user_folder_and_file(story['username'], story['publication_id'])
    end
  end

  def create_user_folder_and_file(username, publication_id)
    # check if user folder exists and create if it doesn't
    FileUtils.mkdir_p "#{users_folder}/#{username}"

    # download file if it does not exist
    if File.exists? "#{users_folder}/#{username}/#{username}_#{publication_id}.idml"
      puts 'File already exists.'
    else
      puts 'File does not exist.'
      File.open("#{users_folder}/#{username}/#{username}_#{publication_id}.idml", 'wb') do |f|
        f.write(open("http://mystorybooklet.com/api/stories/#{username}/idml").read)
      end
    end
  end

  def users_folder
    "#{Rails.root}/storage/users"
  end
end