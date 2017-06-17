require 'ac_telemetry/bin_formats/all'

module ACTelemetry
  class Parser
    include ACTelemetry::BinFormats
    
    # Detects the type of record received from AC based on the size
    def detect(net_record)
      case net_record[:bytesize]
      when 408
        handle_handshake_response(net_record)
      when 328
        handle_rtcarinfo(net_record)
      else
        nil
      end
    end

    def handle_handshake_response(net_record)
      HandshakerResponse.read(net_record[:snap])
    end

    def handle_rtcarinfo(net_record)
      RTCarInfo.read(net_record[:snap])
    end
  end
end
