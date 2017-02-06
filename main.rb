#!/usr/bin/ruby

require './lib/bitcoin_rpc.rb'
require 'yaml'
require 'rrd' #RailsRRDTool => https://github.com/joshrendek/rails_rrdtool
$config_f = File.absolute_path('./.config/config.txt')

# For the dots to indicate progress and similar stuff
def print_and_flush(string)
  print string
  $stdout.flush
end

def todo(what)
  puts "The method #{what} is still todo, bye."
  abort "[ERROR] unfinished method."
end

def gets_with_flush(question)
  print_and_flush(question)
  return gets.chomp
end

def write_config()
  config = Hash.new()
  while true
    puts "We need a username, password to connect to a node at IP:Port"
    config[:user] = gets_with_flush("Username : ")
    config[:pass] = gets_with_flush("Password : ")
    config[:ip]   = gets_with_flush("Node-IP  : ")
    config[:port] = gets_with_flush("Node-Port: ")
    puts "*"*80
    puts "Username : #{config[:user]} \n\
Password : #{config[:pass]} \n\
Node-IP  : #{config[:ip]} \n\
Node-Port: #{config[:port]}"
    puts "*"*80
    puts "Is this correct[y]?"
    input = gets.chomp.downcase[0]
    break if input == 'y'
  end
  begin
    dir = "./.config"
    Dir.mkdir(dir) unless Dir.exist?(dir)
    f = File.open($config_f, 'w') { |f| f.puts config.to_yaml }
  rescue
    puts "[ERROR] couldnt write config to file, #{$config_f}"
  ensure
    f.close unless f.nil?
  end
  return config
end

def load_config()
  f = File.open($config_f)
  return YAML::load_file(f)
  rescue
    puts "[ERROR]Could not load config file."
    puts "(W)rite new or (a)bort?"
    input = gets.chomp[0].downcase
    case input
      when 'w'
        return write_config()
      when 'a'
        puts "Exiting. Good bye!"
        abort "[ERROR] No config found."
      else
        abort "[ERROR] No config found."
    end
  ensure
    f.close unless f.nil?
end

def connect_to_node
  c = load_config
  begin
    $node = BitcoinRPC.new("http://#{c[:user]}:#{c[:pass]}@#{c[:ip]}:#{c[:port]}")
  rescue
    puts "couldnt connect to node, make sure the config file is correct."
    p c
    abort "[ERROR] unspecified config error."
  end
end

def update_databases()
  todo("update_databases")
end

# Creates all currentyl needed Databases. 
def create_default_databases()
  # Create subfolder for databases if needed.
  dir = "./databases"
  Dir.mkdir(dir) unless Dir.exist?(dir)
  # TODO: sanity check: if db-file exist, create copy first, make sure the
  # name of the copy makes it highly unlikely to match an already existing
  # file, e.g. current epoch.
  # TODO: Create DBs
end

connect_to_node #creates global instance $node
#update_databases()

create_default_databases()






