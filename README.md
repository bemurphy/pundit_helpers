# PunditHelpers

Authorization helpers for Pundit

## Installation

Add this line to your application's Gemfile:

    gem 'pundit_helpers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pundit_helpers

## Usage

In your base controller or controllers that need Pundit:

```ruby
class ApplicationController < ActionController::Base
  include Pundit
  include PunditHelpers
end
```

The helpers currently add a single `#authorized?` method that is useful
for letting Pundit know that you have checked authorization so that the
`verify_authorized` after filter doesn't raise an exception, and returns
false for failures rather than raising.

```ruby
authorize(post, :show?) # Returns true or raises Pundit::NotAuthorized on failure
authorized?(post, :show?) # Returns true or false
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/pundit_helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
