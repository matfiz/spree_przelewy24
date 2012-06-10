require 'digest/md5'
module Spree
  class Gateway::Przelewy24Controller < Spree::BaseController
    skip_before_filter :verify_authenticity_token, :only => [:comeback, :complete]
    
    # Show form Przelewy24 for pay
    def show
      @order = Order.find(params[:order_id])
      @gateway = @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }
      @order.payments.destroy_all
      payment = @order.payments.create!(:amount => 0, :payment_method_id => @gateway.id)
      
      @p24_session_id = Time.now.to_f.to_s
      @p24_crc = przelewy24_transaction_crc(@gateway,@order,@p24_session_id)
  
      if @order.blank? || @gateway.blank?
        flash[:error] = I18n.t("invalid_arguments")
        redirect_to :back
      else
        @bill_address, @ship_address = @order.bill_address, (@order.ship_address || @order.bill_address)
      end
    end
    
    def error
      
    end
    
    # response from przelewy24
    def complete    
      @order = Order.find_by_number(params[:order_id])
      
      
      
      session[:order_id]=nil
      if @order.state=="complete"
        redirect_to order_url(@order, {:checkout_complete => true, :order_token => @order.token}), :notice => I18n.t("payment_success")
      else
        redirect_to order_url(@order)
      end
    end
  
    # Result from Przelewy24
    def comeback
      @order = Order.find_by_number(params[:control])
      @gateway = @order && @order.payments.first.payment_method
      
      @response = przelewy24_verify(@gateway,@order,params)
  
      
        render :text => @response   
    end
  
  
    private
  
    # validating dotpay message
    def przelewy24_transaction_crc(gateway,order,session_id)    
      calc_md5 = Digest::MD5.hexdigest(session_id + "|" +
        (@gateway.preferred_p24_id_sprzedawcy.nil? ? "" : @gateway.preferred_p24_id_sprzedawcy) + "|" +
        (@gateway.p24_amount(@order.total).nil? ? "" : @gateway.p24_amount(@order.total)) + "|" +
        (@gateway.preferred_crc_key.nil? ? "" : @gateway.preferred_crc_key))
        
        return calc_md5
      
    end
    
    def przelewy24_verify(gateway,order,params)
      require 'net/https'
      require 'open-uri'
      
      params = {:p24_session_id => params[:p24_session_id], :p24_order_id => params[:p24_order_id], :p24_id_sprzedawcy => @gateway.preferred_p24_id_sprzedawcy, :p24_kwota => params[:p24_kwota], :p24_crc => params[:p24_crc]}
      
      url = URI.parse(@gateway.transakcja_url)
      req = Net::HTTP::Post.new(url.path)
      req.form_data = params
      #req.basic_auth url.user, url.password if url.user
      con = Net::HTTP.new(url.host, url.port)
      con.use_ssl = true
      con.start do |http| 
        response = http.request(req)
        return response.body
      end
      
    end
  
    # Completed payment process
    def przelewy24_payment_success(params)
      @order.payment.started_processing
      if @order.total.to_f == params[:amount].to_f      
        @order.payment.complete     
      end    
      
      @order.finalize!
      
      @order.next
      @order.next
      @order.save
    end
  
    # payment cancelled by user (dotpay signals 3 to 5)
    def przelewy24_payment_cancel(params)
      @order.cancel
    end
  
    def przelewy24_payment_new(params)
      @order.payment.started_processing
      @order.finalize!
    end
  
  end
end


