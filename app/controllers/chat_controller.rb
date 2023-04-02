require "openai"

class ChatController < ApplicationController
  def bot
    session[:messages] ||= []

    if params[:user_input].present?
      # User has submitted a message, generate a response from OpenAI
      client = OpenAI::Client.new(access_token: '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')

      context = "YOUR NAME IS ERICA ACT AS MY FINANCIAL ADVISOR, AND FRIEND.

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

      RESPONSE FORMAT EXAMPLE:
      ""[Name], by [adjusting spending/saving $X daily/weekly] for the next [Y months/weeks], you can afford your desired item without repercussions. Would you like to set up a '[Goal] Savings Account' and automatically transfer $X daily/weekly for the duration of the plan?""

      EXAMPLE:
      Samuel, by cutting entertainment spending by $10 daily for 2 months, you can afford your desired item without repercussions. Would you like to set up a 'New Shoes Savings Account' and automatically transfer $10 daily for the next 2 months?
      "

      prompt = "#{context} #{params[:user_input]}"

      response = client.completions(
        parameters: {
          model: "text-davinci-003",
          prompt: prompt,
          max_tokens: 150

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
