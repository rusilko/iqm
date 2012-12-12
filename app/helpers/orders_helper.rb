module OrdersHelper
  def setup(order)    
    unless order.errors.any?
      # prepare 1st order item for participants
      oi1 = order.order_items.build
      # prepare second order item for books
      if @training.has_book?
        oi2             = order.order_items.build
        oi2.productable = @training.book
      end
      # prepare seat and client
      oi1.seats.build.build_client
      # prepare customer (defautls to Company)
      co = order.build_customer(customer_type: "Company")
      # prepare one address for a customer
      co.addresses.build
    else
      # order.coordinator = nil if order.coordinator.email == order.order_items.first.seats.first.client.email
      # # let's just preapre one seat in case it was correct
      # if order.order_items.first.seats.empty?
      #   oi = order.order_items.build
      #   oi.seats.build.build_client
      # end
    end
    order
  end

  def link_to_add_seat_row(name, f, association, index, t) 
    new_object = f.object.send(association).klass.new
    new_object.build_client
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render 'seat_fields', f: builder, t: t, index: index
    end
    link_to(name, '#', id: "add_seat_btn", class: "btn btn-success add_seat_btn", data: {id: id, fields: fields.gsub("\n", "")})
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
