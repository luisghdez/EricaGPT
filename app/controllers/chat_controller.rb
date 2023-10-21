require "openai"

class ChatController < ApplicationController
  def bot
    session[:messages] ||= []

    if params[:user_input].present?
      # User has submitted a message, generate a response from OpenAI
      client = OpenAI::Client.new(access_token: "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")

      context = "You are a financial advisor. Provide insightful and tailored advice based on a user's financial situation.
      Consider factors like income, expenses, savings, age, and financial goals to craft your response.
      Always prioritize the user's best financial interests and ensure safety and feasibility of suggestions.
      USER INPUTS:

      Name: Luis
      Age: 20
      Average spent vs deposit: +200
      Balance: $10,000
      Savings: $12,000
      Yearly Income: $100,000
      "

      prompt = "Using the following context:#{context} Answer the following question or input: #{params[:user_input]}.
      Keep your response short and concise."

      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            {
              role: 'user',
              content: prompt
            }
          ],
          max_tokens: 150

        })

      user_message = params[:user_input]
      bot_message = response.parsed_response['choices'][0]['message']['content']
      bot_message.gsub!(/[^a-zA-Z.\s]/, '')

      @bot_response = bot_message


      session[:messages] << {user: user_message, bot: bot_message}
    else
      session[:messages] << {user: nil, bot: "Hello, how can I assist you?"}
    end
  end
end
