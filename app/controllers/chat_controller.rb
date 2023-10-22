require "openai"

class ChatController < ApplicationController
  def bot
    session[:messages] ||= []

    if params[:user_input].present?
      client = OpenAI::Client.new(access_token: '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')

      # Dynamic user data
      user_data = {
        name: "Luis",
        age: 20,
        average_spent_vs_deposit: "+200",
        balance: "$10,000",
        savings: "$12,000",
        yearly_income: "$100,000"
      }

      context = "You are a financial advisor. Provide tailored advice based on a user's financial situation.
      USER INPUTS:
      Name: #{user_data[:name]}
      Age: #{user_data[:age]}
      Average spent vs deposit: #{user_data[:average_spent_vs_deposit]}
      Balance: #{user_data[:balance]}
      Savings: #{user_data[:savings]}
      Yearly Income: #{user_data[:yearly_income]}
      "

      # Detect user's request type
      request_type = if params[:user_input].include?("saving plan")
                       "saving plan"
                     elsif params[:user_input].include?("retirement plan")
                       "retirement plan"
                     elsif params[:user_input].include?("loan")
                       "loan"
                     elsif params[:user_input].include?("credit card")
                       "credit card"
                     elsif params[:user_input].include?("mortgage")
                       "mortgage"
                     elsif params[:user_input].include?("investment plan")
                       "investment plan"
                     else
                       "general advice"
                     end

      prompt = "Using the following context:#{context} Answer the following question: #{params[:user_input]}. If the user requests a #{request_type}, calculate the amount for the userto save per month to reach their goal. Your response should include specific amounts of money and calculations."

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
      # bot_message.gsub!(/[^a-zA-Z.\s]/, '')

      @bot_response = bot_message

      session[:messages] << {user: user_message, bot: bot_message}
    else
      session[:messages] << {user: nil, bot: "Hello, how can I assist you?"}
    end
  end
end
