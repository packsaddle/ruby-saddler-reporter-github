# Saddler::Reporter::Github

[![Gem version][gem-image]][gem-url] [![CI Status][ci-image]][ci-url] [![yard docs][docs-image]][docs-url]

> [Saddler](https://github.com/packsaddle/ruby-saddler) reporter for GitHub.


## Reporters

This provides saddler reporters for GitHub.

* PullRequestComment
    * `--require saddler/reporter/github`
    * `--reporter Saddler::Reporter::Github::PullRequestComment`
* PullRequestReviewComment
    * `--require saddler/reporter/github`
    * `--reporter Saddler::Reporter::Github::PullRequestReviewComment`
* CommitComment (_under construction_)
    * `--require saddler/reporter/github`
    * `--reporter Saddler::Reporter::Github::CommitComment`
* CommitReviewComment (_under construction_)
    * `--require saddler/reporter/github`
    * `--reporter Saddler::Reporter::Github::CommitReviewComment`


## Usage

```
$ saddler report \
   --require saddler/reporter/github \
   --reporter Saddler::Reporter::Github::PullRequestReviewComment
```

like this. See [Saddler](https://github.com/packsaddle/ruby-saddler).


## Requirement

Set `GITHUB_ACCESS_TOKEN=__your_access_token__` to your environment variable.


### TravisCI

[Travis CI: Encryption keys](http://docs.travis-ci.com/user/encryption-keys/)

```bash
$ gem install travis
$ travis encrypt -r <owner_name>/<repos_name> "GITHUB_ACCESS_TOKEN=<github_token>"
```


### CircleCI

[Environment variables - CircleCI](https://circleci.com/docs/environment-variables)


## API

*[details][docs-url]*.


## For GitHub Enterprise

Put your api endpoint url into environment variable `OCTOKIT_API_ENDPOINT`.

```
$ OCTOKIT_API_ENDPOINT='http://yourhostname.example.com/api/v3/' saddler report --require saddler/reporter/github --reporter ...
```

See: [Using ENV variables](https://github.com/octokit/octokit.rb#using-env-variables)


## Changelog

[CHANGELOG.md](./CHANGELOG.md).


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


## License

© [sanemat](http://sane.jp)

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[ci-url]: https://github.com/packsaddle/ruby-saddler-reporter-github/actions/workflows/ci.yml
[ci-image]: https://img.shields.io/github/actions/workflow/status/packsaddle/ruby-saddler-reporter-github/ci.yml?style=flat-square
[gem-url]: https://rubygems.org/gems/saddler-reporter-github
[gem-image]: http://img.shields.io/gem/v/saddler-reporter-github.svg?style=flat-square
[docs-url]: http://www.rubydoc.info/gems/saddler-reporter-github
[docs-image]: https://img.shields.io/badge/yard-docs-blue.svg?style=flat-square
