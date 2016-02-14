#!/usr/bin/ruby

require "bunny"
conn = Bunny.new
conn.start
ch = conn.create_channel
q = ch.queue("domains", :durable => true, :auto_delete => false)

q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
  puts "Received '#{body}'"
  sleep 1.0
  ch.ack(delivery_info.delivery_tag)
end