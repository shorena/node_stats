#!/usr/bin/ruby

require './lib/bitcoin_rpc.rb'
require 'yaml'
require 'rrd' #RailsRRDTool
$config_f = File.absolute_path('./.config/config.txt')

def todo
  puts "yep, this should write you a config file in the future"
  puts "for now there is just this text"
  puts "bye"
  abort "[ERROR] Hit unfinished method."
end

def write_config()
  todo
end

def load_config()
  begin
    f = File.open($config_f)
    return YAML::load_file(f)
  rescue
    puts "[ERROR]Could not load config file."
    puts "(W)rite new or (a)bort?"
    input = gets.chomp[0].downcase
    case input
      when 'w'
        write_config
      when 'a'
        puts "Exiting. Good bye!"
        abort "[ERROR] No config found."
      else
        abort "[ERROR] No config found."
    end
  ensure
    f.close unless f.nil?
  end
end

def connect_to_node
  c = load_config
  $node = BitcoinRPC.new("http://#{c[:user]}:#{c[:pass]}@#{c[:ip]}:#{c[:port]}")
end

def update_databases
  todo
end

connect_to_node #creates global instance $node
update_databases 
