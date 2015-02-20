module Saddler
  module Reporter
    module Github
      module Helper
        def concat_body(data)
          buffer = []
          files = data['checkstyle']['file'] ||= []
          files.each do |file|
            errors = file['error'] ||= []
            errors.each do |error|
              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              buffer << [severity, message].compact.join(': ')
            end
          end
          buffer.join("\n")
        end
      end
    end
  end
end
