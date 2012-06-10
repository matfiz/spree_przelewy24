Spree::Core::Engine.routes.append do
  # Add your extension routes here
  namespace :gateway do
    match '/przelewy24/complete/:gateway_id/:order_id' => 'przelewy24#complete', :as => :przelewy24_complete
    match '/przelewy24/:gateway_id/:order_id' => 'przelewy24#show', :as => :przelewy24
    match '/przelewy24/error/:gateway_id/:order_id' => 'przelewy24#error', :as => :przelewy24_error
    match '/przelewy24/comeback/:gateway_id/:order_id' => 'przelewy24#comeback', :as => :przelewy24_comeback
  end
end
