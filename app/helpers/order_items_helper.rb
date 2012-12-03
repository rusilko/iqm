module OrderItemsHelper
  def setup(oi)
    @training = Training.find(params[:training_id])
    unless oi.errors.any?
      # prepare order
      o = oi.build_order
      # prepare seat and client
      oi.seats.build.build_client
      # prepare customer (defautls to Company)
      co = o.build_customer(customer_type: "Company")
      # prepare one address for a customer
      co.addresses.build
    else
      # let's just preapre one seat in case it was correct
      oi.seats.build.build_client if oi.seats.empty?
    end
    oi
  end

  def link_to_add_seat_row(name, f, association, index, t) 
    new_object = f.object.send(association).klass.new
    new_object.build_client
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render 'seat_fields', f: builder, t: t, index: index
    end
    link_to(name, '#', class: "btn btn-success add_seat_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_address(name, f, association, defaults, disabled)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'address_field'}} ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, defaults: defaults)
    end
    dis = if disabled then "disabled" else "" end
    link_to(name, '#', class: "btn btn-info add_address_btn #{dis}", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_coordinator(name, f, association, disabled)
    new_object = f.object.send("build_"+association.to_s)
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id, defaults: { wrapper_html: {class: 'address_field'}} ) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    dis = if disabled then "disabled" else "" end
    link_to(name, '#', class: "#{dis} btn btn-success add_coordinator_btn", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
