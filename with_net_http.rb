require 'net/http'
require 'json'

# request OpenAI's chat API.
# https://platform.openai.com/docs/api-reference/completions/create

uri =URI('https://api.openai.com/v1/completions')
Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
  http.post(
    uri,
    {
      model: 'text-davinci-003',
      prompt: 'Rubyで有名なWebアプリケーションフレームワークには何がありますか？',
      max_tokens: 1024,
      temperature: 0.9,
      stream: true,
    }.to_json,
    {
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
    },
  ) do |chunk|
    if chunk.start_with?('data: [DONE]')
      puts "-" * 100
    elsif chunk.start_with?('data: ')
      data = JSON.parse(chunk[6..-1])
      data['choices'].each do |choice|
        puts choice['text']
      end
    end
  end
end
