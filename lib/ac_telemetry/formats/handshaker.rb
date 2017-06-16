require 'bindata'

module ACTelemetry
  module Formats
    class Handshaker < BinData::Record
      int32le :identifier
      int32le :version
      int32le :operation_id
    end
  end
end
