# EasyAuth #

[![Build Status](https://secure.travis-ci.org/dockyard/easy_auth.png?branch=master)](http://travis-ci.org/dockyard/easy_auth)
[![Dependency Status](https://gemnasium.com/dockyard/easy_auth.png?travis)](https://gemnasium.com/dockyard/easy_auth)
[![Code Climate](https://codeclimate.com/github/dockyard/easy_auth.png)](https://codeclimate.com/github/dockyard/easy_auth)

EasyAuth is an authentication library designed specifically for Rails
applications. It provides a clean API with better hooks for controlling
the authentication flow in your application.

## Overview

A `User` or `Account` model has many `Identities`. An `Identity`
represents a strategy for authentication. Strategies are flexible enough to support [Password](https://github.com/dockyard/easy_auth-password), [OAuth](http://oauth.net/), [OAuth2](http://oauth.net/2/), or any custom strategy you require.

![EasyAuth Identity Modeling](http://i.imgur.com/LBafe.png)

## Installation ##

### Gemfile
In your Gemfile add the following:
```ruby
gem 'easy_auth'
```

Run Bundler:
```
bundle install
```

### Migrations
Install EasyAuth's migrations:
```
rake easy_auth:install:migrations
```

Run the migration to create the table for storing our identities:
```
rake db:migrate
```

### Generator
Run the generator:
```
rails generate easy_auth:setup
```

This generates an initializer file for EasyAuth in
`config/initializers/`:

```ruby
EasyAuth.config do |c|
  # put your config options in here
end
```

`EasyAuth.config` takes a block, inside which we specify our strategy
credentials. These get passed along to the authorization server in our attempt to
authenticate; each EasyAuth strategy specifies the appropriate configurations
in its README.

```ruby
EasyAuth.config do |c|
 c.oauth2_client :strategy_name, strategy_key, strategy_secret
end
```  

You'll want to use environment variables for the strategy_key and
strategy_secret, as it is more secure and good
practice to [separate config from code](http://12factor.net/config).

### Mixins
#### EasyAuthHelper
You will need to mix-in a few modules into your application.

The EasyAuthHelper should be included in your application controller; it
gives you some useful methods, like `current_user`, `account_signed_in?`
and
[more](https://github.com/dockyard/easy_auth/blob/master/lib/easy_auth/helpers/easy_auth.rb).

```ruby
class ApplicationController < ActionController::Base
  include EasyAuthHelper
end
```

#### EasyAuth::Model::Account
This module gets mixed into your `Account` or `User` class – the class to
which an `Identity` belongs.

```ruby
class User < ActiveRecord::Base
   include EasyAuth::Models::Account
end
```

### Routes
In order to attempt to authenticate with an authorization server, we need to include
the appropriate routes for each strategy. `EasyAuth::Routes.easy_auth_routes` creates the routes which we'll use
to authenticate; just call it in your routes file:

```ruby
Example::Application.routes.draw do
  easy_auth_routes
end
```

Run `rake routes` from the command line and you'll see that we get 3 new
routes:
1. `sign_out`
1. `oauth2_sign_in` (for OAuth2 strategies)
1. `oauth2_callback` (for OAuth2 strategies)

#### Sign out route
The sign out route is straight-forward. It hits the
`EasyAuth::Controllers::Sessions#destroy` action. You can override this action via
your own `SessionsController` if you care to create one.

#### Sign in route
EasyAuth attempts authenticate the application with the authorization server (using the credentials found in the
initializer). After this is completed, it's up to the authorization
server to
authenticate the user and send a response to our application. The URL
the server attempts to respond to (at least in OAuth2 libraries) is
the callback URL.

#### Callback route
The authorization server response contains the UID of the user attempting to
authenticate with our application. The callback URL hits our
`EasyAuth::Controllers::Sessions#create` action, which calls
`EasyAuth.authenticate` and ensures that we have an Identity for the
user.

If we find an Identity, we set the current_user and call
`#after_successful_sign_in`; otherwise, we instantiate a new identity
from the authorization server's response and call `#after_failed_sign_in`. You
should override these two methods as needed, to control the flow of
authentication in your application. You'll need to include `EasyAuth::Controllers::Sessions`,
to do this:

```ruby
class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  # methods to overwrite
end
```

### Debugging Failures
If you find yourself in the `#after_failed_sign_in` method quite a bit,
one thing to look out for is validation failing on your Identity model.
For example, ensure you're skipping validations on fields that don't
exist for certain strategies; Facebook does not return a password attribute after a user
authenticates, and thus, we shouldn't validate for it when creating a
user:

```ruby
class Identity
  validates :password, presence: true, unless Proc.new {|identity|
identity.type == 'Identities::Oauth2::Facebook' }
end
``` 

## Testing

### Integration Testing
If you need to stub the current user and you're using MiniTest, keep in
mind that `current_user` is an alias provided by EasyAuth for
`current_account`. Thus, you'll need to stub about `current_account`.

```ruby
# test/integration/account_test.rb

user = User.first
AccountController.stub_any_instance(:current_account, user) do
  visit account_path
  # assert something that requires `current_user` or `current_account`
be `user`.
end
```

## Locales
For locales take a look on [locales wiki page](https://github.com/dockyard/easy_auth/wiki/Locales).

## Authors ##

[Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/dockyard/easy_auth/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Please do! We are always looking to improve this gem. Please see our
[Contribution Guidelines](https://github.com/dockyard/easy_auth/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2014

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
