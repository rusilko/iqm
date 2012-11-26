module OrderItemsHelper
  def setup(oi)
    unless oi.errors.any?
      o = oi.build_order
      oi.seats.build.build_client
      c = o.build_customer
      c.addresses.build
    end
    oi
  end

  def link_to_add_participant_row(name, f, association, index) 
    new_object = f.object.send(association).klass.new
    new_object.build_client
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render 'seat_fields', f: builder, t_id: f.object.productable_id, index: index
    end
    link_to(name, '#', class: "btn btn-success add_participant_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
