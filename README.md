# MSGraph::Client

A simple client library for Microsoft Graph.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'msgraph-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install msgraph-client


## Getting started

To call Graph API using this library, you need an access token.
A choice for aquiring the access token is
[MSIDP::Endpoint](https://github.com/simayosi/rb-msidp-endpoint).

### Usage example
```ruby
require 'msgraph/client'

client = MSGraph::Client.new

# Aquire an access token and set it to `token`

endpoint = "/v1.0/users?$filter=startswith(givenName, 'J')&$top=5"
# For paging
while endpoint
  response = client.request(:get, endpoint, token)
  response[:value].each do |user|
    # do something
  end
  # Next page
  endpoint = response[MSGraph::NEXT_LINK_KEY]
end
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
