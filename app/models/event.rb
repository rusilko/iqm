class Event < ActiveRecord::Base
  CITIES = %w(Krakow Warszawa Poznan Wroclaw Gdansk)

  belongs_to  :event_type

  has_many    :event_participations, dependent: :destroy
  accepts_nested_attributes_for :event_participations, allow_destroy: true#, :reject_if => :my_all_blank

  has_many    :participants, through: :event_participations
  
  attr_accessible :city, :date, :event_type_id, :name, :price_per_participant, :event_participations_attributes

  validates :name, presence: true,
                   length: { within: 6..50 }
  validates :city, presence: true
  validates :date, presence: true

  def cities
    CITIES
  end

  protected

    def my_all_blank(attributes)
      # binding.pry
      return true if attributes['participant_attributes']['id'].blank? && attributes['participant_attributes']['email'].blank?
      return false
    end
end
