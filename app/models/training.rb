# encoding: utf-8
# == Schema Information
#
# Table name: trainings
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  start_date       :date
#  end_date         :date
#  city             :string(255)
#  price_per_person :integer
#  training_type_id :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Training < ActiveRecord::Base
  has_many :event_type_trainings, dependent: :destroy
  has_many :training_types, through: :event_type_trainings, source: :event_type  

  has_many :training_segments, dependent: :destroy
  has_many :segments, through: :training_segments

  has_many :order_items, as: :productable, include: :seats

  has_many :training_products
  has_many :products, through: :training_products

  accepts_nested_attributes_for :training_segments

  attr_accessible :city, :end_date, :name, :price_per_person, :start_time, :training_type_ids, :number_of_days, 
                  :number_of_hours, :segment_ids, :training_segments_attributes, :introduction, :exemplary, :description

  scope :exemplary, where(exemplary: true)
  scope :real, where(exemplary: false)

  amoeba do
    enable
    include_field :training_segments
    include_field :event_type_trainings
    include_field :training_products
    set exemplary: "false"
  end

  def book
    products.first if self.has_book?
  end

  def has_book?
    !products.empty?
  end

  def price
    self.price_per_person
  end

  def craft!(event_types)
    event_types.each do |event_type|
      self.add_event_type(event_type)
      self.add_segments_from(event_type)
    end
    self.save!
  end

  def add_segments_from(event_type)
    event_type.segments.each do |et_s|
      ts = self.training_segments.build(segment_id: et_s.id)
      ts.name = et_s.name
      ts.scenario = et_s.scenario
      ts.number_of_hours = et_s.number_of_hours
      ts.lineup = et_s.default_lineup
    end
  end

  def add_event_type(event_type)
    self.training_types << event_type
    self.name.nil? ? (self.name = event_type.name) : (self.name << (" " + event_type.name))
    self.description      =  self.description.to_s << event_type.description
    self.number_of_days   =  self.number_of_days.to_i 
    self.number_of_days   += event_type.default_number_of_days
    self.price_per_person =  self.price_per_person.to_f 
    self.price_per_person += event_type.default_price_per_person
  end

  def schedule

    order_by = if self.exemplary
      "lineup ASC"
    else
      "start_time ASC, lineup ASC"
    end

    segs = self.training_segments.order("#{order_by}")

    ret_string = ""
    
    segs.each do |s|      
      ret_string << s.scenario
      ret_string << "(#{s.number_of_hours} godz.)<br/>"
      ret_string << "<strong>Data: #{s.start_time.strftime("%d-%m-%Y")}</strong>" if s.start_time
    end

    ret_string

  end

  def closest_trainings
    if self.exemplary
      "Najbliższe szkolenia"
    else
      nil
    end
  end

  def set_start_time
    new_start_time = self.training_segments.order("start_time ASC").first.try(:start_time)
    self.update_attribute(:start_time, new_start_time) if new_start_time
  end

end
