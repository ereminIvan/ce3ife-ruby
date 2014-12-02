class Point
  attr_reader :x_pos,:y_pos

  def initialize(x_coordinate, y_coordinate)
    @x_pos = x_coordinate.to_f.round 2
    @y_pos = y_coordinate.to_f.round 2
  end
end

class Line
  attr_reader :start_point, :end_point

  def initialize(start_point, end_point)
    if start_point.instance_of?(Point) && end_point.instance_of?(Point)
      @start_point  = start_point
      @end_point    = end_point
    else
      raise Exception.new('Invalid arguments passed as start_point or end_point #0')
    end
  end
end

class ServiceLine
  # attr_reader :intersect

  def intersect(line_1, line_2)
    a1 = line_1.start_point
    a2 = line_1.end_point
    b1 = line_2.start_point
    b2 = line_2.end_point

    d = (a1.x_pos - a2.x_pos) * (b2.y_pos - b1.y_pos) - (a1.y_pos - a2.y_pos) * (b2.x_pos - b1.x_pos)
    da = (a1.x_pos - b1.x_pos) * (b2.y_pos - b1.y_pos) - (a1.y_pos - b1.y_pos) * (b2.x_pos - b1.x_pos)
    db = (a1.x_pos - a2.x_pos) * (a1.y_pos - b1.y_pos) - (a1.y_pos - a2.y_pos) * (a1.x_pos - b1.x_pos)

    #Parallels
    # if d.abs < 0.00001
    #   @intersect = nil
    # end
    ta = da/d
    tb = db/d
    if 0 <= ta && ta <= 1 && 0 <= tb && tb <= 1
      result = Point.new(a1.x_pos + ta * (a2.x_pos - a1.x_pos),a1.y_pos + ta * (a2.y_pos - a1.y_pos))
    else
      result = false
    end
  end
end

#Test ServiceLine
check_lines = [
  [[-2, -1], [8, 4], [4, 5], [6, 3]], #true
  [[-2, -1], [8, 4], [4, 5], [5, 4]], #false
]

check_lines.each do |points|
  puts ServiceLine.new.intersect(
      Line.new(Point.new(points[0][0], points[0][1]), Point.new(points[1][0], points[1][1])),
      Line.new(Point.new(points[2][0], points[2][1]), Point.new(points[3][0], points[3][1])),
  )
end
