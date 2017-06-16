require 'bindata'
require 'bindata/ext/string'

module ACTelemetry
  module Formats
      class RTCarInfo < BinData::Record
        string :identifier, read_length: 4, trim_padding: true
        int32le :rt_size
        float_le :speed_kmh
        float_le :speed_mph
        float_le :speed_ms
        int8 :is_abs_enabled
        int8 :is_abs_in_action
        int8 :is_tc_in_action
        int8 :is_tc_enabled
        int8 :is_in_pit
        int8 :is_engine_limiter_on
        float_le :acc_g_vertical
        float_le :acc_g_horizontal
        float_le :acc_g_frontal
        int32le :lap_time
        int32le :last_lap
        int32le :best_lap
        int32le :lap_count
        float_le :gas
        float_le :brake
        float_le :clutch
        float_le :engine_rpm
        float_le :steer
        int32le :gear
        float_le :cg_height
        float_le :wheel_angular_speed
        float_le :slip_angle
        float_le :slip_angle_contact_patch
        float_le :slip_ratio
        float_le :tyre_slip
        float_le :nd_slip
        float_le :load
        float_le :dy
        float_le :mz
        float_le :tyre_dirty_level
        float_le :camber_rad
        float_le :tyre_radius
        float_le :tyre_loaded_radius
        float_le :suspension_height
        float_le :car_position_normalized
        float_le :car_slope
        float_le :car_coordinates
      end
  end
end
