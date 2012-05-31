module Spree
  class PaymentMethod::Przelewy24 < PaymentMethod
  
    preference :p24_id_sprzedawcy, :string
    preference :p24_return_url_ok, :string
    preference :p24_return_url_error, :string, :default => "https://ssl.dotpay.pl/"
    preference :url, :string, :default => "https://secure.przelewy24.pl/index.php"
    preference :p24_language, :string, :default => "pl"
    preference :crc_key, :string
    
    def payment_profiles_supported?
      false
    end
  
  end

end
