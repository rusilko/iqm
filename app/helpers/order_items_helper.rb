module OrderItemsHelper
  def setup(oi)
    @training = Training.find(params[:training_id])
    unless oi.errors.any?
      o = oi.build_order
      oi.seats.build.build_client
      # co = o.build_customer(customer_type: "Client")
      co = o.build_customer(customer_type: "Company")
      co.addresses.build
      o.build_coordinator
    else
      # binding.pry
      oi.seats.build.build_client if oi.seats.empty?
      oi.order.build_coordinator unless oi.order.coordinator
    end
    oi
  end

  def link_to_add_seat_row(name, f, association, index, t_id) 
    new_object = f.object.send(association).klass.new
    new_object.build_client
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render 'seat_fields', f: builder, t_id: t_id, index: index
    end
    link_to(name, '#', class: "btn btn-success add_seat_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_address(name, f, association, defaults)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'address_field'}} ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, defaults: defaults)
    end
    link_to(name, '#', class: "btn btn-info add_address_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_coordinator(name, f, association)
    new_object = f.object.send(association).class.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'address_field'}} ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "btn btn-success add_coordinator_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
