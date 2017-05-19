require 'faraday'
require 'json'

class ProjectMetricPivotalTracker
  attr_reader :raw_data

  def initialize(credentials, raw_data=nil)
    @project = credentials[:tracker_project]
    @conn = Faraday.new(url: 'https://www.pivotaltracker.com/services/v5')
    @conn.headers['Content-Type'] = 'application/json'
    @conn.headers['X-TrackerToken'] = credentials[:tracker_token]
    @raw_data = raw_data
  end

  def image
    return @image if @image
    refresh unless @raw_data
    {:chartType => 'pivotal_tracker',
     :titleText => 'Stories',
     :data => @raw_data
    }.to_json
  end

  def refresh
    @raw_data = stories.map &:to_h
  end

  def raw_data=(new_data)
    @raw_data = new_data
    @score = nil
    @image = nil
  end

  def score
    refresh unless @raw_data
    @score = @raw_data.length
  end
  
  def self.credentials
    ['tracker_project', 'tracker_token']
  end

  private

  def project
    JSON.parse(
        @conn.get("projects/#{@project}").body
    )
  end

  def stories
    JSON.parse(
        @conn.get("projects/#{@project}/stories").body
    )
  end
end
