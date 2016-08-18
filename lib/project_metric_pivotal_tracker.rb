require 'tracker_api'

class ProjectMetricPivotalTracker
  attr_reader :raw_data

  def initialize(credentials, raw_data=nil)
    @project = credentials[:project]
    @client = TrackerApi::Client.new(token: ENV['PIVOTAL_TRACKER_API_TOKEN'])
    @raw_data = raw_data
  end

  def image
    return @image if @image
    refresh unless @raw_data
    calculate_color_lengths
    file_path = File.join(File.dirname(__FILE__), 'svg.erb')
    @image = ERB.new(File.read(file_path)).result(self.send(:binding))
  end

  def refresh
    project = @client.project(@project)
    green, yellow, red, gray = 0, 0, 0, 0
    green += project.stories(with_state: :accepted||:delivered||:finished).size
    yellow += project.stories(with_state: :started).size
    red += project.stories(with_state: :unstarted||:planned).size
    gray += project.stories(with_state: :unscheduled).size
    @raw_data = {done: green, new: yellow, old: red, older: gray, total: green+yellow+red+gray}
  end

  def raw_data= new
    @raw_data = new
    @score = nil
    @image = nil
  end

  def score
    refresh unless @raw_data
    @score ||= (@raw_data[:done] + @raw_data[:new] * 0.5 + @raw_data[:old] * 0.25)/ (@raw_data[:total])
  end

  private
  def calculate_color_lengths
    @total_length = 60
    @total_height = 20
    @green_length = (60*(@raw_data[:done]/@raw_data[:total].to_f)).floor
    @yellow_length = (60*(@raw_data[:new]/@raw_data[:total].to_f)).floor
    @red_length = (60*(@raw_data[:old]/@raw_data[:total].to_f)).floor
    @gray_length = (60*(@raw_data[:older]/@raw_data[:total].to_f)).floor
    pixels_left_over = @total_length - (@green_length+@yellow_length+@red_length+@gray_length)
    sorted_lengths = {:@green_length => @green_length, :@yellow_length => @yellow_length, :@red_length => @red_length, :@gray_length => @gray_length}.sort_by { |k, v| v }
    pixels_left_over.times do |i|
      instance_variable_set(sorted_lengths[i][0], instance_variable_get(sorted_lengths[i][0])+1)
    end
  end
end