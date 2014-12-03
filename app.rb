##cli
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

  def self.intersect(line_1, line_2)
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

# matrix [m - rows, n - columns,]  2 - rows, 3 - column
# 0 1 0
# 0 1 0
class Matrix
  attr_reader :columns_count, :rows_count

  def initialize(matrix)
    if matrix.instance_of?(Array) && matrix.at(0).instance_of?(Array)
      @matrix = matrix
      @rows_count = matrix.count
      @columns_count = matrix[0].count
    end
  end
end

class ServiceMatrix
  def self.random(m = nil, n = nil, lim_from = nil, lim_to = nil)
    r = Random.new
    m = m.nil? || m == 0 ? r.rand(1..10) : m
    n = n.nil? || m == 0 ? r.rand(1..10) : n
    lim_from = lim_from.nil? ? r.rand(-10 .. 0) : lim_from
    lim_to = lim_to.nil? ? r.rand(0 .. 10) : lim_to
    return Matrix.new(Array.new(m){Array.new(n){r.rand(lim_from..lim_to)}})
  end
end


puts "\nTEST: Matrix: creation"
puts '---------------------------------------------'
[
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    [[0, 1, 0], [0, 1, 0]],
].each do |pool|
  matrix = Matrix.new(pool)
  puts pool.inspect
  puts matrix.inspect
end

puts "\nTEST: ServiceMatrix: random Matrix creation"
puts '---------------------------------------------'
[
  [1, 2],
  [2, 1],
  [0, nil],
  [nil, nil],
  [nil, nil, 0, 1],
  [3, 3, 1, 1],
  [3, 3, 0, 1],
].each do |m, n, lim_from, lim_to|
  puts "\nm rows=#{m}, n columns=#{n}, lim_from=#{lim_from}, lim_to=#{lim_to}"
  puts ServiceMatrix.random(m, n, lim_from, lim_to).inspect
end

#Test ServiceLine
puts "\nTEST: ServiceLine: intersection checking"
puts '---------------------------------------------'
[
  [[-2, -1], [8, 4], [4, 5], [6, 3]], #true
  [[-2, -1], [8, 4], [4, 5], [5, 4]], #false
].each do |points|
  print 'Line: ', points.inspect
  puts ServiceLine.intersect(
      Line.new(Point.new(points[0][0], points[0][1]), Point.new(points[1][0], points[1][1])),
      Line.new(Point.new(points[2][0], points[2][1]), Point.new(points[3][0], points[3][1])),
  ).inspect
end
