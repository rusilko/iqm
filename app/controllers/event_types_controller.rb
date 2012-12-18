class EventTypesController < ApplicationController
  def index
    @event_types = EventType.all
  end

  def show
    @event_type = EventType.find(params[:id])
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(params[:event_type])
    if @event_type.save
      redirect_to @event_type, :notice => "Successfully created event type."
    else
      render :action => 'new'
    end
  end

  def edit
    @event_type = EventType.find(params[:id])
  end

  def update
    @event_type = EventType.find(params[:id])
    if @event_type.update_attributes(params[:event_type])
      redirect_to @event_type, :notice  => "Successfully updated event type."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event_type = EventType.find(params[:id])
    @event_type.destroy
    redirect_to event_types_url, :notice => "Successfully destroyed event type."
  end
end
