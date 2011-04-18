prns = SMQueue(:name => "/queue/prn.incoming",
                       :host => "mq.picklive.com", :adapter => :StompAdapter)

class Sanitize
  attr_accessor :prn
  private :prn=, :prn
  def initialize prn
    self.prn = prn
  end

  def method_missing method_name, *args
    raw_result = prn.send method_name, *args
    sanitize raw_result.to_s
  end

  def sanitize string
    string.gsub! /;|%/, ''
    string
  end
end

class Processor
  def process raw_prn
    db.connect
    prn = Sanitize.new raw_prn
    db.execute "begin
      insert into payments (deposit_id, response, processes_at) values (...);
      update deposits set status = ... where id = ...;
      commit"
    db.disconnect
  end
end
processor = Processor.new

prns.get do |message|
  prn = Prn.from_xml message.body
  processor.process prn
end
