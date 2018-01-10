class WindowMessengerEnvelope
  include ActiveModel::Model

  attr_accessor :type, :payload

  def to_json
    {
      type:    self.type,
      payload: self.payload,
    }.to_json
  end
end
