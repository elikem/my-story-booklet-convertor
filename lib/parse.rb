class Parse
  def self.published_stories
    HTTParty.get('http://mystorybooklet.com/api/published_stories')
  end
end

# HTTParty.get('http://example.com', headers: {"User-Agent" => APPLICATION_NAME})
