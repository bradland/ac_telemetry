require 'bindata'
require 'bindata/ext/string'

module ACTelemetry
  module Formats
    class HandshakerResponse < BinData::Record
      string :car_name, read_length: 100
      string :driver_name, read_length: 100
      int32le :identifier
      int32le :version
      string :track_name, read_length: 100
      string :track_config, read_length: 100
    end
  end
end
