require 'ac_telemetry/record_formatters/base'

module ACTelemetry
  module RecordFormatters
    class RTCarInfo < Base
      def format(record)
        ### Col group with custom formatter
        # cols_custom_fmt(record, 
        #                 [:speed_mph, 
        #                 :is_abs_enabled, 
        #                 :is_abs_in_action, 
        #                 :is_tc_enabled, 
        #                 :is_engine_limiter_on, 
        #                 :acc_g_vertical, 
        #                 :acc_g_horizontal, 
        #                 :acc_g_frontal],
        #                 "speed: %0.2f abs: %d[%d] tc: %d lim: %d vG: %+0.2f hG: %+0.2f fG: %+0.2f")
        # cols_custom_fmt(record, 
        #                 [:speed_mph, :lap_time, :last_lap], 
        #                 "speed: %+0.2f lap time: %07d last lap: %07d")

        # Full throttle logger
        cols_custom_fmt(record,
          [:lap_time,
            :gas,
            :speed_mph,
            :engine_rpm,
            :gear,
            :acc_g_horizontal,
            :acc_g_frontal],
            "%d,%0.2f,%0.2f,%0.2f,%d,%0.2f,%0.2f") if record.gas == 1.0

        # Raw output
        # record.to_binary_s
        # record.to_s

        ### Col group with unified formatter
        # cols_single_fmt(record,[:gas, 
        #         :brake, 
        #         :clutch, 
        #         :engine_rpm,
        #         :steer],
        #         "%+0.2f")
        
        ### Ad hoc formatters
        # "identifier: %s" % record.identifier.unpack('C'*4).inspect
        # "flags: #{record.flags.to_binary_s.inspect}"
        # "cg_height: %+0.4f" % record.cg_height.inspect
        # "struct_size: #{record.struct_size.inspect}"
        # struct_inspect record, :identifier
      end
    end
  end
end
