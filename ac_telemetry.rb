#!/usr/bin/env ruby

# Depends upon BinData gem. Install using `gem install bindata`.
# 
# Invoke by executing:
# 
#     ./ac-telemetry.rb IP_ADDR_PS4
# 
# Telemetry data is written to stdout, while CLI updates are written to stderr.
# Use shell redirection to send data to files:
# 
#     ./ac-telemetry.rb IP_ADDR_PS4 > telemetry-session.log
# 
# Examples of output provided in examples dir.

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'optparse'
require 'ostruct'
require 'socket'
require 'logger'
require 'shell_script_utils'
require 'ac_telemetry/dispatcher'
require 'ac_telemetry/bin_formats/all'
require 'ac_telemetry/record_formatter'


class ACTelemetryCLI
  include ShellScriptUtils
  include ACTelemetry::BinFormats

  Thread.abort_on_exception=true # add this

  ::Version = [0,0,1]

  AC_PORT = 9996
  AC_HANDSHAKE = Handshaker.new(identifier: 1, version: 1, operation_id: 0).to_binary_s
  AC_UPDATE = Handshaker.new(identifier: 1, version: 1, operation_id: 1).to_binary_s
  AC_SPOT = Handshaker.new(identifier: 1, version: 1, operation_id: 2).to_binary_s
  AC_DISMISS = Handshaker.new(identifier: 1, version: 1, operation_id: 3).to_binary_s

  # Ruby will use ephemeral port when 0 is specified, but locking this to a port allows us to resume.
  CLIENT_PORT = 9997
  CLIENT_IP_ADDR = '0.0.0.0' # Bind to all interfaces.

  def initialize(args)
    Signal.trap("INT") do
      send AC_DISMISS
      $stderr.puts "Sending dismiss and exiting..."
      exit 130
    end

    @options = OpenStruct.new
    @options.verbose = false

    opt_parser = OptionParser.new do |opt|
      opt.banner = "\nUsage: #{$0} [OPTION]... [IP_ADDR]...

  AC Telemetry provides a CLI interface for sending handshake requests to a
  device running Assetto Corsa (AC), and a formatter for parsing and
  formatting the responses.

  When executed, you will be prompted to issue a command. This command will
  instruct the application to send a specific handshake request type to the AC
  application running on the target IP address (IP_ADDR argument).

  AC Telemetry will receive the responses and dispatch them to the formatters
  defined in the ACTelemetry::RecordFormatters sub-classes, for each response
  type.

  "

      opt.on("-r","--raw","Output raw record data.") do |r|
        @options.verbose = r
      end

      opt.on_tail("-h","--help","Print usage information.") do
        $stderr.puts opt_parser
        exit 0
      end

      opt.on_tail("--version", "Show version") do
        puts ::Version.join('.')
        exit 0
      end
    end

    begin 
      opt_parser.parse!
    rescue OptionParser::InvalidOption => e
      $stderr.puts "Specified #{e}"
      $stderr.puts opt_parser
      exit 64 # EX_USAGE
    end

    if ARGV.size < 1
      $stderr.puts "No target IP provided."
      $stderr.puts opt_parser
      exit 64 # EX_USAGE
    end

    @ac_ip_addr = args.pop
    @udp = UDPSocket.new
    @udp.bind(CLIENT_IP_ADDR, CLIENT_PORT)
    @dispatcher = ACTelemetry::Dispatcher.new
    @formatter = ACTelemetry::RecordFormatter.new
    @lock = Mutex.new
  end

  def run!
    listen
    loop do
      timestamp = -> { Time.now.to_s }

      output "Command? [(h)andshake,(u)pdate,(s)pot,(d)ismiss,(q)uit]"
      cmd = gets.chomp

      case cmd
      when "h"
        request :handshake
      when "u"
        request :update
      when "d"
        request :dismiss
      when "s"
        request :spot
      when "q"
        send AC_DISMISS
        output "Sending dismiss and exiting..."
        exit 0
      end
    end
  end

  def request(type)
    case type
    when :handshake
      output "Sending handshake..."
      send AC_HANDSHAKE
    when :update
      output "Sending update..."
      send AC_UPDATE
    when :update
      output "Sending spot..."
      send AC_SPOT
    when :dismiss
      output "Sending dismiss..."
      send AC_DISMISS
    else
      send type
    end
  end

  def listen
    Thread.new do
      reader do |net_record|
        output(@dispatcher.process(net_record), $stdout, true)
      end
    end
  end

  def reader
    loop do
      data, addrinfo = @udp.recvfrom(4096)
      host, port = addrinfo[3], addrinfo[1]
      net_record = {
        host: host,
        port: port,
        bytesize: data.bytesize,
        snap: data
      }
      yield net_record
    end
  end

  def send(msg)
    @udp.send(msg,0,@ac_ip_addr,AC_PORT)
  end

  def output(msg, io = $stderr, flush=false)
    @lock.synchronize do
      io.puts msg unless msg.nil? || msg.empty?
      $stdout.flush if flush
    end
  end
end

begin
  if $0 == __FILE__
    ACTelemetryCLI.new(ARGV).run!
  end
rescue Interrupt
  # Ctrl^C
  exit 130
rescue Errno::EPIPE
  # STDOUT was closed
  exit 74 # EX_IOERR
end
