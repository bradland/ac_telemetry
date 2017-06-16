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

require 'socket'
require 'ac_telemetry/parser'
require 'ac_telemetry/formats/all'

class ACTelemetryCLI
  include ACTelemetry::Formats

  AC_PORT = 9996
  AC_HANDSHAKE = Handshaker.new(identifier: 1, version: 1, operation_id: 0).to_binary_s
  AC_UPDATE = Handshaker.new(identifier: 1, version: 1, operation_id: 1).to_binary_s
  AC_DISMISS = Handshaker.new(identifier: 1, version: 1, operation_id: 3).to_binary_s

  CLIENT_PORT = 0 # Ruby will use ephemeral port when 0 is specified.
  CLIENT_IP_ADDR = '0.0.0.0' # Bind to all interfaces.

  def initialize(args)
    @ac_ip_addr = args.pop
    @udp = UDPSocket.new
    @udp.bind(CLIENT_IP_ADDR, CLIENT_PORT)
    @parser = ACTelemetry::Parser.new
    @lock = Mutex.new
  end

  def run!
    listen
    loop do
      timestamp = -> { Time.now.to_s }

      output "Command? [(h)andshake,(u)pdate,(d)ismiss,(t)test,(q)uit]"
      cmd = gets.chomp

      case cmd
      when "h"
        request :handshake
      when "u"
        request :update
      when "d"
        request :dismiss
      when "t"
        msg = "Test: #{timestamp.call}"
        output "Sending test message to #{@ac_ip_addr}:#{AC_PORT}"
        request msg
      when "q"
        output "Exiting..."
        exit 0
      end
    end
  end

  def request(type)
    case type
    when :handshake
      output "Sending handshake..."
      send(AC_HANDSHAKE)
    when :update
      output "Sending update..."
      send(AC_UPDATE)
    when :dismiss
      output "Sending dismiss..."
      send(AC_DISMISS)
    else
      send(type)
    end
  end

  def listen
    Thread.new do
      reader do |record|
        output "#{@parser.detect(record).inspect}\n", $stdout
        @lock.synchronize { $stdout.flush }
      end
    end
  end

  def reader
    loop do
      data, addrinfo = @udp.recvfrom(4096)
      host, port = addrinfo[3], addrinfo[1]
      record = {
        host: host,
        port: port,
        bytesize: data.bytesize,
        snap: data
      }
      yield record
    end
  end

  def send(msg)
    @udp.send(msg,0,@ac_ip_addr,AC_PORT)
  end

  def output(msg, io = $stderr)
    @lock.synchronize { io.puts msg }
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
