require 'faraday'

# request OpenAI's chat API.
# https://platform.openai.com/docs/api-reference/completions/create

connection = Faraday.new(
  url: 'https://api.openai.com',
  headers: {
    'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
  }
)

connection.post('/v1/completions') do |req|
  req.body = {
    model: 'text-davinci-003',
    prompt: 'Rubyで有名なWebアプリケーションフレームワークには何がありますか？',
    max_tokens: 1024,
    temperature: 0.9,
    stream: true,
  }.to_json

  req.options.on_data = -> (chunk, overall_received_bytes, _env) do
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
