require 'bindata'
require 'bindata/ext/string'

module ACTelemetry
  module Formats
    class RTLap < BinData::Record
      int32le :car_identifier_number
      int32le :lap
      string :driver_name, read_length: 100
      string :car_name, read_length: 100
      int32le :time
    end
  end
end
