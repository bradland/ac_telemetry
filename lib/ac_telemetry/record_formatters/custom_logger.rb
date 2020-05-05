require 'ac_telemetry/record_formatters/base'

module ACTelemetry
  module RecordFormatters
    class CustomLogger < Base
      def format(record)
      
        ## gear based logger
#         cols_custom_fmt(record,
#           [
#             :speed_kmh,
#             :lap_time,
#             :gas,
#             :brake,
# #            :engine_rpm,
#             :gear,
# #             :acc_g_horizontal,
# #             :acc_g_frontal,
# 			:lap_count,
# 			:car_position_normalized
#             ],
#             "%0.2f kmh, time: %d, gas: %0.2f, brake: %0.2f, gear: %d, lap: %d, pos: %0.2f") \
#             	if (record.gear > 1)

        ## csv base logger (minimal data)
        cols_custom_fmt(record,
          [
			:car_position_normalized,
            :speed_kmh,
            :lap_time,
            :gas,
            :brake,
#            :engine_rpm,
            :gear,
#             :acc_g_horizontal,
#             :acc_g_frontal,
			:lap_count,
            ],
            "%0.5f;%0.2f;%d;%0.2f;%0.2f;%d;%d") \
            	if (record.gear > 1)

      end
    end
  end
end
