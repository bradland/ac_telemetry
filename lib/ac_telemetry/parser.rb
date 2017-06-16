require 'ac_telemetry/formats/all'

module ACTelemetry
  class Parser
    include ACTelemetry::Formats
    
    def detect(record)
      case record[:bytesize]
      when 408
        handle_handshake_response(record)
      when 328
        handle_rtcarinfo(record)
      else
        nil
      end
    end

    def handle_handshake_response(record)
      HandshakerResponse.read(record[:snap])
    end

    def handle_rtcarinfo(record)
      RTCarInfo.read(record[:snap])
    end
  end
end
