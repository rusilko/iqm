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
    
    # TO DO: this should go to one of the models, need to figure out where and then move it
    if @order_item.order.customer.is_a?(Client) 
      nip = @order_item.order.customer.nip
      addresses = @order_item.order.customer.addresses
      @order_item.order.customer = @order_item.seats.first.client
      @order_item.order.customer.nip = nip
      @order_item.order.customer.addresses = addresses
      @order_item.order.coordinator = @order_item.seats.first.client
    elsif @order_item.order.customer.is_a?(Company)      
      # set coordinator to first client if not set in the form
      @order_item.order.coordinator = @order_item.seats.first.client if !@order_item.seats.empty? && !@order_item.order.coordinator
      # set company for coordinator
      @order_item.order.coordinator.company = @order_item.order.customer if @order_item.order.coordinator
      # set company for clients
      @order_item.seats.each do |s|
        s.client.company = @order_item.order.customer if s.client
      end
    end

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
