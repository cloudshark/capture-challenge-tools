#!/usr/bin/ruby

if ARGV.empty?
  puts "#{$0} <MESSAGE> <secret>"
  puts ""
  puts "Will mix the secret into the message string spaced out so it's not obvious"
  puts "This prints out a payload per line. It's helpful to make the message one"
  puts "case, and the secret something else"
  puts ""
  puts "Example:"
  puts " #{$0} MERRYCHISTMAS cloudshark.io "
  puts ""
  puts "MERRYCHRISTMASMERRYCcHRISTMASMERRYCHRISTMlASMERRYCHRISTMASMERRoYCH"
  puts "RISTMASMERRYCHRISuTMASMERRYCHRISTMASMEdRRYCHRISTMASMERRYCHRsISTMAS"
  puts "MERRYCHRISTMAShMERRYCHRISTMASMERRYCaHRISTMASMERRYCHRISTMrASMERRYCH"
  puts "RISTMASMERRkYCHRISTMASMERRYCHRIS.TMASMERRYCHRISTMASMEiRRYCHRISTMAS"
  exit 1
end

message = ARGV[0]
secret = ARGV[1]

chunk_count = 4
secret_gap = 20 
total_message = secret.length * secret_gap
message_times = 1

while (secret.length * secret_gap + secret_gap) > message_times * message.length
  message_times += 1
end

message = message * message_times
secret_ix = 0

buffer = ""

message.chars.each_with_index do |c, ix|
  if (ix != 0 && ix % secret_gap == 0 && secret[secret_ix])
    buffer += secret[secret_ix]
    secret_ix += 1
  end

  buffer += c
end

chunk_size = message.length / chunk_count
buffer.scan(/.{#{chunk_size}}/).each do |b|
  puts b
end

