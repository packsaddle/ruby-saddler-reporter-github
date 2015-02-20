module Saddler
  module Reporter
    module Github
      class Client
        def initialize(repo)
          @repo = repo
        end

        def commit_comments(sha)
          client.commit_comments(slug, sha).map do |comment|
            Comment.new(sha, comment.body, comment.path, comment.position)
          end
        end

        def create_commit_comment(comment)
          client.create_commit_comment(slug, comment.sha, comment.body,
                                       comment.path, nil, comment.position)
        end

        def issue_comments
          client.issue_comments(slug, pull_id).map do |comment|
            Comment.new(sha = nil, comment.body, comment.path, comment.position)
          end
        end

        def create_issue_comment(comment)
          client.add_comment(slug, pull_id, comment.body)
        end

        def pull_id
          @pull_id ||= begin
            pull_id = ENV['PULL_REQUEST_ID']
            if pull_id
              pull_id.to_i
            elsif @repo.current_branch
              pull = pull_requests.find { |pr| pr[:head][:ref] == @repo.current_branch }
              pull[:number].to_i if pull
            end
          end
        end

        def pull_requests
          @pull_requests ||= client.pull_requests(slug)
        end

        def slug
          @slug ||= @repo.slug
        end

        def client
          @client ||= Octokit::Client.new(access_token: access_token)
        end

        def access_token
          ENV['GITHUB_ACCESS_TOKEN']
        end
      end
    end
  end
end
