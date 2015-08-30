class Parse
  def self.published_stories
    HTTParty.get('http://mystorybooklet.com/api/published_stories')
  end

  def self.stories_from(user)
    HTTParty.get('http://mystorybooklet.com/api/stories/user')
  end
end