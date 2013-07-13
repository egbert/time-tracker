require './stagnation_alarm'
require 'minitest/autorun'

describe StagnationAlarm do

  describe 'when asked about its wailing state' do
    describe 'when there isn\'t an activity at the time' do
      it 'must repsond positively' do
        Activity.stub :current, Activity.new do
          StagnationAlarm.instance.wailing?.must_equal false
        end
      end
    end

    describe 'when there is an activity at the time' do
      it 'must respond negatively' do
        Activity.stub :current, nil do
          StagnationAlarm.instance.wailing?.must_equal true
        end
      end
    end
  end

end
