require 'ac_telemetry/record_formatters/base'

module ACTelemetry
  module RecordFormatters
    class RTCarInfo < Base
      def format(record)
        case record.class.to_s
        when "ACTelemetry::BinFormats::HandshakerResponse"
          "car: %s driver: %s, track: %s, config: %s" % clean_array([record.car_name, record.driver_name, record.track_name, record.track_config])
        when "ACTelemetry::BinFormats::RTCarInfo"
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
        when "ACTelemetry::BinFormats::RTLap"
          record.inspect
        else
          "#{record.class.to_s} :: #{record.inspect}"
        end
      end
    end
  end
end
