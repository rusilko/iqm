class OrderItem < ActiveRecord::Base
  attr_accessible :quantity, :productable_id, :productable_type, :order_attributes, :seats_attributes
  validates_associated :seats
  belongs_to :productable, polymorphic: true
  
  belongs_to :order
  accepts_nested_attributes_for :order

  has_many :seats, dependent: :destroy
  accepts_nested_attributes_for :seats, allow_destroy: true, :reject_if => :clients_blank
  before_validation :set_seats_if_exists
  has_many :clients, autosave: true, through: :seats

  def set_seats_if_exists
    self.seats.each do |seat|
      if existing_seat = Seat.find_by_training_id_and_client_id(seat.training_id, seat.client_id)      
        seat = existing_seat
      end
    end
  end

  def autosave_associated_records_for_seats
    existing_seats = []
    new_seats = []
    self.seats.each do |seat|
      if existing_seat = Seat.find_by_training_id_and_client_id(seat.training_id, seat.client_id)      
        existing_seats << existing_seat
      else
        new_seats << seat
      end
    end
    self.seats << new_seats + existing_seats
  end

  def clients_blank(attributes)
    # binding.pry
    return true if attributes["_destroy"]=="1"
    #attributes['client_attributes'].all? { |key, value| key == '_destroy' || value.blank? }
  end
end
