require 'rubygems'
require 'bundler'
Bundler.require

require './activity'
require './stagnation_alarm'
require './activity_expansion_svg_path'

class Time
  def ceil(seconds = 60)
    Time.at((self.to_f / seconds).ceil * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
end

get '/' do
  # StagnationAlarm.instance.sync_desktop
  @activities = Activity.all
  slim :index
end

get '/wailing_alarm' do
  @current_activity = Activity.current_or_last
  slim :wailing_alarm
end

post '/wailing_alarm' do
  if params[:create_new]
    activity = Activity.new description: params[:description], starts_at: params[:starts_at], ends_at: params[:ends_at]
    Activity.where(["ends_at > ?", activity.starts_at]).first.try :update_attribute, 'ends_at', activity.starts_at
    activity.save
  else
    activity = Activity.find params[:activity_id]
    activity.ends_at = params[:expand_to]
    activity.save
  end
  StagnationAlarm.instance.sync_desktop
  slim :close_window
end

helpers do
  def possible_expansions
    [
      Time.now.ceil(5.minutes),
      (Time.now + 5.minutes).ceil(5.minutes),
      (Time.now + 10.minutes).ceil(5.minutes),
      (Time.now + 15.minutes).ceil(15.minutes),
      (Time.now + 30.minutes).ceil(15.minutes),
    ].uniq
  end

  def possible_start_times
    {
      "After last (#{Activity.current_or_last.ends_at.strftime '%H:%M'})" => Activity.current_or_last.ends_at,
      "Now (#{Time.now.strftime '%H:%M'})" => Time.now,
    }.merge([
        Time.now.floor(5.minutes),
        (Time.now - 5.minutes).floor(5.minutes),
        (Time.now - 10.minutes).floor(5.minutes),
        (Time.now - 15.minutes).floor(15.minutes),
        (Time.now - 30.minutes).floor(15.minutes)
    ].inject({}) do |m, t|
      m[t.strftime '%H;%M'] = t
      m
    end)
  end

  def activity_expansion_svg_path time
    ActivityExpansionSvgPath.new(Time.now, time).path
  end
end
