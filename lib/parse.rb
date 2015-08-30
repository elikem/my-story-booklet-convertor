class Parse
  def self.published_stories
    HTTParty.get('http://mystorybooklet.com/api/published_stories')
  end

  def self.story_for_idml(username)
    HTTParty.get("http://mystorybooklet.com/api/stories/#{username}/idml")
  end
end

# HTTParty.get('http://example.com', headers: {"User-Agent" => APPLICATION_NAME})
