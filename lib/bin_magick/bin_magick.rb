# frozen_string_literal: true

require "delegate"
require "rmagick"

#
# Custom instance methods for Magick::Image to process binary images.
#
module BinMagickMethods
  #
  # Check if image has at least one black pixel.
  #
  # @return [Boolean]
  #
  def black_px?
    colors = color_histogram
    colors = colors.transform_keys(&:to_color)

    colors.key?("black")
  end

  #
  # Crop whitespace around the image.
  #
  # @raise [RuntimeError]
  #   Raises if the image is blank, so cropping whitespace is impossible.
  #
  # @return [Magick::Image]
  #   Cropped image.
  #
  def crop_whitespace
    raise("Can't crop whitespace: image is blank") unless black_px?

    bb = bounding_box

    crop(
      bb.x,
      bb.y,
      bb.width,
      bb.height
    )
  end

  #
  # Bang version of crop_whitespace.
  #
  def crop_whitespace!
    cropped_img = crop_whitespace
    __setobj__(cropped_img)
  end

  #
  # Workaround to make 'display' method to work (otherwise it doesn't work with the decorator).
  #
  def display
    __getobj__.display
  end

  #
  # Extends image to new size.
  #
  def extent(width, height, x = 0, y = 0)
    new_img = super(width, height, x, y)
    BinMagick.new(new_img)
  end

  #
  # Bang version of extent.
  #
  def extent!(width, height, x = 0, y = 0)
    extended_img = extent(width, height, x, y)
    __setobj__(extended_img)
  end

  #
  # Scale imgage to fit into size limits.
  #
  # @return [Magick::Image]
  #   Resized image.
  #
  def fit_to_size(max_width, max_height)
    resize_to_fit(max_width, max_height) if oversize?(max_width, max_height)
  end

  #
  # Bang version of fit_to_size.
  #
  def fit_to_size!(max_width, max_height)
    resize_to_fit!(max_width, max_height) if oversize?(max_width, max_height)
  end

  #
  # Return image height.
  #
  # @return [Integer]
  #
  def height
    rows
  end

  #
  # Check if image is larger than provided height OR width.
  #
  # @return [Boolean]
  #
  def oversize?(max_width, max_height)
    columns > max_width || rows > max_height
  end

  #
  # Convert a color image to a binary image.
  #
  # @option [Integer] :n_gray_colors (50)
  #   Number of grayscale colors when image is being quantized.
  #
  # @option [String] :threshold_map ("o2x2")
  #   Dither pattern for convertion from grayscale to binary.
  #
  # @return [Magick::Image]
  #   Binary version of the image.
  #
  def to_binary(threshold_map: "o2x2", n_gray_colors: 50)
    grayscale_img = quantize(n_gray_colors, Magick::GRAYColorspace, false)
    grayscale_img.ordered_dither(threshold_map)
  end

  #
  # Bang version of to_binary.
  #
  def to_binary!(...)
    bin_img = to_binary(...)
    __setobj__(bin_img)
  end

  #
  # Convert binary image to a hash of binary values.
  #
  # @return [Hash{ Array<Integer, Integer> => Integer }]
  #   [x, y] => color (1 for black / 0 for white)
  #
  def to_bin_hash
    bin_img_hash = {}

    each_pixel do |pixel, x, y|
      bin_clr = pixel.to_color == "black" ? 1 : 0
      bin_img_hash[[x, y]] = bin_clr
    end

    bin_img_hash
  end

  #
  # Return image width.
  #
  # @retur [Integer]
  #
  def width
    columns
  end
end
