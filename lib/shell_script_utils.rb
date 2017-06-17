## Embedded ScriptUtils library; because, scripting!
module ShellScriptUtils
  Version = '2016.10.04.001' # YYYY.MM.DD.vvv

  def status(msg, type=:info, indent=0, io=$stderr)
    case type
    when :error
      msg = red(msg)
    when :success
      msg = green(msg)
    when :warning
      msg = yellow(msg)
    when :info
      msg = blue(msg)
    when :speak
      msg = blue(say(msg))
    end

    io.puts "%s %s" % ["  " * indent, msg]
  end

  def say(msg)
    if ismac?
      `say '#{msg}'`
      msg
    else
      "#{msg}\a\a\a"
    end
  end

  def validation_error(group, msg)
    @validation_errors[group] = [] unless @validation_errors.has_key?(group)
    @validation_errors[group] << msg
  end

  def validation_error_report(options={})
    opts = {
      indent: 0
    }.merge(options)

    unless @validation_errors.empty?
      @validation_errors.each do |group, messages|
        status "Validation errors for group: #{group}", :info, opts[:indent]
        messages.each do |msg|
          status "#{msg}", :info, opts[:indent] + 1
        end
      end
      # exit 1
    end
  end

  def confirm(conf_char="y")
    c = gets.chomp
    if c == conf_char
      true
    else
      false
    end
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end
  def blue(text); colorize(text, 34); end
  def yellow(text); colorize(text, 33); end

  def ismac?
    if `uname -a` =~ /^Darwin/
      true
    else
      false
    end
  end

  # Report builder utility class
  class Report
    include ShellScriptUtils
    attr_accessor :rows

    Version = '2016.10.04.001' # YYYY.MM.DD.vvv

    # Optionally accepts an array of hash rows
    def initialize(data=nil,options={})
      @options = options
      if data
        @rows = data
      else
        @rows = []
      end
    end

    def <<(row)
      @rows << row
    end

    def to_csv
      CSV.generate do |csv|
        csv << @rows.first.keys
        @rows.each.with_index do |row,i|
          # status "Writing row: #{i}", :info
          csv << row.values
        end
      end
    end

    def to_tsv
      out = []
      out << @rows.first.keys.join("\t")
      @rows.each.with_index do |row,i|
        # status "Writing row: #{i}", :info
        out << row.values.join("\t")
      end
      out.join("\n")
    end

    def save(basename = nil, opts={})
      basename ||= 'report'

      opts = {
        format: :csv,
        dir: './tmp/reports'
      }.merge(opts)

      case opts[:format]
      when :csv
        data = to_csv
      when :tsv
        data = to_tsv
      else
        status "Invalid format specified (#{opts[:format]}); must specify :csv or :tsv.", :error
        return nil
      end

      if data.empty?
        status "Nothing to write to file", :warning
        return nil
      end

      filename ||= "#{basename}-#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"

      outfile = File.join(File.expand_path(opts[:dir]), filename)
      shortpath = Pathname(outfile).relative_path_from(Pathname(Dir.pwd))

      status "Writing report to: #{shortpath}"

      FileUtils.mkdir_p(opts[:dir])
      File.open(outfile, 'w') do |file|
        file.puts data
      end

      status "...file written to #{shortpath}\a\a\a", :success, 1

      return true
    end
  end ## End class Report
end ## End module ScriptUtils