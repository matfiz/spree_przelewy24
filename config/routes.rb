Rails.application.routes.draw do
  # Add your extension routes here
  namespace :gateway do
    match '/przelewy24/:gateway_id/:order_id' => 'przelewy24#show', :as => :przelewy24
    match '/przelewy24/comeback/' => 'przelewy24#comeback', :as => :przelewy24_comeback
    match '/przelewy24/complete' => 'przelewy24#complete', :as => :przelewy24_complete
  end
end
