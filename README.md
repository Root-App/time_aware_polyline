# Time Aware Polyline
​
This gem provides an implementation of the [time aware polyline](https://medium.com/hypertrack/the-missing-dimension-in-geospatial-data-formats-78e6fcb4503d) algorithm. The time aware polyline algorithm extends the [polyline encoding algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm) in order to add support for timestamps.
​
## Encoder
​
```ruby
require 'time-aware-polyline'
​
points = [
  [19.13626, 72.92506, '2016-07-21T05:43:09+00:00'],
  [19.13597, 72.92495, '2016-07-21T05:43:15+00:00'],
  [19.13553, 72.92469, '2016-07-21T05:43:21+00:00']
]
​
TimeAwarePolyline.encode_time_aware_polyline(points)
```
​
## Decoder
​
```ruby
require 'time-aware-polyline'
​
TimeAwarePolyline.decode_time_aware_polyline('spxsBsdb|Lymo`qvAx@TKvAr@K')
```
​
## Related Implementations
- [Python](https://libraries.io/pypi/time_aware_polyline)
- [JavaScript](https://www.npmjs.com/package/time-aware-polyline/v/0.0.2-0)
- [PHP](https://github.com/ranaparth/time-aware-polyline-php)
