module SpreePrzelewy24
  class Engine < Rails::Engine
    
    engine_name 'spree_przelewy24'

    config.autoload_paths += %W(#{config.root}/lib)
    
    initializer "spree.gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::Przelewy24
    end

    config.to_prepare do
      #loads application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

    end

    #config.to_prepare &method(:activate).to_proc
  end
end
