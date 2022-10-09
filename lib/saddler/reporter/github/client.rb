module Saddler
  module Reporter
    module Github
      # GitHub client wrapper
      class Client
        # @param repo [Repository] git repository
        # @param log_octokit [Boolean] if true, enable octokit logging
        def initialize(repo, log_octokit: false)
          @repo = repo
          @log_octokit = log_octokit
        end

        # @param sha [String] target commit sha
        #
        # @return [Array<Comment>] parse commit comments into Comment
        def commit_comments(sha)
          client.commit_comments(slug, sha).map do |comment|
            Comment.new(sha, comment.body, comment.path, comment.position)
          end
        end

        # @param comment [Comment] posting commit comment
        #
        # @return [Sawyer::Resource] Commit comment
        #
        # @see ::Octokit::Client::CommitComments.create_commit_comment
        def create_commit_comment(comment)
          client.create_commit_comment(slug, comment.sha, comment.body,
                                       comment.path, nil, comment.position)
        end

        # @param sha [String] target commit sha
        #
        # @return [Patches<Patch>] patches
        def commit_patches(sha)
          patches = Patches.new
          client.commit(slug, sha).files.each do |file|
            patches << Patch.new(file.patch, file: file.filename, secure_hash: sha)
          end
          patches
        end

        # @return [Array<Comment>] parse issue comments into Comment
        def issue_comments
          client.issue_comments(slug, pull_id).map do |comment|
            sha = nil
            Comment.new(sha, comment.body, comment.path, comment.position)
          end
        end

        # @param comment [Comment] posting issue comment
        #
        # @return [Sawyer::Resource] Comment
        #
        # @see ::Octokit::Client::Issues.add_comment
        def create_issue_comment(comment)
          client.add_comment(slug, pull_id, comment.body)
        end

        # @return [Array<Comment>] parse pull request comments into Comment
        def pull_request_review_comments
          client.pull_request_comments(slug, pull_id).map do |comment|
            Comment.new(comment.commit_id, comment.body, comment.path, comment.position)
          end
        end

        # @return [Patches<Patch>] patches
        def pull_request_patches
          patches = Patches.new
          client.pull_request_files(slug, pull_id).each do |file|
            patches << Patch.new(file.patch, file: file.filename, secure_hash: @repo.merging_sha)
          end
          patches
        end

        # @param comment [Comment] posting pull request comment
        #
        # @return [Sawyer::Resource] Hash representing the new comment
        #
        # @see ::Octokit::Client::PullRequests.create_pull_request_comment
        def create_pull_request_review_comment(comment)
          client.create_pull_request_comment(slug, pull_id, comment.body,
                                             comment.sha, comment.path, comment.position)
        end

        # @return [Integer, nil] pull request id
        def pull_id
          return @pull_id unless @pull_id.nil?

          if env_pull_id
            @pull_id = env_pull_id
            return @pull_id
          end

          if @repo.current_branch
            pull = pull_requests.find { |pr| pr[:head][:ref] == @repo.current_branch }
            if pull
              @pull_id = pull[:number].to_i
              return @pull_id
            end
          end
        end

        # @return [Array<Sawyer::Resource>] Array of pulls
        #
        # @see ::Octokit::Client::PullRequests.pull_requests
        def pull_requests
          @pull_requests ||= client.pull_requests(slug)
        end

        # @return [String, nil] repository's slug
        def slug
          @slug ||= @repo.slug
        end

        # @return [Octokit::Client]
        def client
          @client ||= if @log_octokit
                        # see: https://github.com/octokit/octokit.rb/tree/v5.6.1#debugging
                        middleware = Faraday::RackBuilder.new do |builder|
                          builder.use Faraday::Retry::Middleware, exceptions: [Octokit::ServerError] # or Faraday::Request::Retry for Faraday < 2.0
                          builder.use Octokit::Middleware::FollowRedirects
                          builder.use Octokit::Response::RaiseError
                          builder.use Octokit::Response::FeedParser
                          builder.response :logger, nil, { headers: true, bodies: { request: true, response: true } } do |logger|
                            logger.filter(/(Authorization: "(token|Bearer) )(\w+)/, '\1[REMOVED]')
                          end
                          builder.adapter Faraday.default_adapter
                        end
                        Octokit::Client.new(access_token: access_token, middleware: middleware)
                      else
                        Octokit::Client.new(access_token: access_token)
                      end
        end

        # @return [String, nil] github access token
        def access_token
          ENV['GITHUB_ACCESS_TOKEN']
        end

        # @return [Integer, nil] pull request id from environment variables
        def env_pull_id
          @env_pull_id ||= EnvPullRequest.new.pull_request_id
        end
      end
    end
  end
end
