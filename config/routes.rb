Rails.application.routes.draw do
  get 'chatbot', to: 'chat#bot'
  post 'chatbot', to: 'chat#bot'
end
