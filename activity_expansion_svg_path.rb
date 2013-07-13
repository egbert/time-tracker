class ActivityExpansionSvgPath

  def initialize time_from, time_to
    @time_from = time_from
    @time_to = time_to
  end

  def path
    "M25,25 L#{angle_to_point start_angle} A25,25 0 #{sweep_arc},1 #{angle_to_point end_angle} z"
  end

  def angle_to_point a
    [(25 + (25 * Math.sin(a))), (25 + (25 * (Math.cos(a) * -1)))].join ','
  end

  def start_angle
    minute_to_angle @time_from.min
  end

  def end_angle
    minute_to_angle @time_to.min
  end

  def round_point point
    (point * 100000).floor / 100000
  end

  def angle
    minute_to_angle Time.at(@time_to - @time_from).min
  end

  def sweep_arc
    angle > Math::PI ? 1 : 0
  end

  def minute_to_angle minute
    (minute.to_f / 60) * (2 * Math::PI)
  end

end
