module Spree
  class PaymentMethod::Przelewy24 < PaymentMethod
    
    attr_accessible :preferred_url, :preferred_test_url, :preferred_crc_key, :preferred_p24_language, :preferred_test_url_transakcja, :preferred_p24_return_url_error, :preferred_p24_return_url_ok, :preferred_p24_id_sprzedawcy
  
    preference :p24_id_sprzedawcy, :string
    preference :p24_return_url_ok, :string, :default => "http://www.motociclisti.pl/gateway/przelewy24/complete"
    preference :p24_return_url_error, :string, :default => "cos"
    preference :url, :string, :default => "https://secure.przelewy24.pl/index.php"
    preference :test_url, :string, :default => "https://sandbox.przelewy24.pl/index.php"
    preference :test_url_transakcja, :string, :default => "https://sandbox.przelewy24.pl/transakcja.php"
    preference :p24_language, :string, :default => "pl"
    preference :crc_key, :string
    
    def payment_profiles_supported?
      false
    end
    
  
  end
end

