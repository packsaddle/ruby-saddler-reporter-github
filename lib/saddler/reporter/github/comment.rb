module Saddler
  module Reporter
    module Github
      Comment = Struct.new(:sha, :body, :path, :position) do
        def ==(other)
          position == other.position &&
            path == other.path &&
            body == other.body
        end
      end
    end
  end
end
