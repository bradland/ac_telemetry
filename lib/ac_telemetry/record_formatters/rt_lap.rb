require 'ac_telemetry/record_formatters/base'

module ACTelemetry
  module RecordFormatters
    class RTLap < Base
      def format(record)
        record.to_binary_s
      end
    end
  end
end
