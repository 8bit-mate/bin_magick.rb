# BinMagick

A tiny gem to process binary images (using RMagick).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bin_magick'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bin_magick

## Usage

#### Example:
```ruby
require "bin_magick"

# Read image from file using RMagick:
image = Magick::Image.read("file.png").first

# Decorate image object with BinMagick:
bin_img = BinMagick.new(image)

# Convert to binary:
bin_img.to_binary!

# Crop white pixels border:
bin_img.crop_whitespace!

# Display result:
bin_img.display
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bin_magick.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
