class Store
  def self.published_stories
    stories = Parse.published_stories

    stories.each do |story|
      Job.create(story_id: story["story_id"],
                 publication_id: story["publication_id"],
                 username: story["username"],
                 email: story["email"]
      )
    end
  end
end