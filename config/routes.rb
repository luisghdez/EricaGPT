Rails.application.routes.draw do
  get 'sample_page/index'
  get 'chatbot', to: 'chat#bot'
  post 'chatbot', to: 'chat#bot'
end
