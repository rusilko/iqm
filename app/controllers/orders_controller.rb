# encoding: utf-8
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

  def register
    @order    = Order.new
    @training = Training.find(params[:training_id])
  end

  def preview
    @order    = Order.new(params[:order])
    @training = Training.find(params[:training_id])
    # TO DO: this should probably go to one of the models, need to figure out where and then move it
    initialize_order
    if @order.valid?
      session[:order_params] = params[:order]
      render 'preview'
    else
      render 'register'
    end
  end

  def confirm
    @order       = Order.new(session[:order_params])
    @order.terms = params[:order][:terms]
    @training    = Training.find(params[:training_id])
    initialize_order

    if @order.save
      session[:order_params] = nil
      redirect_to trainings_path, :notice => "Dziękujemy za złożenie zamówienia"
    else
      render 'preview'
    end
  end

  private
    def initialize_order
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
          s.client.company = @order.customer if s.client
        end     
        # set coordinator to first client if coordinator wasn't filled in the form
        unless @order.coordinator
          # we need the if so we don't show coordinator on the page with errors
          @order.coordinator  = _1st_seat.client if (_1st_seat.valid? && @order.customer.valid?) 
        else # if coordinator fields where set in the form
          # check if coordinators email is not repeated from one of the clients 
          _1st_order_item.seats.each do |s|
            if @order.coordinator.email == s.client.email
              @order.coordinator = s.client
            end
          end
          # set company for coordinator
          @order.coordinator.company = _customer if @order.coordinator
        end

      end

      @order.order_items.first.quantity = _1st_order_item.seats.size
      @order.order_items[1].quantity = _1st_order_item.seats_with_book.size if @order.order_items.size > 1
    end

end
