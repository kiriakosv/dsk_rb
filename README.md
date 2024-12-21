# DskRb

🚧 UNDER DEVELOPMENT 🚧 

Ruby client for the DSK Bank API.

A Ruby wrapper for DSK Bank's REST API that provides a simple interface for managing banking operations.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add dsk_rb
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install dsk_rb
```

## Usage

```ruby
require 'dsk_rb'

# Initialize the client
# Requires the following parameters:
# - username: Provided by DSK Bank
# - password: Provided by DSK Bank
# - environment: The environment to use. For now, it can only be uat.

client = DskRb::Client.new(username: 'username', password: 'password', environment: 'uat')

# Register a new payment

# The register_payment method requires the following parameters:
# - amount: The amount of the payment
# - return_url: The URL to redirect the user to after the payment is completed
# - description: The description of the payment
# - order_number: The order number

response = client.register_payment(amount: 100, return_url: 'https://example.com', description: 'Test payment', orderNumber: '123')
redirect_url = response['formUrl']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kiriakosv/dsk_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
