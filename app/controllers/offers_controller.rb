class OffersController < ApplicationController

  def index
    @offers = Offer.all
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params[:offer])
    if @offer.save
      redirect_to offers_path, notice: "Successfully created offer."
    else
      render :new
    end
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])
    if @offer.update_attributes(params[:offer])
      redirect_to edit_offer_path, notice: "Successfully updated offer."
    else
      render :edit
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy
    redirect_to offers_url, notice: "Successfully destroyed offer."
  end
end
