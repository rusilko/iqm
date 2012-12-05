class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(params[:order])
    # TO DO: this should probably go to one of the models, need to figure out where and then move it
    _customer       = @order.customer
    _1st_order_item = @order.order_items.first
    _1st_seat       = _1st_order_item.seats.first

    if _customer.is_a?(Client) 

      addresses                 = _customer.addresses
      @order.customer           = _1st_seat.client
      @order.customer.addresses = addresses
      @order.coordinator        = _1st_seat.client

    elsif _customer.is_a?(Company) 

      # set company for seated clients
      _1st_order_item.seats.each do |s|
        s.client.company = _customer if s.client
      end     
      # set coordinator to first client if coordinator wasn't set in the form
      unless @order.coordinator
        @order.coordinator  = _1st_seat.client # if _1st_seat.client.valid?
      # check if coordinators email is not repeated from one of the clients  
      else
        _1st_order_item.seats.each do |s|
          if @order.coordinator.email == s.client.email
            @order.coordinator = nil
            @order.coordinator = s.client
          end
        end
        # set company for coordinator
        @order.coordinator.company = _customer if @order.coordinator
      end

    end
    binding.pry
    if @order.save
      redirect_to @order, :notice => "Successfully created order."
    else
      render :action => 'new'
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      redirect_to @order, :notice  => "Successfully updated order."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url, :notice => "Successfully destroyed order."
  end
end
