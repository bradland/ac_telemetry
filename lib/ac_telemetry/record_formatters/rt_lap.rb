require 'ac_telemetry/record_formatters/base'
require 'ap'

module ACTelemetry
  module RecordFormatters
    class RTLap < Base
      def format(record)
        "car id: %s, lap: %d driver: %s, car: %s, time: %0.3f" % clean_array([record.car_identifier_number, record.lap, record.driver_name, record.car_name, record.time.to_f/1000])
      end
    end
  end
end
