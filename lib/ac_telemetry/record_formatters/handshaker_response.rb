require 'ac_telemetry/record_formatters/base'

module ACTelemetry
  module RecordFormatters
    class HandshakerResponse < Base
      def format(record)
        "car: %s driver: %s, track: %s, config: %s" % clean_array([record.car_name, record.driver_name, record.track_name, record.track_config])
      end
    end
  end
end
