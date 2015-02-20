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
