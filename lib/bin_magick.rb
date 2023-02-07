# frozen_string_literal: true

require_relative "bin_magick/bin_magick"
require_relative "bin_magick/version"

require "delegate"
require "rmagick"

#
# Provides custom instance methods for Magick::Image to process binary images.
#
class BinMagick < SimpleDelegator
  include BinMagickMethods
end
