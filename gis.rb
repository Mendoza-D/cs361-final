#!/usr/bin/env ruby

class Track
  def initialize(segments, name=nil)
    @name = name
    @segments = segments.map { |s| TrackSegment.new(s) }
    end

    def to_geojson
      {
        "type": "Feature",
        "properties": {title: @name}.compact,
        "geometry": {
          "type": "LineString",
          "coordinates": @segments.map(&:coordinates_as_array) }
      }
    end
  end

class TrackSegment
  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end

  def coordinates_as_array
    @coordinates.map { |c| [c.lon, c.lat, c.ele].compact }
  end
end

class Point
  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end
end

class Waypoint
attr_reader :lat, :lon, :ele, :name, :type

  def initialize(lon, lat, ele=nil, name=nil, type=nil)
    @lat = lat
    @lon = lon
    @ele = ele
    @name = name
    @type = type
  end

  def to_geojson
    {
      "type": "Feature",
      geometry: {
        "type": "Point",
        "coordinates": [@lon, @lat, @ele].compact
      },
      "properties": {
        title: @name,
        type: @type
      }.compact
    }
  end
end

class World
def initialize(name, things)
  @name = name
  @features = things
end
  def add_feature(f)
    @features.append(t)
  end

  def to_geojson
    {
      "type": "FeatureCollection",
      "features": @features.map(&:to_geojson)
    }
  end
end

def main()
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
  
  ts1 = [
  Point.new(-122, 45),
  Point.new(-122, 46),
  Point.new(-121, 46),
  ]

  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]

  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5),
  ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()
end

if File.identical?(__FILE__, $0)
  main()
end

