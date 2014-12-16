require 'rest_client' # Using RestClient library.

module CurrentClient
  extend ActiveSupport::Concern

  # TODO: Should update for handling multiple clients simultaneously.
  RESPONSE_URL = 'http://localhost:3000/read_response'

  private

    # Sends response about the payment back to the store.
    # TODO: Should add code to retry sending if payment was successful.
    def send_response(notice, format)
      # Sets content to send.
      content = nil
      case format
        when :json
          content = notice.to_json
      end
      logger.info "Sending response '#{notice}' to client at #{RESPONSE_URL}..."
      RestClient.post RESPONSE_URL,
                        content,
                        :content_type => :json, :accept => :json
    end
end