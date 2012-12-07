class OrderItem < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :productable, polymorphic: true

  has_many :seats, dependent: :destroy
  has_many :clients, through: :seats

  accepts_nested_attributes_for :seats, allow_destroy: true#, :reject_if => :clients_blank

  before_validation :validating_oi, only: :seats
  before_validation :check_if_client_exists_or_is_already_participating, only: :seats

  attr_accessible :quantity, :productable_id, :productable_type, :order_attributes, :seats_attributes

  def clients_blank(attributes)
    return true if attributes["_destroy"]=="1"
  end
  
  def validating_oi
    logger.fatal   "validating oi"
  end

  def check_if_client_exists_or_is_already_participating
    wrong_seats, good_seats = [], []
    self.seats.each do |seat|
      # first check if there are two identical emails in currently analyzed form
      if seat.client.valid? && (wrong_seats+good_seats).map(&:client).map(&:email).include?(seat.client.email)
        # set the double error virtual attr for seat 
        # (it will be proxied to client in seat before_validation filter)
        seat.double_client_error = :same_form
        wrong_seats << seat
        next
      end     
      c = Client.find_by_email(seat.client.email)
      if c && Seat.find_by_client_id_and_training_id(c.id, seat.training_id)
        seat.client_id = c.id 
        seat.double_client_error = :same_training
        wrong_seats << seat
        else
        good_seats << seat
      end
      logger.fatal "checking seat in oi"
    end
    self.seats = wrong_seats + good_seats
  end

  def seats_with_book
    self.seats.select { |s| s.book=="1" }
  end

  # validates :seats, length: { minimum: 1 }
  # def autosave_associated_records_for_seats
  #   #binding.pry
  #   existing_seats = []
  #   new_seats = []
  #   self.seats.each do |seat|
  #     if existing_seat = Seat.find_by_training_id_and_client_id(seat.training_id, seat.client_id)      
  #       existing_seats << existing_seat
  #     else
  #       new_seats << seat
  #     end
  #   end
  #   self.seats = new_seats + existing_seats
  #   #binding.pry
  # end
end
