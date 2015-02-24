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

        def commit_patches(sha)
          patches = ::GitDiffParser::Patches[]
          client.commit(slug, sha).files.each do |file|
            patches << ::GitDiffParser::Patch.new(file.patch, file: file.filename, secure_hash: sha)
          end
          patches
        end

        def issue_comments
          client.issue_comments(slug, pull_id).map do |comment|
            Comment.new(sha = nil, comment.body, comment.path, comment.position)
          end
        end

        def create_issue_comment(comment)
          client.add_comment(slug, pull_id, comment.body)
        end

        def pull_request_review_comments
          client.pull_request_comments(slug, pull_id).map do |comment|
            Comment.new(comment.commit_id, comment.body, comment.path, comment.position)
          end
        end

        def pull_request_patches
          patches = ::GitDiffParser::Patches[]
          client.pull_request_files(slug, pull_id).each do |file|
            patches << ::GitDiffParser::Patch.new(file.patch, file: file.filename, secure_hash: @repo.head.sha)
          end
          patches
        end

        def create_pull_request_review_comment(comment)
          client.create_pull_request_comment(slug, pull_id, comment.body,
                                             comment.sha, comment.path, comment.position)
        end

        def pull_id
          @pull_id ||= begin
            pull_id = env_pull_id
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

        def env_pull_id
          if ENV['PULL_REQUEST_ID']
            ENV['PULL_REQUEST_ID']
          elsif ENV['TRAVIS_PULL_REQUEST'] && ENV['TRAVIS_PULL_REQUEST'] != 'false'
            ENV['TRAVIS_PULL_REQUEST']
          end
        end
      end
    end
  end
end
