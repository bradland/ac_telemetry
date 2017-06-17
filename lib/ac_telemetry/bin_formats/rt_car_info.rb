require 'bindata'
require 'bindata/ext/string'

module ACTelemetry
  module BinFormats
    class RTCarInfo < BinData::Record
      endian :little

      # Unknown identifier. Always outputs "a\x00O\x00"
      string :identifier, read_length: 4

      # Size of the struct in bytes
      int32le :struct_size

      float :speed_kmh
      float :speed_mph
      float :speed_ms

      # The docs say there are six, 1-byte bools here. There are eight.
      int8 :is_abs_enabled
      int8 :is_abs_in_action
      int8 :is_tc_in_action
      int8 :is_tc_enabled
      int8 :is_in_pit
      int8 :is_engine_limiter_on
      string :flags, read_length: 2

      # Accelerative force (g) in each orientation relative to the car
      float :acc_g_vertical
      float :acc_g_horizontal
      float :acc_g_frontal

      # Lap timing in 1/1000ths of a second
      uint32le :lap_time
      uint32le :last_lap
      uint32le :best_lap

      # Lap count: 0, 1, 2, etc
      uint32le :lap_count

      # Value representing the state of each input 0 being none, and 1 being max
      float :gas
      float :brake
      float :clutch

      # Engine RPM
      float :engine_rpm

      # Steering input angle in degrees (zero, center; negative, left; positive, right)
      float :steer

      # Selected gear (zero based): reverse 0, first 2, second 3, etc
      uint32le :gear

      # Height (fro the ground) of center of gravity in meters
      float :cg_height

      # Structs containing 4 wheels are in orientation
      #
      # 1  2
      #
      # 3  4

      # Wheel rotational speed in RPM
      struct :wheel_angular_speed do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Slip angle; difference in angle the tyre is pointed, versus the direction it is rolling
      struct :slip_angle do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ???
      # Unsure; always outputs zero
      struct :slip_angle_contact_patch do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Slip ratio; difference in the rotation of the tyre versus the actual forward/rearward motion of the car
      struct :slip_ratio do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ???
      # Unsure; always outputs zero
      struct :tyre_slip do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ???
      # Non-directional slip; not documented
      struct :nd_slip do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ??? Unsure of unit of measure
      # Downward force on each wheel in newtons
      struct :load do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ???
      # Undocumented Something to do with suspension
      struct :dy do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # ??? Unsure of unit of measure
      # Self-aligning torque in Nm
      struct :mz do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Amount of dirt on the tyres; seems to max out around 5
      struct :tyre_dirty_level do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Camber angle in radians
      struct :camber_rad do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Tyre radius in meters
      struct :tyre_radius do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Loaded tyre radius in meters
      struct :tyre_loaded_radius do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # Suspension height (travel) in meters
      struct :suspension_height do
          float :wheel_1
          float :wheel_2
          float :wheel_3
          float :wheel_4
      end

      # How far a car is around the circuit; 0 start, 1 finish
      float :car_position_normalized

      # ???
      # Always outputs zero
      float :car_slope

      # Car world coordinates
      struct :car_coordinates do
          float :x
          float :y
          float :z
      end
    end
  end
end
