require 'rest_client' # Using RestClient library.

module CurrentClient  # Should be updated to attend multiple clients.
  extend ActiveSupport::Concern

  # TODO: Should update for handling multiple clients simultaneously.
  RESPONSE_URL = 'http://localhost:3000/read_response'

  private

    # Sends response about the payment back to the store.
    # TODO: Should add code to retry sending message to client asynchronously.
    def send_response(response, format)
      # Sets content to send.
      content = nil
      case format
        when :json
          content = response.to_json
      end
      logger.info "Sending response '#{response}' to client at #{RESPONSE_URL}..."
      # redirect_to :controller => 'controllername', :action => 'actionname'
      RestClient.post 'http://localhost:3000/read_response',
                        content,
                        :content_type => :json, :accept => :json

      # Makes a post request with the content and reads redirect_url.
      # redirect_url = ''
      # RestClient.post('http://localhost:3000/read_response',
      #                 content,
      #                 :content_type => format,
      #                 :accept => format) do |response, request, result, &block|
      #   if [301, 302, 307].include? response.code
      #     redirect_url = response.headers[:location]
      #     logger.info "#{redirect_url} Response: #{response}"
      #     logger.info "Following redirection..."
      #     response.follow_redirection(request, result, &block)
      #   else
      #     logger.info "Response: #{response}"
      #     logger.info "Returning..."
      #     response.return!(request, result, &block)
      #   end
      # end
      # Returns redirect_url.
      # redirect_url
    end
end