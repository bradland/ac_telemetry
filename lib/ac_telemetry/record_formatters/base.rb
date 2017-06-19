module ACTelemetry
  module RecordFormatters
    class Base
      DELIM = '%'.encode('UTF-16LE')

      def format(record)
        record.to_binary_s
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
end