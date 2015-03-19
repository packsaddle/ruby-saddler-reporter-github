# Saddler::Reporter::Github

[![Gem Version](http://img.shields.io/gem/v/saddler-reporter-github.svg?style=flat)](http://badge.fury.io/rb/saddler-reporter-github)
[![Build Status](http://img.shields.io/travis/packsaddle/ruby-saddler-reporter-github/master.svg?style=flat)](https://travis-ci.org/packsaddle/ruby-saddler-reporter-github)

## Reporters

This provides saddler reporters for GitHub.

* PullRequestComment
* PullRequestReviewComment
* CommitComment(under construction)
* CommitReviewComment(under construction)

## Usage

```
$ saddler report \
   --require saddler/reporter/github \
   --reporter Saddler::Reporter::Github::PullRequestReviewComment
```

like this.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'saddler-reporter-github'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saddler-reporter-github

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/packsaddle/ruby-saddler-reporter-github/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
