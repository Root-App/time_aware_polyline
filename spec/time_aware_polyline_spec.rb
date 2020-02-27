require 'spec_helper'

RSpec.describe TimeAwarePolyline do
  let(:encoded_time_aware_polyline) { 'spxsBsdb|Lymo`qvAx@TKvAr@K' }
  let(:geopoints_with_time) do
    [[19.13626, 72.92506, '2016-07-21T05:43:09+00:00'],
     [19.13597, 72.92495, '2016-07-21T05:43:15+00:00'],
     [19.13553, 72.92469, '2016-07-21T05:43:21+00:00']]
  end

  context '.decode_time_aware_polyline' do
    it 'returns no points when called with an empty string' do
      expect(described_class.decode_time_aware_polyline('')).to match_array([])
    end

    it 'decodes time aware polyline' do
      expect(described_class.decode_time_aware_polyline(encoded_time_aware_polyline)).to match_array(geopoints_with_time)
    end
  end

  context '.encode_time_aware_polyline' do
    it 'returns an empty string when no points are passed' do
      expect(described_class.encode_time_aware_polyline([])).to be_empty
    end

    it 'encodes the points into a time_aware_polyline' do
      expect(described_class.encode_time_aware_polyline(geopoints_with_time)).to eq(encoded_time_aware_polyline)
    end
  end
end
