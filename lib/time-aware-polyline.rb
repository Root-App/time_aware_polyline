module TimeAwarePolyline
  require 'time'
  def self.encode_time_aware_polyline(gpx_logs)
    _extend_time_aware_polyline(:gpx_logs => gpx_logs)
  end

  def self.decode_time_aware_polyline(polyline)
    gpx_logs = []
    index = 0
    latitude = 0
    longitude = 0
    time_stamp = 0
    while index < polyline.size
      index, latitude_part, longitude_part, time_part = _decode_lat_lng_time_from_polyline(polyline, index)
      latitude += latitude_part
      longitude += longitude_part
      time_stamp += time_part
      gpx_log = _get_gpx_from_decoded(latitude, longitude, time_stamp)
      gpx_logs.push(gpx_log)
    end
    gpx_logs
  end

  def self._get_time_for_polyline(iso_time)
    Time.parse(iso_time).to_i
  end

  def self._get_time_from_polyline(int_representation)
    Time.at(int_representation).utc.strftime("%FT%T%:z") # 2016-07-21T05:43:09+00:00
  end

  def self._get_coordinate_for_polyline(coordinate)
    (coordinate * 100_000.0).round(0).to_i
  end

  def self._get_coordinate_from_polyline(int_representation)
    (int_representation * 1e-05).round(5)
  end

  def self._get_gpx_for_polyline(gpx)
    [_get_coordinate_for_polyline(gpx[0]), _get_coordinate_for_polyline(gpx[1]), _get_time_for_polyline(gpx[2])]
  end

  def self._get_gpx_from_decoded(lat_rep, lon_rep, time_stamp_rep)
    [_get_coordinate_from_polyline(lat_rep), _get_coordinate_from_polyline(lon_rep), _get_time_from_polyline(time_stamp_rep)]
  end

  def self._extend_time_aware_polyline(polyline: "", gpx_logs: nil, last_gpx_log: nil)
    if last_gpx_log.nil?
      last_latitude = 0
      last_longitude = 0
      last_time = 0
    else
      last_latitude, last_longitude, last_time = _get_gpx_for_polyline(last_gpx_log)
    end
    if polyline.nil?
      polyline = ""
    end
    if gpx_logs.nil?
      return polyline
    end

    gpx_logs.each do |gpx_log|
      latitude, longitude, time_stamp = _get_gpx_for_polyline(gpx_log)
      delta_latitude = latitude - last_latitude
      delta_longitude = longitude - last_longitude
      delta_time = time_stamp - last_time

      _add_value_to_polyline(delta_latitude, polyline)
      _add_value_to_polyline(delta_longitude, polyline)
      _add_value_to_polyline(delta_time, polyline)

      last_latitude = latitude
      last_longitude = longitude
      last_time = time_stamp
    end
    polyline
  end

  def self._add_value_to_polyline(value, polyline)
    value = value.negative? ? ~(value << 1) : value << 1
    while value >= 32
      polyline << ((32 | (value & 31)) + 63).chr
      value >>= 5
    end
    polyline << (value + 63).chr
    polyline
  end

  def self._decode_lat_lng_time_from_polyline(polyline, index)
    index, latitude_part = _get_decoded_dimension_from_polyline(polyline, index)
    index, longitude_part = _get_decoded_dimension_from_polyline(polyline, index)
    index, time_part = _get_decoded_dimension_from_polyline(polyline, index)
    [index, latitude_part, longitude_part, time_part]
  end

  def self._get_decoded_dimension_from_polyline(polyline, index)
    result = 1
    shift = 0
    b = nil
    while b.nil? || b >= 31
      b = (polyline[index].ord - 63) - 1
      index += 1
      result += b << shift
      shift += 5
    end
    result = (result & 1).zero? ? result : ~result
    [index, result >> 1]
  end
end
