require 'ac_telemetry/bin_formats/all'
require 'ac_telemetry/record_formatters/all'
require 'ac_telemetry/record_formatters/custom_logger'

module ACTelemetry
  class RecordFormatter
    include ACTelemetry::RecordFormatters

    def initialize
      @handshaker_response = HandshakerResponse.new
      @rt_car_info = CustomLogger.new
      @rt_lap = RTLap.new
    end

    def format(record)
      case record
      when ACTelemetry::BinFormats::HandshakerResponse
        @handshaker_response.format(record)
      when ACTelemetry::BinFormats::RTCarInfo
        @rt_car_info.format(record)
      when ACTelemetry::BinFormats::RTLap
        @rt_lap.format(record)
      end
    end
  end
end