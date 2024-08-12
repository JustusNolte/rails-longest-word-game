Rails.application.routes.draw do
  get 'games/new', to: 'games#new', as: :new_game
  post 'games/score', to: 'games#score', as: :score_game
  delete 'reset_score', to: 'games#reset_score'
  get "up" => "rails/health#show", as: :rails_health_check
end
