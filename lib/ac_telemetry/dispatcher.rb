require 'ac_telemetry/bin_formats/all'
require 'ac_telemetry/record_formatter'
require 'ac_telemetry/record_formatters/all'

module ACTelemetry
  class Dispatcher
    include ACTelemetry::BinFormats

    def initialize
      @record_formatter = ACTelemetry::RecordFormatter.new
    end
    
    def process(net_record)
      bin_record = read(net_record)
    end

    # Reads the net_record blob and returns a BinFormat record
    def read(net_record)
      # Detects the type of record received from AC based on the size
      case net_record[:bytesize]
      when 408
        handle_handshake_response(net_record)
      when 328
        handle_rtcarinfo(net_record)
      when 212
        handle_rtlap(net_record)
      else
        nil
      end
    end

    def handle_handshake_response(net_record)
      @record_formatter.format(HandshakerResponse.read(net_record[:snap]))
    end

    def handle_rtcarinfo(net_record)
      @record_formatter.format(RTCarInfo.read(net_record[:snap]))
    end

    def handle_rtlap(net_record)
      @record_formatter.format(RTLap.read(net_record[:snap]))
    end
  end
end
