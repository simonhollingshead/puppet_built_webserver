#!/usr/bin/ruby

require "bunny"
require "whois"
conn = Bunny.new
conn.start
ch = conn.create_channel
q = ch.queue("domains", :durable => true, :auto_delete => false)

whois_props = Whois::Record::Parser::PROPERTIES

q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
  puts "Received '#{body}'"
  # TODO: Check the domain is valid, and is not already looked up recently.
  record = Whois.whois(body)
  whois_props.each{ |property|
    puts "Property: %{property} is %{supported}: %{response}" % {:property=>property, :supported=>record.property_any_supported?(property)?"Supported":"Unsupported", :response=>record.send(property)}
    # TODO: Contact, Registrar and Nameserver are special and need to be further unpacked.  When placed into ElasticSearch, these should be nested fields instead.
  }
  ch.ack(delivery_info.delivery_tag)
end
