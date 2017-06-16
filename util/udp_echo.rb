#!/usr/bin/env ruby

# Listens on same port as AC. Puts received data to stdout. Useful for
# debugging.
# 
# Usage:
#   In one shell, run: ./util/udp_echo.rb
#   In another shell, run: ./ac-telemetry.rb localhost
# 
# Binary data received by UDPEcho will be output to stdout.

require 'socket'
require 'timeout'

class UDPReader
  SERVER_PORT = 9996
  SERVER_IP_ADDR = '0.0.0.0'
  SERVER_POOL_SIZE = Socket::SOMAXCONN

  def initialize
    @connection = UDPSocket.new
    @connection.bind(SERVER_IP_ADDR, SERVER_PORT)
  end

  def start
    loop do
      data, addrinfo = @connection.recvfrom(4096)
      host, port = addrinfo[3], addrinfo[1]
      record = {
        host: host,
        port: port,
        snap: data
      }
      yield record
    end
  end
end

class UDPEcho
  def initialize(args)
    @ac_ip_addr = args.pop
    @buffer = []
  end

  def run!
    listen
    loop do
      puts "Awaiting data..."
      msg = gets.chomp
      puts msg
    end
  end

  def listen
    Thread.new do
      UDPReader.new.start do |record|
        p record
      end
    end
  end
end

begin
  if $0 == __FILE__
    UDPEcho.new(ARGV).run!
  end
rescue Interrupt
  # Ctrl^C
  exit 130
rescue Errno::EPIPE
  # STDOUT was closed
  exit 74 # EX_IOERR
end
