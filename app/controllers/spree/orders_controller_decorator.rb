Spree::OrdersController.class_eval do

  durably_decorate :update, mode: 'soft', sha: 'e31b4ad4ddf7360db9928f5c1858e56ee27df503' do
    @order = current_order
    if @order.update_attributes(params[:order])
      render :edit and return unless apply_coupon_code if defined?(Spree::Promo)
      render :edit and return unless apply_gift_code

      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

end
