require "openai"

class ChatController < ApplicationController
  def bot
    session[:messages] ||= []

    if params[:user_input].present?
      # User has submitted a message, generate a response from OpenAI
      client = OpenAI::Client.new(access_token: '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')
      response = client.completions(
        parameters: {
          model: "text-davinci-003",
          prompt: params[:user_input],
          max_tokens: 50
        })

      user_message = params[:user_input]
      bot_message = response['choices'].first['text'].strip
      bot_message.gsub!(/[^a-zA-Z\s]/, '')

      session[:messages] << {user: user_message, bot: bot_message}
    else
      session[:messages] << {user: nil, bot: "Hello, how can I assist you?"}
    end
  end
end
