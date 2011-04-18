#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + 'prn')

class PrnProcessor
  @@incoming = SMQueue :name => "/queue/prn.incoming",
    :host => "mq.picklive.com, :adapter => :StompAdapter

  def call request
    prn = Prn.from_request request
    @@incoming.put prn.to_xml
    [ 200, { "Content-type" => "text/plain" }, "Accepted for processing:\n#{prn.to_xml}" ]
  end
end

run PrnProcessor.new
