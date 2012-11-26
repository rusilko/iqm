class TrainingsController < ApplicationController
  def index
    @trainings = Training.all
  end

  def show
    @training = Training.find(params[:id])
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
