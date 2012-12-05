# EasyAuth #

[![Build Status](https://secure.travis-ci.org/dockyard/easy_auth.png?branch=master)](http://travis-ci.org/dockyard/easy_auth)
[![Dependency Status](https://gemnasium.com/dockyard/easy_auth.png?travis)](https://gemnasium.com/dockyard/easy_auth)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/dockyard/easy_auth)

Dead simple drop in authentication for Rails 3.2+

## Installation ##

In your Gemfile add the following:

```ruby
gem 'easy_auth'
```

After running Bundler you'll need to install the migrations:

```
rake easy_auth:install:migrations
```

Then run your migrations.

You should also run the generator:

```
rails g easy_auth:setup
```

You will need to mix-in a few modules into your application:

```ruby
class ApplicationController < ActionController::Base
  include EasyAuthHelper
end
```

```ruby
class User < ActiveRecord::Base
   include EasyAuth::Models::Account
end
```

Your application is now ready for EasyAuth.

## Usage ##

You will need to use one of the many
[plugins](https://github.com/dockyard/easy_auth/wiki/Plugins) available for EasyAuth to provide a specific authentication strategy.

## What you get ##

You `User` model will be setup with an association to `identities`. The modeling is pretty simple:

![EasyAuth Identity Modeling](http://i.imgur.com/LBafe.png)


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

[DockYard](http://dockyard.com), LLC &copy; 2012

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
