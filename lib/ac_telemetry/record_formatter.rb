module ACTelemetry
  class RecordFormatter
    DELIM = '%'.encode('UTF-16LE')

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

        ### Col group with unified formatter
        # cols_single_fmt(record,[:gas, 
        #         :brake, 
        #         :clutch, 
        #         :engine_rpm,
        #         :steer],
        #         "%+0.2f")
        
        ### Ad hoc formatters
        # "identifier: %s" % record.identifier.unpack('C'*4).inspect
        # "identifier: #{record.identifier.to_binary_s.inspect}"
        # "cg_height: %+0.4f" % record.cg_height.inspect
        "struct_size: #{record.struct_size.inspect}"
        # struct_inspect record, :identifier
      when "ACTelemetry::BinFormats::RTLap"
        record.inspect
      else
        "#{record.class.to_s} :: #{record.inspect}"
      end
    end

    def struct_inspect(record, col)
      "#{col.to_s}: #{record.send(col).inspect.gsub('{',"{\n").gsub(", ",", \n")}"
    end

    def cols_custom_fmt(record, cols, fmt_string)
      vals = cols.map { |c| record.send(c) }
      fmt_string % vals
    end

    def cols_single_fmt(record, cols, fmt)
      vals = cols.map{ |c| record.send(c) }
      fmt_string = cols.map { |c| "#{c.to_s} #{fmt}" }.join(' ')
      fmt_string % vals
    end

    def clean(str)
      str[0,str.index(DELIM)].encode('UTF-8', invalid: :replace, replace: '?')
    end

    def clean_array(array)
      array.map do |i|
        if i.respond_to? :encode
          clean(i)
        else
          i
        end
      end
    end
  end
end