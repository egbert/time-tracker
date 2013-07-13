#!/usr/bin/env ruby

Dir.chdir File.dirname __FILE__

require 'singleton'
require './activity'

class StagnationAlarm
  include Singleton

  def wailing?
    Activity.current.nil?
  end

  def sync_desktop
    `osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid #{wailing? ? 'Red' : 'Gray Dark'}.png"'`
    `open 'http://time-tracker.dev/wailing_alarm'` if wailing?
  end
end


StagnationAlarm.instance.sync_desktop
