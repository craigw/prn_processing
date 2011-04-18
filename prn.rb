class Prn
  SUCCESS = 1
  attr_accessor :attributes

  def self.from_xml xml
    hash = Hash.from_xml xml
    new hash['prn']
  end

  def self.from_request request
    r = Rack::Request.new request
    new r.params
  end

  def initialize attributes = {}
    self.attributes = attributes
  end

  def to_xml
    attributes.to_xml :root => "prn"
  end

  def [] key
    attributes[key.to_s]
  end

  def []= key, value
    attributes[key.to_s] = value
  end

  def deposit_id
    self["strCartID"].to_i
  end

  def amount_in_pennies
    (self["fltAmount"].to_f * 100).to_i
  end

  def currency
    self["strCurrency"]
  end

  def transaction_id
    self["intTransID"]
  end

  def successful?
    status == SUCCESS
  end

  def status
    self["intStatus"].to_i
  end

  def message
    self["strMessage"]
  end
end
