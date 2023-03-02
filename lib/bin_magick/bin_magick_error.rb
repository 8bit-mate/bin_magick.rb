# frozen_string_literal: true

class BinMagickError < ::StandardError
  attr_reader :message

  def initialize(message)
    @message = message
    super()
  end
end
