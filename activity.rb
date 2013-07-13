require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'time_tracker'
)

class Activity < ActiveRecord::Base
  default_scope order('starts_at DESC')
  def self.current
    where(['starts_at < ? AND ends_at > ?', Time.now.strftime('%Y-%m-%d %H:%M'), Time.now.strftime('%Y-%m-%d %H:%M')]).first
  end

  def self.current_or_last
    where(['starts_at < ?', Time.now.strftime('%Y-%m-%d %H:%M')]).first
  end
end
