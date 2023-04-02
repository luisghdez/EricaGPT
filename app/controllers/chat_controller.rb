require "openai"

class ChatController < ApplicationController
  def bot
    prompt = 'YOUR NAME IS ERICA ACT AS MY FINANCIAL ADVISOR, AND FRIEND.

    Help users reach their desired purchase goal efficiently and personally. Analyze their financial information and suggest a tailored savings plan. Consider factors like age, spending habits, and demographics when crafting your response.

    INPUTS:

    Name: Luis
    Age: 20
    Average spent vs deposit: +200
    Balance: $10,000
    Savings: $12,000
    Yearly Income: $100,000
    Spending category (e.g., entertainment, grocery, web shopping)
    OBJECTIVE:
    Create a unique savings plan for each user to afford their desired item as quickly as possible. Calculate the daily or weekly savings required and estimate the time to reach the goal. Offer to set up a dedicated account for their savings.

    RESPONSE FORMAT:
    "[Name], by [adjusting spending/saving $X daily/weekly] for the next [Y months/weeks], you can afford your desired item without repercussions. Would you like to set up a '"[Goal] Savings Account"' and automatically transfer $X daily/weekly for the duration of the plan?"

    EXAMPLE:
    Samuel, by cutting entertainment spending by $10 daily for 2 months, you can afford your desired item without repercussions. Would you like to set up a '"New Shoes Savings Account"' and automatically transfer $10 daily for the next 2 months?'

    @conversations = session[:conversations] || []
    if params[:user_input].present?
      # User has submitted a message, generate a response from OpenAI
      client = OpenAI::Client.new(access_token: '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')
      response = client.completions(
        parameters: {
          model: "text-davinci-003",
          prompt: prompt + params[:user_input],
          max_tokens: 50
        })

      message = response['choices'].first['text'].strip
      message.gsub!(/[^a-zA-Z\s]/, '')
      @conversations << { class: 'user', message: params[:user_input] }
      @conversations << { class: 'bot', message: message }
      session[:conversations] = @conversations
    else
      # User has not submitted a message, show the initial greeting message
      @conversations << { class: 'bot', message: "Hello, how can I assist you?" } unless @conversations.any?
      session[:conversations] = @conversations
    end
  end
end
