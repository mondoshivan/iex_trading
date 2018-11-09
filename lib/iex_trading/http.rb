
module IEX_Trading
  class HTTP

    @protocol = 'https'
    @domain = 'api.iextrading.com'
    @api_version = '1.0'

    ###################
    def self.get(endpoint, **args)
      uri = URI.parse("#{@protocol}://#{@domain}/#{@api_version}/#{endpoint}")
      uri.query = URI.encode_www_form(args)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      body = response.body
      begin
        JSON.parse(body)
      rescue JSON::ParserError => e
        body
      end
    end
  end
end