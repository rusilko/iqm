class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.all
  end

  def show
    @order_item = OrderItem.find(params[:id])
  end

  def new
    @order_item = OrderItem.new
    @training = Training.find(params[:training_id])
    # @order_item.build_order
  end

  def create
    @order_item = OrderItem.new(params[:order_item])
    o = @order_item.order
    # TO DO: this should go to one of the models, need to figure out where and then move it
    if o.customer.is_a?(Client) 
      addresses = o.customer.addresses
      o.customer = @order_item.seats.first.client
      o.customer.addresses = addresses
      o.coordinator = @order_item.seats.first.client
    elsif o.customer.is_a?(Company)      
      # set coordinator to first client if not set in the form
      o.coordinator = @order_item.seats.first.client if (!@order_item.seats.empty? && !o.coordinator && o.customer.valid?)
      # set company for coordinator
      o.coordinator.company = o.customer if o.coordinator
      # set company for clients
      @order_item.seats.each do |s|
        s.client.company = o.customer if s.client
      end
    end


    # if o.customer.is_a?(Client)
    #   params_addresses  = o.customer.addresses
    #   o.customer        = @order_item.seats.first.client
    #   c.addresses       = params_addresses
    #   o.coordinator     = @order_item.seats.first.client
    # elsif c.is_a?(Company)      
    #   # set coordinator to first client if not set in the form
    #   if (@order_item.valid?)
    #     unless o.coordinator || @order_item.seats.empty?
    #       o.coordinator = @order_item.seats.first.client
    #     end
    #   end
    #   # try set company for coordinator
    #   o.coordinator.company = c if o.coordinator
      
    #   # try to set company for clients
    #   @order_item.seats.each do |s|
    #     s.client.company = c if s.client
    #   end
    # end

    if @order_item.save
      redirect_to @order_item, :notice => "Successfully created order item."
    else
      # TO DO: this should also be gone, and actually redirect to friendly url not order_item/...
      @training = Training.find(@order_item.productable_id)
      render "order_items/new"
    end
  end

  def edit
    @order_item = OrderItem.find(params[:id])
  end

  def update
    @order_item = OrderItem.find(params[:id])
    if @order_item.update_attributes(params[:order_item])
      redirect_to @order_item, :notice  => "Successfully updated order item."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to order_items_url, :notice => "Successfully destroyed order item."
  end
end
