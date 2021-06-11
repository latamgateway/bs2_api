# Bs2Api

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/bs2_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bs2_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bs2_api

## Usage

Configure it first:
```ruby
Bs2Api.configure do |config|
    config.client_id     = 'you_bs2_client_id'
    config.client_secret = 'you_bs2_client_secret'
    config.pix_key       = 'you_bs2_pix_key'
end
```

Then to create a PIX Payment with PIX KEY:
```ruby

customer = Bs2Api::Customer.new
account  = Bs2Api::Account.new
payer    = Bs2Api::Bank.new
receiver = Bs2Api::Bank.new
payment  = Bs2Api::Payment.new
invoice  = Bs2Api::Invoice.new 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `make console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kimpastro/bs2_api
