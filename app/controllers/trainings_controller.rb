class TrainingsController < ApplicationController

  before_filter :authorize, except: [:offer, :index, :show]
  
  def offer
    @trainings = Training.exemplary
    @training_months = Training.real.group_by { |t| t.start_time.beginning_of_month }
  end

  def index
    @trainings = Training.real
    @training_months = @trainings.group_by { |t| t.start_time.beginning_of_month }
  end

  def show
    @training = Training.find(params[:id])
    @training_months = Training.real.group_by { |t| t.start_time.beginning_of_month }
  end

  def create_from_exemplary
    from = Training.find(params[:id])
    @training = from.amoeba_dup
    @training.save
    render 'edit'
  end

  def new
    @training = Training.new
  end

  def create
    @training = Training.new(params[:training])
    if @training.save
      redirect_to @training, :notice => "Successfully created training."
    else
      render :action => 'new'
    end
  end

  def edit
    @training = Training.find(params[:id])
  end

  def update
    @training = Training.find(params[:id])
    if @training.update_attributes(params[:training])
      @training.set_start_time
      redirect_to @training, :notice  => "Successfully updated training."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @training = Training.find(params[:id])
    @training.destroy
    redirect_to trainings_url, :notice => "Successfully destroyed training."
  end
end
